# System Process Flowcharts

This file contains simplified flowcharts for key system processes.

## 1. Booking Process Flowchart
```plantuml
@startuml
start
:User Selects Vaccine & Center;
:Choose Date & Time;
if (Book for Family?) then (Yes)
  :Select Member Profile;
else (No)
  :Use Own Profile;
endif

if (Payment Method?) then (Cash)
  :Submit Order;
else (Online)
  :Pay via Gateway/Wallet;
endif

:System Updates Status **PENDING**;
:Send Confirmation Info;
stop
@enduml
```

## 2. Clinical Process Flowchart Diagram
```plantuml
@startuml
start
:Patient Checks-in at Center;
:Staff Verifies Info;
:Assign Doctor to Patient;
:Status -> **SCHEDULED**;

:Doctor Screens Patient;
if (Ok to Inject?) then (Yes)
  :Injection Performed;
  :Doctor Confirms Completion;
  :System Saves Record;
  fork
    :Upload to IPFS;
    :Write Hash to Blockchain;
  fork again
    :Issue Digital Certificate;
  end fork
else (No)
  :Defer/Cancel Appointment;
endif
stop
@enduml
```

## 3. Family Member Management Flowchart Diagram
```plantuml
@startuml
start
:Access Family Dashboard;
if (Add New Member?) then (Yes)
  :Input Info (Name, DOB);
  :System Validates;
  :Generate **Blockchain Identity**;
  :Save to Database;
else (Booking)
  :Select Member;
  :Proceed to Booking Flow;
endif
stop
@enduml
```

## 4. Registration & Onboarding Flowchart Diagram
```plantuml
@startuml
start
:User Registers (Google/Form);
:Create Account (New);
:User Completes Profile (Health Info);
:System Validates Data;
:Generate **Identity Hash** (Blockchain);
:Activate Account;
stop
@enduml
```

## 5. Login Flowchart Diagram
```plantuml
@startuml
start
:Enter Credentials / Google Auth;
if (Valid?) then (Yes)
  :Generate JWT;
  :Grant Access to Dashboard;
else (No)
  :Show Error Message;
endif
stop
@enduml
```

## 6. Verification Flowchart Diagram
```plantuml
@startuml
start
:Scan QR Code / Enter ID;
:Fetch Metadata from Smart Contract;
:Fetch Data from IPFS (using Hash);
:Compare IPFS Data vs Local DB;

if (Match?) then (Yes)
  :Show **AUTHENTIC** Record;
else (No)
  :Show **TAMPERED** Warning;
  :Display IPFS Data (Trusted Source);
endif
stop
@enduml
```
