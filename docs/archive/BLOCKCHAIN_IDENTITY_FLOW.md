# Blockchain Identity Creation Flow

Hướng dẫn chi tiết về cách tạo blockchain identity cho User và FamilyMember trong hệ thống SafeVax.

## 📋 Tổng quan

Hệ thống tạo blockchain identity cho 2 loại đối tượng:
1. **User (ADULT)** - Người dùng đăng ký tài khoản
2. **FamilyMember (CHILD/NEWBORN)** - Thành viên gia đình (con cái)

## 🔐 Blockchain Identity Fields

### User Model
```java
@Column(unique = true)
String blockchainIdentityHash;  // 0x + 64 hex chars (bytes32)

@Column(unique = true)
String did;                      // did:vax:vietnam:{type}:{hash16}

String ipfsDataHash;             // JSON data hash trên IPFS
```

### FamilyMember Model
```java
@Column(unique = true, nullable = false)
String blockchainIdentityHash;  // 0x + 64 hex chars (bytes32)

@Column(unique = true)
String did;                      // did:vax:vietnam:{type}:{hash16}

String ipfsDataHash;             // JSON data hash trên IPFS
```

## 🏗️ Cơ chế tạo Identity

### 1. **User Identity Creation**

#### Flow 1: Register → CompleteProfile

**Step 1: Register (AuthService.register)**
```java
// Tạo User với thông tin cơ bản (email, password, fullName)
User savedUser = userRepository.save(user);

// Generate blockchain identity (KHÔNG có birthday ở bước này)
String identityHash = identityService.generateUserIdentityHash(savedUser);
String did = identityService.generateDID(identityHash, IdentityType.ADULT);
String ipfsDataHash = identityService.generateIdentityDataJson(savedUser);

// Lưu vào database
savedUser.setBlockchainIdentityHash(identityHash);
savedUser.setDid(did);
savedUser.setIpfsDataHash(ipfsDataHash);
savedUser = userRepository.save(savedUser);

// Sync to blockchain (async)
blockchainService.createIdentity(identityHash, did, IdentityType.ADULT, ipfsDataHash, email);
```

**Vấn đề:** Birthday = null → Identity hash không đầy đủ

**Step 2: CompleteProfile (AuthService.completeProfile)**
```java
// Set birthday và patient profile
user.setBirthday(request.getPatientProfile().getBirthday());
user.setPatientProfile(patient);
user.setActive(true);

// Kiểm tra nếu chưa có blockchain identity
if (user.getBlockchainIdentityHash() == null) {
    // Generate identity với đầy đủ thông tin (có birthday)
    String identityHash = identityService.generateUserIdentityHash(user);
    String did = identityService.generateDID(identityHash, IdentityType.ADULT);
    String ipfsDataHash = identityService.generateIdentityDataJson(user);
    
    user.setBlockchainIdentityHash(identityHash);
    user.setDid(did);
    user.setIpfsDataHash(ipfsDataHash);
    
    // Save to database
    user = userRepository.save(user);
    
    // Sync to blockchain
    blockchainService.createIdentity(identityHash, did, IdentityType.ADULT, ipfsDataHash, email);
}
```

#### Flow 2: Google OAuth → CompleteGoogleProfile

**Step 1: OAuth Callback**
```java
// Tạo User từ Google profile
User user = User.builder()
    .email(email)
    .fullName(name)
    .avatar(picture)
    .isActive(false) // Chưa complete profile
    .build();
```

**Vấn đề:** Không có blockchain identity ở bước này

**Step 2: CompleteGoogleProfile**
```java
// Set birthday và patient profile
user.setBirthday(request.getPatientProfile().getBirthday());
user.setPatientProfile(patient);
user.setActive(true);

// ⚠️ MISSING: Không tạo blockchain identity!
userRepository.save(user);
```

**Bug:** User từ Google OAuth không có blockchain identity!

### 2. **FamilyMember Identity Creation**

**FamilyMemberService.addFamilyMember**
```java
// Save family member first
FamilyMember savedMember = familyMemberRepository.save(familyMember);

// Determine identity type based on age
IdentityType idType = identityService.determineIdentityType(savedMember.getDateOfBirth());

// Generate blockchain identity
String identityHash = identityService.generateFamilyMemberIdentityHash(savedMember, "");
String did = identityService.generateDID(identityHash, idType);
String ipfsDataHash = identityService.generateFamilyMemberDataJson(savedMember);

// Save to database
savedMember.setBlockchainIdentityHash(identityHash);
savedMember.setDid(did);
savedMember.setIpfsDataHash(ipfsDataHash);
savedMember = familyMemberRepository.save(savedMember);

// Sync to blockchain
blockchainService.createIdentity(identityHash, did, idType, ipfsDataHash, memberName);
```

## 🔨 Identity Generation Logic

### IdentityService Methods

