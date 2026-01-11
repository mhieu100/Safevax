@startuml
|User|
start
:Scan QR / Enter ID;
:Submit Request;

|System|
:Search Local Database;
:Get **Blockchain Record ID**;

:Fetch Metadata from **Smart Contract**;
note right
  (Get IPFS Hash & Signatures)
end note

:Fetch Medical Data from **IPFS**;
note right
  Trustless Source of Truth
end note

:Compare **Local DB** vs **IPFS Data**;

if (Match?) then (Yes)
  :Mark as **AUTHENTIC**;
else (No)
  :Mark as **TAMPERED (Local DB Modified)**;
  :Use IPFS Data as Valid Record;
endif

|User|
:View Verified Certificate;
stop
@enduml
```

## 2. Blockchain Verification Sequence

```plantuml
@startuml
actor Verifier
participant "Verification UI" as UI
participant "Backend Server" as Server
participant "Blockchain (Contract)" as Chain
participant "IPFS Network" as IPFS

Verifier -> UI: Scan QR / Enter ID
UI -> Server: Verify Record
activate Server

Server -> Server: Lookup ID
Server -> Chain: Get Record (by ChainID)
activate Chain
Chain --> Server: {IPFS Hash, Owner, ...}
deactivate Chain

Server -> IPFS: Fetch Content (by Hash)
activate IPFS
IPFS --> Server: Medial Details (JSON)
deactivate IPFS

Server -> Server: Compare (Local Data vs IPFS Data)

alt Matches
    Server --> UI: Status: **VALID**
else Mismatch (Local Modified)
    Server --> UI: Status: **WARNING (Local Tampered)**
    note right
      Display Data from IPFS
    end note
end
deactivate Server

UI --> Verifier: Show Verified Details
@enduml
