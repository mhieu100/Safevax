# 📅 Hệ Thống Đặt Lịch & Quản Lý Tiêm Chủng

Tài liệu này mô tả logic nghiệp vụ cốt lõi về quản lý lịch làm việc của bác sĩ và quy trình đặt lịch tiêm chủng (Booking) mới áp dụng "Dynamic Dose Scheduling".

## 1. Quản Lý Lịch Bác Sĩ (Doctor Availability)

### 1.1. Các Loại Lịch
Hệ thống hỗ trợ 3 lớp quản lý thời gian của bác sĩ:

1.  **Lịch Cố Định (Template Schedule):**
    *   Cấu hình theo thứ trong tuần (T2 - T6, T7, CN).
    *   Áp dụng lặp lại hàng tuần.
2.  **Lịch Đặc Biệt (Special Schedule):**
    *   Override lịch cố định vào một ngày cụ thể (VD: Làm bù, Tăng ca).
3.  **Lịch Nghỉ (Leave/Off):**
    *   Ngày nghỉ phép, block toàn bộ các slot trong khoảng thời gian này.

### 1.2. Time Slots (Khe Thời Gian)
*   **Generate:** Hệ thống tự động sinh ra các `DoctorAvailableSlot` dựa trên cấu hình lịch.
*   **Duration:** Mỗi slot mặc định 30 phút (hoặc theo cấu hình bác sĩ).
*   **Status:**
    *   `AVAILABLE`: Trống.
    *   `BOOKED`: Đã có khách đặt.
    *   `BLOCKED`: Bác sĩ bận/nghỉ.

---

## 2. Dynamic Dose Scheduling (Đặt Lịch Động)

Thay vì tạo sẵn hàng loạt Appointment cho cả phác đồ (Ví dụ: Mũi 1, Mũi 2, Mũi 3 ngay từ đầu), hệ thống chuyển sang mô hình **"Single Dose Booking"**.

### 2.1. Logic "Max Dose + 1"
Khi người dùng đặt lịch vắc-xin X:

1.  Hệ thống tìm trong `VaccineRecord`: Mũi tiêm *cao nhất* đã hoàn thành của loại vắc-xin này là bao nhiêu? (Gọi là `maxDose`).
2.  Mũi tiếp theo cần đặt = `maxDose + 1`.
    *   *Nếu chưa tiêm mũi nào -> Mũi 1.*
    *   *Nếu đã tiêm mũi 1 -> Mũi 2.*

### 2.2. Lợi Ích
*   **Tránh Lịch Ảo:** Không tạo ra các lịch hẹn tương lai xa vời (vài tháng sau) mà khả năng cao sẽ bị hủy hoặc đổi.
*   **Linh Hoạt:** Người dùng có thể tiêm Mũi 1 ở Center A, Mũi 2 ở Center B mà không bị ràng buộc bởi booking cũ.
*   **Tối Ưu Database:** Giảm lượng bản ghi Appointment dư thừa.

---

## 3. Vaccination Course (Lộ Trình Tiêm Chủng)

Để quản lý tiến độ tổng thể khi áp dụng Dynamic Scheduling, hệ thống sử dụng Entity `VaccinationCourse`.

*   **Chức năng:** Gom nhóm các mũi tiêm rời rạc thành một "khóa học" (Course).
*   **Trạng thái:**
    *   `NOT_STARTED`: Chưa tiêm mũi nào.
    *   `IN_PROGRESS`: Đang trong lộ trình (VD: Đã tiêm 1/3 mũi).
    *   `COMPLETED`: Đã hoàn thành phác đồ.

### Flow Cập Nhật:
1.  Người dùng đặt Mũi 1 -> Tạo `VaccinationCourse` (Status: IN_PROGRESS).
2.  Hoàn thành Mũi 1 -> Update `VaccinationCourse` (Current Dose: 1).
3.  Người dùng đặt Mũi 2 -> Hệ thống check `VaccinationCourse` để biết cần tiêm Mũi 2.
4.  Hoàn thành Mũi cuối -> Update `VaccinationCourse` (Status: COMPLETED).