#### 1. **generateUserIdentityHash**
```java
public String generateUserIdentityHash(User user) {
    String data = String.format("%s:%s:%s:%d",
        user.getEmail(),
        user.getFullName(),
        user.getBirthday() != null ? user.getBirthday().toString() : "",
        System.currentTimeMillis()
    );
    return generateSha256Hash(data); // Returns: 0x + 64 hex chars
}
```

**Input:** email + fullName + birthday + timestamp  
**Output:** `0x` + 64 hex characters (SHA-256)  
**Vấn đề:** Timestamp khác nhau mỗi lần gọi → Hash khác nhau!

#### 2. **generateFamilyMemberIdentityHash**
```java
public String generateFamilyMemberIdentityHash(FamilyMember member, String guardianWallet) {
    String data = String.format("%s:%s:%s:%d",
        guardianWallet,
        member.getFullName(),
        member.getDateOfBirth().toString(),
        System.currentTimeMillis()
    );
    return generateSha256Hash(data); // Returns: 0x + 64 hex chars
}
```

**Input:** guardianWallet + fullName + dateOfBirth + timestamp  
**Output:** `0x` + 64 hex characters (SHA-256)

#### 3. **generateDID**
```java
public String generateDID(String identityHash, IdentityType type) {
    String typePrefix = switch (type) {
        case ADULT -> "user";
        case CHILD -> "child";
        case NEWBORN -> "newborn";
    };
    
    // Remove 0x prefix, take first 16 chars
    String hashPart = identityHash.startsWith("0x") 
        ? identityHash.substring(2, 18) 
        : identityHash.substring(0, 16);
    
    return String.format("did:vax:vietnam:%s:%s", typePrefix, hashPart);
}
```

**Output:** `did:vax:vietnam:user:abc123...` (first 16 hex chars of hash)

#### 4. **generateSha256Hash**
```java
private String generateSha256Hash(String input) throws Exception {
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
    // Add 0x prefix for bytes32 format required by blockchain
    return "0x" + HexFormat.of().formatHex(hash);
}
```

**Output:** `0x` + 64 hex characters (bytes32 format)

## 🔗 Blockchain Sync Flow

### BlockchainService.createIdentity

```java
public BlockchainIdentityResponse createIdentity(
    String identityHash,  // 0x + 64 hex
    String did,           // did:vax:vietnam:...
    IdentityType idType,  // ADULT/CHILD/NEWBORN
    String ipfsDataHash,  // JSON hash
    String email          // For logging
) {
    // Call blockchain-service API
    POST /api/identity/create
    {
        "identityHash": "0xabc...",
        "did": "did:vax:vietnam:user:abc...",
        "guardianAddress": null,  // Backend wallet used
        "idType": "ADULT",
        "ipfsDataHash": "QmXyz...",
        "email": "user@example.com"
    }
}
```

### Smart Contract: SafeVaxIdentity.createIdentity

```solidity
function createIdentity(
    bytes32 _identityHash,      // Must be bytes32 format (0x + 64 hex)
    string memory _did,
    address _guardian,          // Backend wallet address
    IdentityType _idType,       // 0=ADULT, 1=CHILD, 2=NEWBORN
    string memory _ipfsDataHash
) external {
    require(!identityExists[_identityHash], "Identity already exists");
    require(_guardian != address(0), "Invalid guardian address");
    require(bytes(_did).length > 0, "DID cannot be empty");
    
    identities[_identityHash] = Identity({
        identityHash: _identityHash,
        did: _did,
        guardian: _guardian,
        idType: _idType,
        createdAt: block.timestamp,
        isActive: true,
        ipfsDataHash: _ipfsDataHash
    });
    
    identityExists[_identityHash] = true;
    
    emit IdentityCreated(_identityHash, _did, _guardian, _idType, block.timestamp);
}
```

## ⚠️ Các vấn đề hiện tại

### 1. **Timestamp trong Hash → Duplicate Issue**

**Vấn đề:**
- `register()` tạo hash lúc 10:00:00 → `0xabc123...`
- `completeProfile()` tạo hash lúc 10:01:00 → `0xdef456...` (khác!)
- Cả 2 lần đều call blockchain → Lần 2 sẽ fail vì hash mới

**Giải pháp:**
- ✅ Option 1: Chỉ tạo identity trong `completeProfile()` (khi có đủ data)
- ✅ Option 2: Không dùng timestamp, dùng data deterministic
- ❌ Option 3: Check exist trước khi tạo (đã làm trong code mới)

### 2. **Google OAuth User không có Identity**

**Vấn đề:**
- `completeGoogleProfile()` không tạo blockchain identity
- User có profile nhưng không có hash/did/ipfsDataHash

**Giải pháp:**
- Thêm logic tạo identity vào `completeGoogleProfile()` giống `completeProfile()`

### 3. **Birthday null trong register()**

