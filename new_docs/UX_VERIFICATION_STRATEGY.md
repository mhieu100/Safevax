# UX/DX Strategy: Tối Ưu Hóa Trải Nghiệm Xác Thực Vaccine

Tài liệu này đề xuất các chiến lược phát triển (Development Strategy) nhằm tối ưu hóa sự thuận tiện cho người dùng cuối (User) và người kiểm tra (Verifier) trong hệ sinh thái SafeVax.

## 1. Smart Verify URL (Mô hình QR Code thông minh)

Thay vì chỉ mã hóa chuỗi Hash thô hoặc JSON vào QR Code, hệ thống sẽ sử dụng một URL định danh duy nhất.

*   **Format:** `https://safevax.system/verify?id={IPFS_HASH}`
*   **Lợi ích:**
    *   **Universal Scan:** Tương thích với mọi trình quét QR (Zalo, Camera iPhone, Google Lens). Không yêu cầu cài đặt App chuyên dụng.
    *   **Auto-Trigger:** Tự động điều hướng đến trang `VerifyResultPage` để kích hoạt quy trình kiểm tra Blockchain ngay lập tức.
    *   **Dynamic Routing:** Có thể chuyển hướng linh hoạt (ví dụ: nếu trang web bảo trì, có thể redirect sang trang dự phòng mà không cần in lại QR).

## 2. Tích hợp Ví Điện Tử (Wallet Integration) - "Ăn tiền"

Hỗ trợ người dùng lưu trữ chứng nhận tiêm chủng ngay bên cạnh thẻ tín dụng và vé máy bay.

### Chiến lược triển khai:
*   **Apple Wallet (.pkpass):**
    *   Tạo Pass Certificate từ Apple Developer Account.
    *   Hiển thị thông tin chính: Tên vaccine, Mũi số, Tên người dùng.
    *   Mã QR trên thẻ Wallet chính là **Smart Verify URL**.
*   **Google Wallet:**
    *   Sử dụng Google Wallet API để tạo "Covid Card" object.
    *   Cho phép lưu nhanh thông qua nút "Add to Google Wallet" trên website.

## 3. Phân tầng hiển thị (Layered Verified View)

Để tối ưu tốc độ và bảo mật quyền riêng tư khi quét mã nơi công cộng.

### Tầng 1: Public Verification (Hiển thị ngay lập tức)
*   **Dữ liệu:**
    *   Trạng thái: ✅ **VERIFIED VALID** (To, Rõ, Màu Xanh).
    *   Tên người: `Nguyen Van A`
    *   Loại Vaccine: `Pfizer-BioNTech`
    *   Thời gian tiêm: `14/12/2025`
*   **Nguồn:** Query trực tiếp từ Smart Contract (nhẹ, nhanh).

### Tầng 2: Medical Detail (Yêu cầu thao tác)
*   **Action:** Người kiểm tra phải bấm nút "Xem chi tiết y tế".
*   **Dữ liệu:** Số lô, Bác sĩ thực hiện, Địa điểm tiêm, Tiền sử dị ứng.
*   **Nguồn:** Fetch từ IPFS (nặng hơn).

## 4. Offline Proof (Dự phòng mất mạng)

Giải pháp cho các khu vực vùng sâu vùng xa hoặc khi hệ thống Blockchain bị gián đoạn.

*   **PDF có chữ ký số (Digitally Signed PDF):**
    *   Hệ thống cho phép tải về bản PDF "Hộ chiếu Vaccine".
    *   File PDF này được ký bằng Private Key của Server (Bên cạnh việc hash lên Blockchain).
    *   **Cơ chế:** Các trình đọc PDF chuẩn (Adobe Acrobat) sẽ hiển thị dòng "Signed by SafeVax Authority" -> Chứng minh văn bản chưa bị chỉnh sửa photoshop.

## 5. User Journey lý tưởng

1.  **Tiêm chủng:** Hoàn tất mũi tiêm tại trung tâm.
2.  **Thông báo:** Nhận email/SMS chứa link xem chứng nhận.
3.  **Lưu trữ:** Người dùng bấm "Add to Apple Wallet" để lưu vào điện thoại.
4.  **Sử dụng:**
    *   Đi qua sân bay -> Bấm nút nguồn 2 lần -> Giơ thẻ Vaccine.
    *   Nhân viên an ninh quét -> Thấy màn hình Xanh ✅ -> Cho qua.
