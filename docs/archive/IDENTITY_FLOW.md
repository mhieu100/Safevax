# Quy trình Định danh & Digital Medicine Card

## 1. Tổng quan
Hệ thống sử dụng **Digital Medicine Card** (Thẻ Y tế Số) được lưu trữ trên Blockchain để quản lý hồ sơ tiêm chủng. Mỗi người dùng sẽ có một định danh duy nhất (DID - Decentralized Identifier) gắn liền với thẻ này.

## 2. Thời điểm tạo Digital Medicine Card
Việc tạo Digital Medicine Card sẽ được thực hiện **ngay sau khi người dùng hoàn tất hồ sơ cá nhân (Complete Profile)**, bất kể họ đăng ký bằng Email/Password hay Google OAuth2.

Lý do:
- Cần thông tin chính xác (Ngày sinh, CCCD/CMND) để tạo mã băm định danh (Identity Hash) duy nhất.
- Tránh tạo rác trên blockchain cho các tài khoản ảo hoặc chưa xác thực.

## 3. Luồng xử lý cho Người dùng chính (User)

### A. Đăng ký & Login
1. **User**: Đăng ký qua Email/Pass hoặc Google.
2. **Backend**: Tạo User record (Status: `INACTIVE` hoặc `PROFILE_INCOMPLETE`).
3. **Frontend/Mobile**: Kiểm tra `user.patientProfile`. Nếu chưa có -> Chuyển hướng sang "Complete Profile".

### B. Hoàn tất hồ sơ (Complete Profile)
1. **User**: Nhập thông tin (Ngày sinh, Giới tính, CCCD/Mã định danh...).
2. **Backend (`AuthService.completeProfile`)**:
   - Cập nhật DB.
   - **Tạo Identity Hash**: Kết hợp `Email + Name + Birthday + IdentityNumber`.
   - **Blockchain Sync**: Tạo Identity trên Blockchain.
   - Trả về User đã Active.

## 4. Luồng xử lý cho Thành viên gia đình (Family Members)
Phụ huynh có thể quản lý hồ sơ tiêm chủng cho con cái hoặc người thân. Mỗi thành viên gia đình cũng sẽ có một **Digital Medicine Card** riêng biệt.

### A. Thêm thành viên (Add Family Member)
1. **User (Phụ huynh)**: Vào mục "Family Members" -> Chọn "Add Member".
2. **Nhập thông tin**:
   - Họ tên, Ngày sinh, Quan hệ (Con, Bố, Mẹ...).
   - **Quan trọng**: Số CCCD hoặc **Mã số định danh cá nhân** (đối với trẻ em).
3. **Backend (`FamilyMemberService.addFamilyMember`)**:
   - Validate thông tin (Mã định danh bắt buộc 9-12 số).
   - **Tạo Identity Hash**: Kết hợp `ParentID + Name + Birthday + IdentityNumber`.
   - **Phân loại Identity**:
     - Nếu tuổi < 18: `IdentityType.CHILD`
     - Nếu tuổi >= 18: `IdentityType.ADULT`
   - **Blockchain Sync**: Gọi Smart Contract tạo Identity mới (DID phụ thuộc vào Parent hoặc độc lập tùy thiết kế, hiện tại là độc lập nhưng được quản lý bởi Parent).
   - Lưu DB.

### B. Lưu ý về Trẻ em
- Trẻ em chưa có CCCD cứng phải sử dụng **Mã số định danh cá nhân** (được cấp trên Giấy khai sinh).
- Hệ thống Mobile/Web cần hiển thị hướng dẫn rõ ràng cho Phụ huynh nhập mã này.

## 5. Cấu trúc dữ liệu Blockchain (Tham khảo)
- **Identity Hash**: SHA-256(Unique Info)
- **DID**: `did:safevax:{IdentityHash}`
- **IPFS Data**: Chứa thông tin cơ bản (đã mã hóa hoặc public tùy policy) để hiển thị trên thẻ.
