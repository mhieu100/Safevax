# 📊 CẤU TRÚC CƠ SỞ DỮ LIỆU (DATABASE SCHEMA)

Tài liệu này mô tả thiết kế Database hiện tại của hệ thống SafeVax, cập nhật theo các tính năng mới nhất: Blockchain, Dynamic Scheduling, và Vitals Tracking.

## 1. Tổng Quan
Hệ thống sử dụng **PostgreSQL** (hoặc MySQL) với kiến trúc **Layered Codebase**. Các Entity chính được thiết kế để hỗ trợ cả nghiệp vụ truyền thống và tích hợp Blockchain/IPFS.

---

## 2. Chi Tiết Các Bảng (Entities)

### 2.1. Quản lý Người Dùng (Users & Identity)

#### Bảng `users`
Lưu trữ thông tin định danh tập trung và phi tập trung.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | Primary Key. |
| `email` | String | Email đăng nhập (Unique). |
| `password` | String | BCrypt Hash. |
| `phone` | String | Số điện thoại. |
| `full_name` | String | Họ tên đầy đủ. |
| `birthday` | Date | Ngày sinh. |
| `gender` | Enum | MALE, FEMALE, OTHER. |
| `role_id` | FK | Tham chiếu đến bảng `roles`. |
| `blockchain_identity_hash`| String | **[Blockchain]** Hash định danh trên Smart Contract. |
| `did` | String | **[Blockchain]** Decentralized Identifier (W3C standard). |
| `ipfs_data_hash` | String | **[IPFS]** Hash CID của file JSON hồ sơ cá nhân trên IPFS. |
| `is_active` | Boolean | Trạng thái kích hoạt. |

#### Bảng `family_members`
Quản lý hồ sơ người thân (Con cái, cha mẹ...) dưới một tài khoản chính.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `user_id` | FK | Người giám hộ (User chính). |
| `full_name` | String | Tên người thân. |
| `relationship` | Enum | CHILD, PARENT, SPOUSE, OTHER. |
| `blockchain_identity_hash`| String | **[Blockchain]** Hash định danh riêng cho người thân. |

---

### 2.2. Quản lý Lịch Làm Việc & Bác Sĩ

#### Bảng `doctors`
Thông tin chuyên môn của bác sĩ. Liên kết 1-1 với `users`.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `doctor_id` | Long (PK) | |
| `user_id` | FK (Unique)| Tham chiếu đến `users`. |
| `center_id` | FK | Trung tâm tiêm chủng làm việc. |
| `license_number` | String | Số chứng chỉ hành nghề. |
| `is_available` | Boolean | Trạng thái sẵn sàng nhận lịch. |
| `consultation_duration`| Int | Thời gian khám trung bình (phút). |

#### Bảng `doctor_available_slots`
Các slot thời gian cụ thể mà bác sĩ có thể nhận hẹn.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `slot_id` | Long (PK) | |
| `doctor_id` | FK | |
| `slot_date` | Date | Ngày làm việc. |
| `start_time` | Time | Giờ bắt đầu. |
| `end_time` | Time | Giờ kết thúc. |
| `status` | Enum | AVAILABLE, BOOKED, BLOCKED. |

---

### 2.3. Quy Trình Tiêm Chủng (Core Business)

#### Bảng `vaccines`
Danh mục vắc-xin.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `name` | String | Tên vắc-xin (VD: Pfizer, Moderna). |
| `code` | String | Mã nhận diện. |
| `total_doses` | Int | Tổng số mũi theo phác đồ chuẩn. |
| `days_between_doses` | Int | Khoảng cách tối thiểu giữa các mũi. |

#### Bảng `bookings`
Đơn hàng/Yêu cầu đặt lịch của khách hàng.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `user_id` | FK | Người đặt. |
| `patient_id` / `family_member_id` | FK | Người được tiêm. |
| `vaccine_id` | FK | Loại vắc-xin chọn. |
| `total_amount` | Decimal | Tổng tiền. |
| `payment_status` | Enum | PENDING, PAID, FAILED. |

#### Bảng `appointments`
Lịch hẹn cụ thể được sinh ra từ Booking (Logic Dynamic Dose: Thường chỉ tạo 1 Appointment cho mũi tiếp theo).

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `booking_id` | FK | |
| `doctor_slot_id` | FK | Slot thời gian đã chọn. |
| `status` | Enum | PENDING, CONFIRMED, COMPLETED, CANCELLED. |
| `dose_number` | Int | Mũi thứ mấy (1, 2, 3...). |
| `check_in_time` | Timestamp| Thời điểm check-in tại quầy. |

---

### 2.4. Lưu Trữ Y Tế & Blockchain (Health Records)

#### Bảng `vaccine_records`
Lưu trữ kết quả tiêm chủng, chỉ số sinh tồn và metadata blockchain.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `appointment_id` | FK | Liên kết với lịch hẹn đã hoàn thành. |
| `vaccination_date` | Date | Ngày tiêm thực tế. |
| **Vitals (Mới)** | | **Chỉ số sinh tồn tại thời điểm tiêm** |
| `height` | Page | Chiều cao (cm). |
| `weight` | Double | Cân nặng (kg). |
| `temperature` | Double | Nhiệt độ cơ thể (°C). |
| `pulse` | Int | Nhịp tim (bpm). |
| **Reactions** | | **Theo dõi phản ứng** |
| `adverse_reactions` | Text | Ghi chú phản ứng sau tiêm. |
| `notes` | Text | Ghi chú của bác sĩ. |
| **Blockchain** | | **Xác thực dữ liệu** |
| `blockchain_record_id` | String | ID record trên Smart Contract. |
| `transaction_hash` | String | Hash giao dịch xác nhận trên chuỗi. |
| `ipfs_hash` | String | Hash CID file JSON chi tiết trên IPFS. |
| `is_verified` | Boolean | Đã xác thực trên Blockchain chưa? |

#### Bảng `vaccination_courses` (Mới)
Gom nhóm các mũi tiêm của một loại vắc-xin thành một lộ trình thống nhất cho bệnh nhân.

| Trường | Kiểu dữ liệu | Mô tả |
| :--- | :--- | :--- |
| `id` | Long (PK) | |
| `patient_id` / `family_member_id` | FK | Người bệnh. |
| `vaccine_id` | FK | Loại vắc-xin. |
| `current_dose_index` | Int | Mũi tiêm gần nhất đã hoàn thành. |
| `status` | Enum | IN_PROGRESS, COMPLETED. |
| `start_date` | Date | Ngày bắt đầu mũi 1. |

---

## 3. Các Thay Đổi Quan Trọng So Với Phiên Bản Cũ

1.  **Removed `Observation` Table**: Module Observation cũ đã bị xóa. Các chỉ số sinh tồn (`weight`, `height`...) nay được lưu trực tiếp vào bảng `vaccine_records` để gắn liền với bối cảnh tiêm chủng.
2.  **Added `VaccinationCourse`**: Để phục vụ tính năng "Dynamic Dose Scheduling" và hiển thị lộ trình tiêm chủng (Timeline) trên Frontend.
3.  **Blockchain Fields**: Các bảng `users`, `vaccine_records` đều có thêm các trường lưu hash và ID tham chiếu sang Blockchain/IPFS.
