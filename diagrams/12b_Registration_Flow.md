@startuml
|User|
start
:Register (Form / Google);

|System|
:Create Account (Status: New);

|User|
:Complete Profile Form;
note right
  (Health & Personal Info)
end note

|System|
:Save Profile;
:**Generate Blockchain Identity**;
note right
  (Generate Hash/Private Key)
end note
:Activate Account;

|User|
:Onboarding Complete;
stop
@enduml
```