**Vấn đề:**
- Hash được tạo khi birthday = null
- Identity không đầy đủ thông tin

**Giải pháp:**
- Chỉ tạo identity trong `completeProfile()` khi có birthday

### 4. **Smart Contract: Identity Already Exists**

**Lỗi:**
```
Transaction has been reverted by the EVM
require(!identityExists[_identityHash], "Identity already exists")
```

**Nguyên nhân:**
- Identity hash đã được tạo trước đó
- Gọi createIdentity 2 lần với cùng hash

**Giải pháp:**
- Check exist trong database trước khi sync
- Hoặc catch error và log warning

## ✅ Best Practices

### 1. **Deterministic Hash Generation**
```java
// ❌ BAD: Dùng timestamp
String data = email + ":" + name + ":" + System.currentTimeMillis();

// ✅ GOOD: Chỉ dùng user data
String data = email + ":" + name + ":" + birthday + ":" + identityNumber;
```

### 2. **Single Point of Identity Creation**
```java
// ✅ Chỉ tạo identity 1 lần trong completeProfile
if (user.getBlockchainIdentityHash() == null) {
    // Generate and sync
}
```

### 3. **Check Blockchain Before Sync**
```java
// ✅ Check exist trước khi tạo
var existing = blockchainService.getIdentity(hash);
if (existing == null) {
    blockchainService.createIdentity(...);
}
```

### 4. **Error Handling**
```java
// ✅ Catch exception và continue
try {
    blockchainService.createIdentity(...);
} catch (Exception e) {
    log.error("Failed to sync identity", e);
    // Continue - user is still created in database
}
```

## 📊 Identity Type Mapping

| Age | Identity Type | DID Prefix | Use Case |
|-----|--------------|------------|----------|
| 18+ | ADULT | `did:vax:vietnam:user:` | Normal users |
| 1-17 | CHILD | `did:vax:vietnam:child:` | Children with guardian |
| 0-11 months | NEWBORN | `did:vax:vietnam:newborn:` | Newborns |

## 🔄 Complete Flow Diagram

```
┌─────────────────┐
│ User Register   │
└────────┬────────┘
         │
         ▼
┌────────────────────────────┐
│ Generate Identity Hash     │ ⚠️ Birthday = null
│ (email + name + timestamp) │
└────────┬───────────────────┘
         │
         ▼
┌────────────────────┐
│ Save to Database   │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ Sync to Blockchain │ ⚠️ Có thể fail nếu hash trùng
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ Complete Profile   │
└────────┬───────────┘
         │
         ▼
┌────────────────────────────┐
│ Check if hash exists       │
└────────┬───────────────────┘
         │
         ├─ Yes ─┐
         │       ▼
         │   ┌───────────────────┐
         │   │ Skip creation     │
         │   └───────────────────┘
         │
         ├─ No ──┐
         │       ▼
         │   ┌────────────────────────────┐
         │   │ Generate NEW Hash          │ ⚠️ Timestamp khác!
         │   │ (now with birthday)        │
         │   └────────┬───────────────────┘
         │            │
         │            ▼
         │   ┌────────────────────┐
         │   │ Sync to Blockchain │ ❌ FAIL: Hash trùng!
         │   └────────────────────┘
         │
         ▼
┌────────────────────┐
│ User Active        │
└────────────────────┘
```

## 🛠️ Recommended Fix

### Solution 1: Only Create in CompleteProfile (Recommended)

**AuthService.register**
```java
// ❌ Remove blockchain identity creation
// Just create user, no identity yet
User savedUser = userRepository.save(user);
```

**AuthService.completeProfile**
```java
// ✅ Create identity here (when birthday available)
if (user.getBlockchainIdentityHash() == null) {
    String identityHash = identityService.generateUserIdentityHash(user);
    // ... sync to blockchain
}
```

### Solution 2: Deterministic Hash (No Timestamp)

**IdentityService.generateUserIdentityHash**
```java
public String generateUserIdentityHash(User user) {
    // ✅ Use only user data, no timestamp
    String data = String.format("%s:%s:%s:%s",
        user.getEmail(),
        user.getFullName(),
        user.getBirthday() != null ? user.getBirthday().toString() : "",
        user.getPatientProfile() != null ? user.getPatientProfile().getIdentityNumber() : ""
    );
    return generateSha256Hash(data);
}
```

## 📚 References

- **Smart Contract**: `blockchain-service/contracts/SafeVaxIdentity.sol`
- **Backend Service**: `backend/src/main/java/com/dapp/backend/service/IdentityService.java`
- **Auth Service**: `backend/src/main/java/com/dapp/backend/service/AuthService.java`
- **Family Service**: `backend/src/main/java/com/dapp/backend/service/FamilyMemberService.java`
- **Blockchain Service**: `backend/src/main/java/com/dapp/backend/service/BlockchainService.java`
