@startuml
|User|
start
:Login & **Enter Booking Info**;
note right
  (Vaccine, Center, Date, Profile)
end note

:Select Payment Method;

if (Method == Cash?) then (Yes)
  :Confirm Booking;
else (Online Payment)
  :Proceed to Payment Gateway / Wallet;
  |System|
  :Process Transaction;
  |User|
endif

|System|
if (Valid?) then (Yes)
  :Update Stock & Set Status **PENDING**;
  :Send Confirmation Email;
else (No)
  :Show Error;
  stop
endif

|User|
:Receive Success Notification;
stop
@enduml
