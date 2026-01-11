@startuml
|Admin/Cashier|
start
:Receive Patient & Check-in;
:Verify Payment & Assign Doctor;
|System|
:Set Status **SCHEDULED**;

|Doctor|
:Screening & Vaccination;
if (OK?) then (Yes)
  :Fill Health Details;
  :Complete Vaccination;
  
  |System|
  :Set Status **COMPLETED**;
  :Save Record to Local DB;
  :**Sync Record to Blockchain**;
  note right
    (Upload IPFS + Smart Contract Write)
  end note
  
else (No)
  :Defer Appointment;
endif

|User|
:Receive Digital Certificate;
stop
@enduml
