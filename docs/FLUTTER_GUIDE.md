# Hướng dẫn Phát triển SafeVax Mobile App (Flutter)

## 1. Tổng quan
Ứng dụng Mobile giúp Bệnh nhân quản lý hồ sơ tiêm chủng và Digital Medicine Card.
Hệ thống sử dụng chung Backend với Web App, đảm bảo đồng bộ dữ liệu và quy trình định danh Blockchain.

## 2. Công nghệ & Thư viện
- **Core**: Flutter (Dart)
- **Networking**: `dio` (HTTP Client)
- **Auth**: `google_sign_in`, `flutter_secure_storage`
- **State**: `provider` hoặc `riverpod`
- **UI**: `qr_flutter` (Hiển thị mã QR định danh)

## 3. Quy trình Xác thực & Định danh (Quan trọng)

### A. Luồng Đăng nhập (Login Flow)
App hỗ trợ 2 cách đăng nhập, tất cả đều trả về JWT Token.

1. **Login thường (Email/Pass):**
   - API: `POST /auth/login/password`
   - Body: `{ "username": "...", "password": "..." }`

2. **Login Google (Mobile Native):**
   - Sử dụng lib `google_sign_in` lấy `idToken` từ Google.
   - API: `POST /auth/login/google-mobile`
   - Body: `{ "idToken": "eyJhbGciOi..." }`

### B. Luồng Kiểm tra & Hoàn thiện Hồ sơ (Profile Check Flow)
Sau khi Login thành công (có Token & User info), App cần điều hướng dựa trên trạng thái hồ sơ để đảm bảo User có **Digital Medicine Card**.

**Logic điều hướng:**
```dart
if (user.patientProfile == null || user.patientProfile.identityNumber == null) {
  // User chưa có hồ sơ y tế hoặc chưa có định danh Blockchain
  Navigator.pushReplacementNamed(context, '/complete-profile');
} else {
  // Hồ sơ đã đủ -> Vào trang chủ
  Navigator.pushReplacementNamed(context, '/home');
}
```

### C. Màn hình Hoàn thiện Hồ sơ (Complete Profile Screen)
Đây là bước bắt buộc để tạo **Digital Medicine Card** trên Blockchain.

1. **Thu thập thông tin:**
   - Ngày sinh (Bắt buộc để tạo Hash định danh).
   - Số CCCD/CMND (Bắt buộc).
   - Địa chỉ, Giới tính...

2. **Gọi API:**
   - API: `POST /auth/complete-profile`
   - Body:
     ```json
     {
       "patientProfile": {
         "birthday": "1990-01-01",
         "identityNumber": "001090000001",
         "address": "Hanoi",
         "gender": "MALE",
         ...
       }
     }
     ```

3. **Xử lý kết quả:**
   - **Thành công:** Backend đã tự động tạo Identity trên Blockchain. Chuyển User vào màn hình Home.
   - **Lỗi:** Hiển thị thông báo (ví dụ: Trùng số CCCD).

## 4. Các tính năng chính khác
1. **Xem Digital Medicine Card:**
   - Hiển thị QR Code từ `user.did` hoặc `user.blockchainIdentityHash`.
   - Hiển thị thông tin cá nhân từ `user.patientProfile`.



### D. Xử lý cho Đối tượng Trẻ em (< 18 tuổi)
Trẻ em chưa có CCCD cứng, nhưng hệ thống vẫn cần định danh duy nhất để tạo Digital Medicine Card.
Giải pháp: Sử dụng **Mã số định danh cá nhân** (12 số) trên Giấy khai sinh.

**Logic UI/UX cần implement:**
1.  **Lắng nghe thay đổi Ngày sinh:**
    -   Khi user chọn ngày sinh, tính toán tuổi ngay lập tức.
    -   `int age = DateTime.now().year - birthday.year;`

2.  **Thay đổi giao diện động:**
    -   **Nếu age >= 14:**
        -   Label: "Số CCCD / CMND"
        -   Hint: "Nhập số CCCD 12 số hoặc CMND 9 số"
    -   **Nếu age < 14:**
        -   Label: "Mã định danh cá nhân (Trên giấy khai sinh)"
        -   Hint: "Nhập mã số định danh 12 số của bé"
        -   **Hiển thị Alert/Note:** "Với trẻ em chưa có CCCD, vui lòng nhập Mã số định danh cá nhân được ghi trên Giấy khai sinh."

3.  **Validation:**
    -   Vẫn sử dụng Regex số (9-12 ký tự) như người lớn.
    -   Backend đã update message để chấp nhận cả "Personal ID code".
