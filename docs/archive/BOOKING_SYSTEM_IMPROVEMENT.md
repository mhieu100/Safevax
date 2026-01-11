# Tài liệu Cải tiến Hệ thống Đặt lịch

## 1. Tổng quan
Tài liệu này phác thảo các cải tiến đã thực hiện đối với hệ thống đặt lịch SafeVax nhằm giải quyết các vấn đề nghiêm trọng liên quan đến việc đặt lịch quá tải (overbooking), các khung giờ tĩnh, và quy trình phân công bác sĩ.

## 2. Vấn đề (Problem Statement)
*   **Nguy cơ Overbooking:** Hệ thống trước đây không kiểm tra sức chứa của trung tâm hoặc các cuộc hẹn hiện có trước khi xác nhận đặt lịch mới, dẫn đến khả năng overbooking.
*   **Khung giờ Tĩnh:** Frontend hiển thị danh sách khung giờ cố định bất kể tình trạng sẵn sàng thực tế.
*   **Bác sĩ chưa được phân công:** Các đặt lịch trực tuyến được tạo mà không có bác sĩ được chỉ định, gây nhầm lẫn trong quá trình check-in.

## 3. Kiến trúc Giải pháp

### 3.1. Backend: Quản lý Sức chứa & Xác thực
*   **Endpoint API Mới:** `GET /api/bookings/availability`
    *   **Mục đích:** Trả về tình trạng sẵn sàng theo thời gian thực cho một trung tâm và ngày cụ thể.
    *   **Logic:** Tính toán `Khả dụng = Sức chứa - Đã đặt` cho mỗi khung giờ.
*   **Logic Xác thực:**
    *   Cập nhật `BookingService.createBooking` để kiểm tra nghiêm ngặt tình trạng sẵn sàng của slot trước khi lưu.
    *   Ném ra ngoại lệ nếu slot đã chọn đã đầy.
*   **Tối ưu hóa Cơ sở dữ liệu:**
    *   Thêm truy vấn `countAppointmentsBySlot` vào `AppointmentRepository` để đếm hiệu quả.

### 3.2. Frontend: Giao diện Người dùng Động
*   **Hiển thị Slot Động:**
    *   Component `AppointmentSection` hiện tải dữ liệu sẵn sàng khi người dùng chọn Trung tâm và Ngày.
    *   Các khung giờ được hiển thị với trạng thái thực (ví dụ: "Còn 48 chỗ" hoặc "Đã đầy").
*   **Trải nghiệm Người dùng:**
    *   Các slot đã đầy bị vô hiệu hóa để ngăn chặn việc chọn.
    *   Trạng thái đang tải cung cấp phản hồi trực quan trong quá trình kiểm tra.
    *   Đã xóa khung giờ không hợp lệ 17:00-19:00 để khớp với giờ làm việc.

### 3.3. Vận hành: Quy trình Phân công Bác sĩ
*   **Quy trình:**
    1.  **Đặt lịch:** Khách hàng đặt lịch trực tuyến (Trạng thái: `SCHEDULED`, Bác sĩ: `NULL`).
    2.  **Check-in:** Khách hàng đến trung tâm.
    3.  **Phân công:** Thu ngân sử dụng **Dashboard Nhân viên** để xem cuộc hẹn.
    4.  **Xử lý:** Thu ngân chọn một bác sĩ có sẵn thông qua `ProcessUrgentAppointmentModal`.
    5.  **Xác nhận:** Hệ thống cập nhật cuộc hẹn với Bác sĩ và Slot đã được chỉ định.

## 4. Chi tiết Triển khai Kỹ thuật

### 4.1. Cấu trúc Dữ liệu
**Time Slots (TimeSlotEnum):**
*   `SLOT_07_00` (07:00 - 09:00)
*   `SLOT_09_00` (09:00 - 11:00)
*   `SLOT_11_00` (11:00 - 13:00)
*   `SLOT_13_00` (13:00 - 15:00)
*   `SLOT_15_00` (15:00 - 17:00)

**DTOs:**
*   `SlotAvailabilityDto`: Chứa `timeSlot`, `capacity`, `booked`, `available`, `status`.
*   `CenterAvailabilityResponse`: Wrapper cho danh sách các slot.

### 4.2. Các Thay đổi Mã chính
*   **Backend:**
    *   `AppointmentRepository.java`: Đã thêm `countAppointmentsBySlot`.
    *   `BookingService.java`: Đã thêm `checkAvailability` và logic xác thực.
    *   `AppointmentService.java`: Cập nhật `updateScheduledAppointment` để xử lý việc gán slot chính xác.
*   **Frontend:**
    *   `booking.service.js`: Đã thêm gọi API `checkAvailability`.
    *   `AppointmentSection.jsx`: Tích hợp hiển thị và lấy dữ liệu slot động.

## 5. Hướng dẫn Sử dụng (Dành cho Nhân viên)

### Cách Phân công Bác sĩ cho Đặt lịch Trực tuyến
1.  Đăng nhập vào **Dashboard Nhân viên** (vai trò Cashier).
2.  Tìm cuộc hẹn trong **"Danh Sách Cần Xử Lý"** (Urgent List) hoặc tìm kiếm bệnh nhân.
3.  Nhấn **"Xử Lý Ngay"** (Process Now).
4.  Trong modal bật lên:
    *   Chọn **Bác sĩ** từ danh sách thả xuống.
    *   Chọn **Khung giờ** (hệ thống sẽ hiển thị các slot có sẵn cho bác sĩ đó).
5.  Nhấn **"Phân công bác sĩ"** (Assign Doctor) để xác nhận.
