@startuml
actor User
participant "Chat UI" as UI
participant "Backend Service" as BE
participant "Vector DB" as VDB
participant "LLM (AI)" as AI

User -> UI: Ask Question
UI -> BE: POST /chat/query
activate BE

BE -> VDB: Search Relevant Docs
activate VDB
VDB --> BE: Context
deactivate VDB

BE -> BE: Construct Prompt + Context

BE -> AI: Generate Answer
activate AI
AI --> BE: Answer
deactivate AI

BE --> UI: Return Answer
deactivate BE

UI --> User: Display Response
@enduml
```
