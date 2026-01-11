# 🔗 Tích Hợp Blockchain & IPFS

Tài liệu này mô tả chi tiết kiến trúc và quy trình tích hợp công nghệ Blockchain (Ethereum/Polygon) và IPFS vào hệ thống SafeVax.

## 1. Kiến Trúc Tổng Quan

Hệ thống sử dụng mô hình **Hybrid Architecture** kết hợp giữa Database truyền thống và Blockchain:

*   **Off-chain (Database & IPFS):**
    *   **PostgreSQL:** Lưu trữ dữ liệu nghiệp vụ, tìm kiếm nhanh, quan hệ dữ liệu.
    *   **IPFS (InterPlanetary File System):** Lưu trữ nội dung chi tiết của hồ sơ tiêm chủng (JSON) để giảm chi phí lưu trữ trên Blockchain.
*   **On-chain (Smart Contracts):**
    *   Lưu trữ "Chân lý" (Source of Truth): Identity Hash, Record Hash, Chữ ký số.
    *   Đảm bảo tính toàn vẹn và không thể chối bỏ (Non-repudiation).

---

## 2. Các Smart Contracts

### 2.1. `SafeVaxIdentity.sol`
Quản lý định danh phi tập trung (DID) cho người dùng.

*   **Chức năng:** Mapping giữa `Email/Phone` (đã hash) và `IdentityHash` trên chuỗi.
*   **Dữ liệu:**
    *   `identityHash`: Định danh duy nhất.
    *   `owner`: Địa chỉ ví sở hữu.

### 2.2. `VaccineRecord.sol`
Lưu trữ bằng chứng tiêm chủng.

*   **Chức năng:** Lưu trữ tóm tắt (hash) của mỗi mũi tiêm.
*   **Dữ liệu:**
    *   `recordId`: ID duy nhất.
    *   `patientId`: Tham chiếu đến Identity của bệnh nhân.
    *   `ipfsHash`: Link đến file JSON chi tiết trên IPFS.
    *   `checksum`: Hash của dữ liệu để verify tính toàn vẹn.

---

## 3. Quy Trình Nghiệp Vụ Blockchain

### 3.1. Tạo Danh Tính (Create Identity)
Xảy ra khi User đăng ký tài khoản hoặc cập nhật Profile.

1.  **Frontend/API:** Gửi thông tin User.
2.  **Backend:**
    *   Lưu User vào DB.
    *   Gọi `BlockchainService` để tạo Identity.
3.  **Blockchain Service (Node.js):**
    *   Tương tác `SafeVaxIdentity` contract.
    *   Gửi Transaction để đăng ký Identity.
4.  **Kết quả:**
    *   Nhận về `transactionHash`.
    *   Cập nhật `blockchain_identity_hash` và `did` vào bảng `users`.

### 3.2. Ghi Nhận Tiêm Chủng (Record Vaccination)
Xảy ra khi Bác sĩ hoàn thành mũi tiêm (`COMPLETED`).

1.  **Doctor Action:** Xác nhận hoàn thành và điền chỉ số sinh tồn.
2.  **Backend Process:**
    *   **B1: Tạo JSON Metadata:** Gom toàn bộ thông tin (Bác sĩ, Vắc-xin, Lô, Ngày, Vitals...) thành 1 object JSON.
    *   **B2: Upload IPFS:** Upload JSON này lên IPFS -> Nhận về `ipfsHash` (CID).
    *   **B3: Write to Blockchain:** Gọi Smart Contract `VaccineRecord.createRecord(ipfsHash, ...)`.
    *   **B4: Save DB:** Lưu `vaccine_records` với `ipfsHash`, `transactionHash`, `blockchainRecordId`.

### 3.3. Xác Thực (Verification)
Bất kỳ bên thứ 3 nào cũng có thể xác thực hồ sơ:

1.  Lấy `ipfsHash` từ QR Code hoặc API.
2.  Tải nội dung từ IPFS.
3.  Query Smart Contract với `recordId` để lấy hash gốc.
4.  So sánh hash của file IPFS tải về với hash trên Blockchain.
    *   Khớp -> **Hợp lệ (Verified)**.
    *   Không khớp -> **Giả mạo (Tampered)**.

---

## 4. Cấu Trúc Dữ Liệu IPFS

Ví dụ một file JSON được lưu trên IPFS:

```json
{
  "recordId": "REC-123456",
  "patient": {
    "did": "did:safevax:...",
    "fullName": "Nguyen Van A"
  },
  "vaccine": {
    "name": "Pfizer-BioNTech",
    "batchNumber": "FG-4521",
    "doseNumber": 2
  },
  "medicalParams": {
    "weight": 70.5,
    "temperature": 36.5,
    "bloodPressure": "120/80"
  },
  "provider": {
    "doctorName": "Dr. Le Van B",
    "center": "VNVC Ha Noi"
  },
  "timestamp": "2024-05-20T10:00:00Z"
}
```

## 5. Cấu Hình & Môi Trường

*   **Blockchain Network:** Local Ganache (Dev) hoặc Polygon Amoy (Testnet).
*   **IPFS Node:** Infura IPFS hoặc Local Node.
*   **Biến môi trường:**
    *   `BLOCKCHAIN_RPC_URL`: Endpoint kết nối Blockchain.
    *   `WALLET_PRIVATE_KEY`: Key của ví System Admin để ký giao dịch (Gas payer).
    *   `CONTRACT_ADDRESS_IDENTITY`: Địa chỉ contract Identity.
    *   `CONTRACT_ADDRESS_RECORD`: Địa chỉ contract Record.
