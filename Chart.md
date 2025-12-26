
# Activity Diagrams (PlantUML)

## 1. Verification Process
Based on `PublicVerificationController` and `VaccineRecordService`.

```plantuml
@startuml
skinparam conditionStyle diamond
skinparam shadowing false
skinparam handwritten false
skinparam backgroundColor white

|User|
start
:Access Verify Page;
if (Method?) then (IPFS Hash)
  :Enter IPFS Hash;
  :Call /verify-vaccine/{hash};
else (Identity & Dose)
  :Enter Identity + Details;
  :Call /verify-dose;
endif

|System|
:Search Local Database;
if (Found in DB?) then (No)
  :Return "Not Found";
  |User|
  :View Error;
  stop
else (Yes)
  |System|
  if (Blockchain Service Available?) then (No)
    :Return "Service Unavailable";
    stop
  else (Yes)
    :Get BlockchainRecordID from DB;
    :Query Smart Contract (getVaccineRecord);
    if (Contract Data Exists?) then (No)
      :Return "Verification Failed";
      stop
    else (Yes)
      :Compare Local IPFS vs Chain IPFS;
      if (Hash Mismatch?) then (Yes)
        :Return "Integrity Error";
        stop
      else (No)
        :Return Verified Record;
        |User|
        :View Verified Certificate;
        stop
      endif
    endif
  endif
endif
@enduml
```

## 2. User Registration Flow
Based on `AuthController`.

```plantuml
@startuml
skinparam conditionStyle diamond
skinparam shadowing false

|User|
start
:Fill Registration Form;
:Click Register;

|System|
:POST /api/auth/register;
if (Validation/Email Exists?) then (Error)
  :Return 400 Bad Request;
  |User|
  :Show Error Message;
  split
    :Retry;
    detach
  split end
else (Success)
  |System|
  :Create User Entity;
  :Generate Access & Refresh Tokens;
  :Return LoginResponse (isNewUser=true);
  |User|
  :Receive Token & Success;
  :View "Complete Profile" Form;
  :Fill Health/Profile Info;
  :Click Complete;
  |System|
  :POST /api/auth/complete-profile;
  :Update User Entity;
  :Regenerate Tokens;
  :Return Updated User;
  |User|
  :Redirect to Dashboard;
  stop
endif
@enduml
```

## 3. Vaccine Booking Flow
Based on `BookingController` and `AppointmentService`.

```plantuml
@startuml
skinparam conditionStyle diamond
skinparam shadowing false

|User|
start
:Select Vaccine/Center;
:Input Details;
if (Flow?) then (First Dose)
  :API: /api/bookings;
else (Next Dose)
  :API: /api/bookings/next-dose;
endif

|System|
:Validate Stock & Slots;
:Check Existing Active Appts;
if (Validation Fail?) then (Yes)
  :Return Error;
  stop
else (No)
  :Create Appointment (INITIAL/PENDING);
  :Create PaymentRecord (INITIATED);
  
  if (Payment Method?) then (CASH)
    :Set Status PENDING;
    :Send Email Notification;
    :Return PaymentResponse (No URL);
    |User|
    :Show Success Page;
    stop
  elseif (BANK / PAYPAL)
    :Generate Gateway URL;
    :Return PaymentResponse (URL);
    |User|
    :Redirect to Gateway;
    :Complete Payment;
    |System|
    :Callback (VNPay/PayPal);
    if (Success?) then (Yes)
      :Update Payment -> SUCCESS;
      :Update Appt -> SCHEDULED;
    else (No)
      :Update Payment -> FAILED;
    endif
    |User|
    :Redirect to Result Page;
    stop
  else (METAMASK)
    :Calculate ETH Amount;
    :Return PaymentResponse (Amount, ID);
    |User|
    :Trigger Metamask Wallet;
    :Sign & Send Transaction;
    :Wait for Confirmation;
    :Call POST /api/payments/meta-mask;
    |System|
    :Verify Transaction;
    :Update Payment -> SUCCESS;
    :Update Appt -> SCHEDULED;
    |User|
    :Show Success Page;
    stop
  endif
endif
@enduml
```

