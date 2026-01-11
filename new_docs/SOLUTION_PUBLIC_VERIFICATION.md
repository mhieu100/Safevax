# Giải Pháp Hệ Thống Xác Thực Tiêm Chủng Công Khai (Public Verification System)

## 1. Tổng Quan (Overview)
Hệ thống **Public Verification Portal** là một cấu phần quan trọng trong hệ sinh thái **SafeVax**, đóng vai trò là "Cổng giao tiếp tin cậy" (Trust Gateway) giữa dữ liệu y tế được bảo mật và nhu cầu xác minh công khai của xã hội.

Giải pháp này cho phép bất kỳ bên thứ ba nào (cơ quan hải quan, nhà tuyển dụng, ban tổ chức sự kiện...) xác thực tính chính xác, toàn vẹn và nguồn gốc của một hồ sơ tiêm chủng mà **không cần truy cập vào cơ sở dữ liệu nội bộ** của bệnh viện.

## 2. Kiến Trúc Hệ Thống (Architecture)

### Mô hình luồng dữ liệu:
```mermaid
graph LR
    A[Bác Sĩ/Bệnh Viện] -- Ký số & Lưu trữ --> B(Backend System)
    B -- Upload dữ liệu --> C[IPFS (Decentralized Storage)]
    B -- Ghi Hash & Chữ ký --> D[Blockchain Ledger]
    
    E[Người Dùng] -- Yêu cầu Verify (QR/Hash) --> F[Verification Portal (Frontend)]
    F -- API Public --> B
    B -- Verify Hash & Signature --> D
    F -- Hiển thị kết quả --> E
```

### Các thành phần chính:
1.  **Backend (Java Spring Boot):**
    *   Expose API công khai: `GET /api/public/verify-vaccine/{ipfsHash}`.
    *   Cơ chế Whitelist Security: Cho phép truy cập không cần Token cho endpoint này.
    *   Logic tự động: Tự động đánh dấu `isVerified=true` và ký số ngay khi hồ sơ được tạo từ cuộc hẹn.

2.  **Blockchain & IPFS:**
    *   **IPFS:** Lưu trữ nội dung chi tiết của hồ sơ tiêm chủng (JSON/FHIR) một cách phi tập trung, không thể sửa đổi nội dung mà không làm thay đổi Hash.
    *   **Smart Contract:** Lưu trữ mốc thời gian, người cấp (Doctor Address) và Hash của hồ sơ để đối chiếu tính toàn vẹn.

3.  **Frontend (Verification Portal - React/Vite):**
    *   Ứng dụng tách biệt hoàn toàn với hệ thống quản lý bệnh viện.
    *   Giao diện **Digital Health Passport** (Hộ chiếu sức khỏe số).
    *   Tối ưu hóa **100vh** mobile-first trải nghiệm người dùng.

## 3. Quy Trình Nghiệp Vụ (Business Workflow)

1.  **Khởi tạo (Creation):** 
    *   Bệnh nhân hoàn thành mũi tiêm.
    *   Bác sĩ xác nhận trên hệ thống.
    *   Hệ thống tự động tạo `VaccineRecord`, ký số bằng Private Key của bác sĩ, và upload dữ liệu lên IPFS.

2.  **Phân phối (Distribution):**
    *   Bệnh nhân nhận được một mã QR hoặc đường link chứa `IPFS Hash` (Ví dụ: `QmHash123...`).
    *   Link này có thể lưu trong Apple Wallet, Google Pay hoặc in ra giấy.

3.  **Xác thực (Verification):**
    *   Bên kiểm tra truy cập `safevax-verify.com` (Portal).
    *   Nhập mã Hash hoặc quét QR.
    *   Hệ thống hiển thị trạng thái "SECURE VERIFICATION" nếu dữ liệu khớp với Blockchain.

## 4. Giá Trị Cốt Lõi & Tính Năng Nổi Bật

### 🛡️ Single Source of Truth (Nguồn Chân Lý Duy Nhất)
Dữ liệu trên Blockchain là bất biến (Immutable). Không một ai, kể cả quản trị viên hệ thống, có thể âm thầm sửa đổi ngày tiêm hay loại vắc-xin của một bản ghi đã được xác thực (Verified) mà không làm thay đổi Hash và bị phát hiện.

### 🌍 Global Interoperability (Tương Thích Toàn Cầu)
Sử dụng chuẩn dữ liệu quốc tế và mạng lưới IPFS công cộng giúp việc xác thực có thể diễn ra ở bất kỳ quốc gia nào mà không cần kết nối VPN hay tích hợp API phức tạp giữa các nước.

### 🔒 Privacy Preserving (Bảo Vệ Riêng Tư)
Portal chỉ hiển thị các thông tin cần thiết để xác minh (Tên, Vắc-xin, Ngày tiêm, Trạng thái) dưới dạng "Read-Only". Người kiểm tra không có quyền ghi hay xem lịch sử bệnh án chi tiết khác của bệnh nhân.

## 5. Case Studies (Câu Chuyện Thực Tế)

### Case 1: "Hộ Chiếu Vắc-xin" Tại Sân Bay
*   **Vấn đề:** Hành khách cần chứng minh đã tiêm đủ liều để nhập cảnh. Giấy tờ giấy dễ rách, dễ làm giả.
*   **Giải pháp:** Hành khách đưa QR Code SafeVax. Hải quan quét trong 3 giây.
*   **Kết quả:** Thông quan nhanh chóng, loại bỏ hoàn toàn vé giả.

### Case 2: Tuyển Dụng & Môi Trường Làm Việc An Toàn
*   **Vấn đề:** Doanh nghiệp yêu cầu nhân viên mới phải có lịch sử tiêm chủng rõ ràng.
*   **Giải pháp:** Ứng viên gửi link hồ sơ SafeVax trong CV.
*   **Kết quả:** HR xác thực được ngay lập tức uy tín của ứng viên và đảm bảo an toàn cho môi trường làm việc chung.

### Case 3: Sự Kiện Đám Đông (Concert, Thể Thao)
*   **Vấn đề:** Kiểm soát hàng nghìn người ra vào trong thời gian ngắn.
*   **Giải pháp:** Cổng soát vé tích hợp máy quét mã SafeVax.
*   **Kết quả:** Tự động hóa quy trình soát vé kèm kiểm tra y tế, giảm ùn tắc.

## 6. Hướng Dẫn Kỹ Thuật (Technical Guide)

### Cài đặt & Chạy Portal
```bash
cd verification-portal
npm install
npm run dev
# Truy cập: http://localhost:5174
```

### API Endpoint
*   **Method:** `GET`
*   **URL:** `/api/public/verify-vaccine/{ipfsHash}`
*   **Response:**
    ```json
    {
      "statusCode": 200,
      "message": "CALL API SUCCESS",
      "data": {
        "verified": true,
        "patientName": "Nguyen Van A",
        "vaccineName": "Pfizer",
        "ipfsHash": "Qm...",
        "digitalSignature": "..."
      }
    }
    ```

---
*Tài liệu được soạn thảo bởi SafeVax Technical Team - 12/2025*
