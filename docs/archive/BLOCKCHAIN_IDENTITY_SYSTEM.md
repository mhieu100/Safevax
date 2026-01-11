# Blockchain Identity & Vaccine Record System

## Tổng quan

Hệ thống định danh phi tập trung (DID) và ghi chép vaccine trên blockchain cho SafeVax, giải quyết vấn đề định danh cho trẻ em chưa có giấy tờ tùy thân.

## Kiến trúc

### 1. Blockchain Identity Model

#### User (Người lớn)
- `blockchainIdentityHash`: SHA-256 hash làm unique identifier trên blockchain
- `did`: Decentralized Identifier (format: `did:vax:vietnam:user:xxx`)
- `ipfsDataHash`: IPFS hash chứa dữ liệu chi tiết
- `walletAddress`: Địa chỉ ví blockchain (đã có sẵn)

#### FamilyMember (Trẻ em)
- `blockchainIdentityHash`: SHA-256 hash (required, unique)
- `did`: DID cho trẻ em (format: `did:vax:vietnam:child:xxx`)
- `ipfsDataHash`: IPFS hash
- `guardianWalletAddress`: Địa chỉ ví của cha/mẹ
- `birthCertificateNumber`: Số giấy khai sinh (optional, có thể thêm sau)
- `identityNumber`: CCCD/CMND (optional, thêm khi đủ 14 tuổi)

### 2. Identity Generation Process

```java
// For User (Adult)
String hash = SHA256(email + fullName + dateOfBirth + timestamp)
String did = "did:vax:vietnam:user:" + hash.substring(0, 16)

// For FamilyMember (Child/Newborn)
String hash = SHA256(guardianWallet + childName + dateOfBirth + timestamp)
String did = "did:vax:vietnam:child:" + hash.substring(0, 16)
```

### 3. Vaccine Record Model

Khi appointment được complete, tự động tạo `VaccineRecord`:

**Thông tin bệnh nhân:**
- `user` hoặc `familyMember`: Reference đến người được tiêm
- `patientName`: Tên bệnh nhân (denormalized)
- `patientIdentityHash`: Blockchain identity hash

**Thông tin vaccine:**
- `vaccine`: Loại vaccine
- `doseNumber`: Mũi thứ mấy
- `lotNumber`: Số lô vaccine
- `expiryDate`: Hạn sử dụng
- `manufacturer`: Nhà sản xuất

**Chi tiết tiêm chủng:**
- `vaccinationDate`: Ngày tiêm thực tế
- `site`: Vị trí tiêm (LEFT_ARM, RIGHT_ARM, etc.)
- `doctor`: Bác sĩ thực hiện
- `center`: Trung tâm tiêm chủng
- `appointment`: Reference đến appointment

**Thông tin y tế:**
- `notes`: Ghi chú
- `adverseReactions`: Phản ứng phụ
- `followUpDate`: Ngày tái khám (nếu cần)

**Blockchain integration:**
- `blockchainTxHash`: Transaction hash trên blockchain
- `ipfsHash`: IPFS hash chứa dữ liệu chi tiết
- `digitalSignature`: Chữ ký số của bác sĩ
- `isVerified`: Đã verify trên blockchain chưa
- `verifiedAt`: Thời điểm verify

**Mũi tiếp theo:**
- `nextDoseDate`: Ngày dự kiến tiêm mũi tiếp theo
- `nextDoseNumber`: Mũi tiếp theo

## Services

### IdentityService
- `generateUserIdentityHash(User)`: Tạo identity hash cho user
- `generateFamilyMemberIdentityHash(FamilyMember, guardianWallet)`: Tạo hash cho trẻ em
- `generateDID(identityHash, type)`: Tạo DID
- `determineIdentityType(dateOfBirth)`: Xác định loại (ADULT/CHILD/NEWBORN)
- `linkBirthCertificate(member, certNumber)`: Liên kết giấy khai sinh sau
- `linkNationalID(member, idNumber)`: Liên kết CCCD khi đủ tuổi

### VaccineRecordService
- `createFromAppointment(...)`: Tạo vaccine record từ appointment
- `getUserVaccineHistory(userId)`: Lịch sử tiêm của user
- `getFamilyMemberVaccineHistory(memberId)`: Lịch sử của trẻ em
- `verifyOnBlockchain(recordId)`: Verify record trên blockchain
- `addAdverseReactions(recordId, reactions)`: Thêm phản ứng phụ
- `getRecordsNeedingFollowUp(centerId)`: Lấy records cần tái khám
- `getStatistics(userId, memberId)`: Thống kê tiêm chủng

## Database Migration

File: `V8__add_blockchain_identity_fields.sql`

**Updates:**
1. Add blockchain fields to `users` table
2. Add blockchain fields and birth certificate to `family_members` table
3. Create `vaccine_records` table with full schema
4. Add `vaccination_date` to `appointment` table
5. Add `days_for_next_dose` to `vaccine` table
6. Create indexes for performance
7. Create triggers for updated_at

## Automatic Vaccine Record Creation

