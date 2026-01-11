@startuml
|User|
start
:Access Login;
if (Method?) then (Google)
  :Auth with Google;
else (Password)
  :Enter Credentials;
endif

|System|
:Verify Credentials;
note right
  (Check DB or Google Token)
end note

if (Valid?) then (Yes)
  :Generate JWT Tokens;
  |User|
  :Login Success;
else (No)
  :Return Error;
  |User|
  :Show Login Failed;
endif
stop
@enduml
```