## 4. Booking Sequence Diagram
Based on `BookingController` and `AppointmentService`.

```plantuml
@startuml
actor User
participant "BookingController" as BC
participant "AppointmentService" as AS
participant "VaccineRepository" as VR
participant "PaymentService" as PS
participant "PaymentGateway" as PG

User -> BC: POST /api/bookings
activate BC
BC -> AS: createBooking(request)
activate AS
AS -> VR: checkStock()
alt Out of Stock
    AS --> BC: Error (Out of Stock)
    BC --> User: 400 Bad Request
else In Stock
    AS -> AS: Validate Slot Availability
    AS -> VR: decreaseStock()
    AS -> AS: saveAppointment(INITIAL)
    AS -> AS: createPayment(INITIATED)
    
    alt Payment = BANK/PAYPAL
        AS -> PS: createPaymentUrl()
        PS -> PG: Request URL
        PG --> PS: URL
        PS --> AS: URL
        AS --> BC: PaymentResponse(URL)
        BC --> User: Redirect to Payment Gateway
    else Payment = METAMASK
        AS -> AS: Calculate ETH Amount
        AS --> BC: PaymentResponse(Amount, ID)
        BC --> User: Trigger Wallet Interaction
    else Payment = CASH
        AS -> AS: setStatus(PENDING)
        AS -> AS: sendEmail()
        AS --> BC: PaymentResponse(Success)
        BC --> User: Booking Confirmed
    end
end
deactivate AS
deactivate BC
@enduml
```

## 5. Blockchain Recording Sequence Diagram
Based on process in `VaccineRecordService`.

```plantuml
@startuml
actor Doctor
participant "AppointmentController" as AC
participant "AppointmentService" as AS
participant "VaccineRecordService" as VRS
participant "BlockchainService" as BS
participant "IPFS" as IPFS
participant "SmartContract" as SC

Doctor -> AC: completeAppointment(id, details)
activate AC
AC -> AS: complete(id, details)
activate AS
AS -> AS: Update Status (COMPLETED)
AS -> VRS: createFromAppointment(appt, details)
activate VRS
VRS -> VRS: Save Local Record

alt Blockchain Available
    VRS -> BS: uploadToIpfs(FHIR_JSON)
    activate BS
    BS -> IPFS: Upload
    IPFS --> BS: Hash (CID)
    BS --> VRS: Hash
    deactivate BS
    
    VRS -> VRS: Update Local (IPFS Hash)
    
    VRS -> BS: createVaccineRecord(record)
    activate BS
    BS -> SC: pushRecord(hash, patientId, etc.)
    SC --> BS: Transaction Hash
    BS --> VRS: Success (TxHash)
    deactivate BS
    
    VRS -> VRS: Update Local (TxHash, BlockNum)
end

VRS --> AS: Record Created
deactivate VRS

AS --> AC: Success
deactivate AS
AC --> Doctor: Appointment Completed
deactivate AC
@enduml
```

## 6. Overall System Flowchart
General process flow from registration to certification.

```plantuml
@startuml
start
:User Registers;
if (Verify Email?) then (Yes)
  :Login;
else (No)
  :Stop;
  stop
endif

:Complete Profile;
:Search Vaccine/Center;
:Book Appointment;

if (Payment?) then (Online)
  :Pay via Gateway;
  if (Success?) then (Yes)
    :Status = SCHEDULED;
  else (No)
    :Status = CANCELLED;
    stop
  endif
else (Cash)
  :Status = PENDING;
  :Wait for Admin/Cashier Approval;
endif

:Go to Center;
:Doctor Checkup;
if (Eligible?) then (Yes)
  :Get Vaccinated;
  :Doctor Completes Record;
  fork
    :Update Local DB;
  fork again
    :Upload to IPFS;
    :Write to Blockchain;
  end fork
  :Receive Digital Certificate;
else (No)
  :Defer / Cancel;
endif
stop
@enduml
```