Khi doctor complete appointment:
1. Appointment status → COMPLETED
2. Set `vaccinationDate` = today (if not set)
3. Auto create VaccineRecord với thông tin:
   - Patient info từ appointment.booking
   - Vaccine info từ booking.vaccine
   - Doctor, Center, Date từ appointment
   - Calculate nextDoseDate dựa trên vaccine schedule

## Identity Types

```java
enum IdentityType {
    ADULT,      // 18+ với đầy đủ giấy tờ
    CHILD,      // <18 tuổi, có thể chưa đủ giấy tờ
    NEWBORN     // <1 tuổi, chưa có giấy tờ
}
```

## Vaccination Sites

```java
enum VaccinationSite {
    LEFT_ARM("Cánh tay trái"),
    RIGHT_ARM("Cánh tay phải"),
    LEFT_THIGH("Đùi trái"),
    RIGHT_THIGH("Đùi phải"),
    ORAL("Uống"),
    NASAL("Xịt mũi")
}
```

## Workflow Example

### Trẻ em mới sinh:

1. **Đăng ký (Registration)**
   ```
   Parent creates FamilyMember
   → Generate blockchainIdentityHash = SHA256(parentWallet + name + DOB + timestamp)
   → Generate DID = "did:vax:vietnam:newborn:abc123..."
   → guardianWalletAddress = parent.walletAddress
   → birthCertificateNumber = NULL (có thể thêm sau)
   ```

2. **Đặt lịch tiêm (Booking)**
   ```
   Create Booking với familyMember
   → Cashier schedule appointment
   → Doctor performs vaccination
   ```

3. **Hoàn thành tiêm (Complete)**
   ```
   Doctor completes appointment
   → Auto create VaccineRecord:
      - patientIdentityHash = familyMember.blockchainIdentityHash
      - All vaccine details
      - Digital signature
   → Push to blockchain (TODO)
   → Store detailed data on IPFS (TODO)
   ```

4. **Sau này có giấy khai sinh**
   ```
   identityService.linkBirthCertificate(member, "123456789")
   → Update family_members.birth_certificate_number
   → Emit blockchain event (TODO)
   ```

5. **14 tuổi có CCCD**
   ```
   identityService.linkNationalID(member, "001234567890")
   → Update family_members.identity_number
   → Emit blockchain event (TODO)
   ```

## Ưu điểm

✅ **Định danh ngay lập tức**: Trẻ có identity hash ngay khi sinh  
✅ **Không phụ thuộc giấy tờ**: Dùng hash thay vì CCCD/Giấy khai sinh  
✅ **Bất biến**: Identity hash không đổi suốt đời  
✅ **Có thể verify**: Mọi người verify vaccine record trên blockchain  
✅ **Privacy**: Data chi tiết lưu IPFS, on-chain chỉ hash  
✅ **Quyền kiểm soát**: Cha/mẹ là guardian, quản lý identity cho con  
✅ **Tương thích tương lai**: Có thể link thêm documents sau  

## TODO - Blockchain Integration

### Smart Contract cần implement:

```solidity
contract SafeVaxIdentity {
    // Register identity
    function registerIdentity(bytes32 identityHash, address guardian) external;
    
    // Link documents
    function linkDocument(bytes32 identityHash, string documentType, string ipfsHash) external;
    
    // Record vaccination
    function recordVaccination(bytes32 identityHash, string ipfsHash) external returns (bytes32 txHash);
    
    // Verify record
    function verifyRecord(bytes32 txHash) external view returns (bool);
    
    // Get vaccine history
    function getVaccineHistory(bytes32 identityHash) external view returns (string[] memory);
}
```

### Backend Integration Points:

1. **UserService.register()**: Generate identity hash & DID
2. **FamilyMemberService.create()**: Generate identity hash & DID
3. **VaccineRecordService.createFromAppointment()**: Push to blockchain
4. **VaccineRecordService.verify()**: Verify on blockchain
5. **IdentityService.linkDocument()**: Emit blockchain event

## Testing

### Test Cases:

1. ✅ Create user → auto generate identity
2. ✅ Create family member → auto generate identity with guardian
3. ✅ Complete appointment → auto create vaccine record
4. ✅ Link birth certificate to existing identity
5. ✅ Get vaccine history for user/family member
6. ✅ Verify identity hash format
7. ✅ Verify DID format
8. ✅ Calculate next dose date

## API Endpoints (TODO)

```
GET  /api/identity/{identityHash}           - Get identity info
POST /api/identity/user                     - Create user identity
POST /api/identity/family-member            - Create child identity
POST /api/identity/link-document            - Link certificate/ID

GET  /api/vaccine-records/user/{userId}               - User history
GET  /api/vaccine-records/family-member/{memberId}    - Child history
GET  /api/vaccine-records/{id}/verify                 - Verify record
POST /api/vaccine-records/{id}/adverse-reactions      - Report reactions
GET  /api/vaccine-records/follow-up                   - Need follow-up
```

## Notes

- Hiện tại sử dụng SHA-256, trong production nên dùng Keccak256 (Web3j)
- IPFS integration chưa implement, đang return mock JSON
- Blockchain push/verify chưa implement, có comment TODO
- Cần thêm UI để nhập lotNumber, expiryDate, site khi complete appointment
- Cần implement digital signature cho doctor
