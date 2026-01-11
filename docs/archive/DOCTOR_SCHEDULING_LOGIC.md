# Doctor Scheduling Logic

## Overview
Hệ thống đặt lịch hẹn với bác sĩ được thiết kế để đơn giản và linh hoạt, hỗ trợ cả chế độ tự động và tùy chỉnh.

## Default Working Hours (Mặc định)
Nếu không có lịch làm việc tùy chỉnh trong bảng `doctor_schedules`:
- **Thời gian làm việc**: 7:00 - 17:00 (7 AM - 5 PM)
- **Làm việc**: Tất cả các ngày trong tuần (Monday - Sunday)
- **Slot duration**: 30 phút/slot
- **Số slot mỗi ngày**: 20 slots (từ 7:00-17:00)

## Time Slots (Khung giờ cho bệnh nhân)
Bệnh nhân chọn khung giờ 2 tiếng:
- **SLOT_07_00**: 7:00 - 9:00 AM
- **SLOT_09_00**: 9:00 - 11:00 AM
- **SLOT_11_00**: 11:00 AM - 1:00 PM
- **SLOT_13_00**: 1:00 - 3:00 PM
- **SLOT_15_00**: 3:00 - 5:00 PM

## Doctor Consultation Slots (Slot khám của bác sĩ)
Trong mỗi khung giờ 2 tiếng, có 4 slots khám 30 phút:
- Ví dụ với SLOT_11_00 (11:00 - 13:00):
  - 11:00 - 11:30
  - 11:30 - 12:00
  - 12:00 - 12:30
  - 12:30 - 13:00

## Workflow

### 1. Patient Booking
```
Patient chọn:
1. Vaccine cần tiêm
2. Ngày mong muốn
3. Khung giờ (TimeSlotEnum: SLOT_11_00)
→ Tạo Appointment với status PENDING_SCHEDULE
```

### 2. Cashier Assignment
```
Cashier:
1. Xem danh sách appointments chưa phân công
2. Chọn bác sĩ
3. Hệ thống filter slots của bác sĩ trong khung giờ đã đăng ký
   (Ví dụ: nếu chọn SLOT_11_00 → chỉ hiện slots 11:00-13:00)
4. Chọn một slot cụ thể (ví dụ: 11:30-12:00)
5. Xác nhận → Appointment được phân công
```

### 3. Slot Generation
```java
DoctorScheduleService.generateDoctorSlots(doctorId, startDate, endDate)
```

**Logic:**
1. Kiểm tra bảng `doctor_schedules` cho ngày trong tuần
2. Nếu **KHÔNG có** custom schedule:
   - Tự động tạo slots từ 7:00 - 17:00
   - Mỗi slot 30 phút
3. Nếu **CÓ** custom schedule:
   - Sử dụng giờ làm việc đã định nghĩa
   - Tạo slots theo consultation_duration

## Database Tables

### 1. `doctors`
```sql
- doctor_id
- user_id
- center_id
- consultation_duration (default: 30 phút)
- max_patients_per_day (default: 20)
- is_available (default: true)
```

### 2. `doctor_schedules` (OPTIONAL)
```sql
- schedule_id
- doctor_id
- day_of_week (0=Sunday, 1=Monday, ..., 6=Saturday)
- start_time
- end_time
- is_active
```
**Note**: Bảng này có thể để trống. Nếu trống, hệ thống dùng default 7:00-17:00.

### 3. `doctor_available_slots`
```sql
- slot_id
- doctor_id
- slot_date
- start_time (HH:mm:ss)
- end_time (HH:mm:ss)
- status (AVAILABLE/BOOKED)
- appointment_id (nếu đã đặt)
```

### 4. `appointments`
```sql
- id
- booking_id
- doctor_id
- slot_id
- scheduled_date
- scheduled_time_slot (enum: SLOT_07_00, SLOT_09_00, ...)
- actual_scheduled_time (HH:mm:ss - giờ chính thức từ slot)
- status
```

## API Endpoints

### Generate Slots
```
POST /api/v1/doctors/{doctorId}/generate-slots
Params: startDate, endDate
```
Tạo tất cả slots cho bác sĩ trong khoảng thời gian.

### Get Available Slots
```
GET /api/v1/doctors/{doctorId}/slots/available?date=2025-12-01
```
Lấy tất cả slots AVAILABLE của bác sĩ trong ngày.

### Get Doctors with Schedule
```
GET /api/v1/doctors/my-center/with-schedule?date=2025-12-01
```
Lấy danh sách bác sĩ trong center với thống kê slots.

## Frontend Flow

### Cashier - Assign Appointment Modal
1. Load appointment info (patient, vaccine, desired date, time slot)
2. Chọn bác sĩ → Load doctors list
3. Fetch slots của bác sĩ đó → **Filter theo time slot**
4. Hiển thị chỉ các slots trong khung giờ
5. Chọn slot → Lưu với `actual_scheduled_time = slot.startTime`

## Benefits của Design này

### ✅ Đơn giản
- Không cần setup phức tạp
- Mặc định tất cả bác sĩ đều làm full-time 7-17h
- Không cần quản lý DoctorSchedule nếu không cần

### ✅ Linh hoạt
- Có thể thêm custom schedule sau nếu cần
- Mỗi bác sĩ có thể có giờ làm khác nhau
- Có thể thay đổi consultation_duration

### ✅ Scalable
- Tự động generate slots cho nhiều ngày
- Dễ mở rộng thêm rules (ngày nghỉ, holidays, etc.)

## Example

### Scenario: Patient đặt lịch tiêm vaccine
```
1. Patient: Chọn vaccine Pfizer, ngày 2025-12-10, khung 11:00-13:00
   → Tạo Appointment (status: PENDING_SCHEDULE)
   
2. Cashier: Mở modal phân công
   - Chọn Dr. Nguyễn Văn A
   - Hệ thống fetch slots của Dr. A ngày 10/12
   - Filter chỉ slots từ 11:00-13:00:
     ✓ 11:00-11:30 (AVAILABLE)
     ✓ 11:30-12:00 (AVAILABLE)
     ✗ 12:00-12:30 (BOOKED)
     ✓ 12:30-13:00 (AVAILABLE)
   - Chọn slot 11:30-12:00
   - Confirm
   
3. System: Update appointment
   - doctor_id = Dr. A
   - slot_id = <slot 11:30-12:00>
   - actual_scheduled_time = "11:30:00"
   - status = SCHEDULED
   
4. Doctor: Xem lịch làm việc
   - 11:30-12:00: Patient X - Vaccine Pfizer
```

## Migration Notes

Nếu đang có data cũ với logic khác:
1. Backup database
2. Chạy migration để set consultation_duration = 30 cho tất cả doctors
3. Xóa các slots cũ nếu có (hoặc giữ lại)
4. Re-generate slots cho future dates
5. Test với một vài appointments
