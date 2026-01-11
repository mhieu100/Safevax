# 🏥 DOCTOR SCHEDULE MANAGEMENT SYSTEM - API DOCUMENTATION

## 📋 Overview

Hệ thống quản lý lịch làm việc bác sĩ đã được refactor để scale tốt hơn với:
- ✅ Bảng `doctors` riêng biệt với thông tin chuyên môn
- ✅ Lịch làm việc template theo tuần (`doctor_schedules`)
- ✅ Lịch làm việc đặc biệt override (`doctor_special_schedules`)
- ✅ Quản lý nghỉ phép (`doctor_leave`)
- ✅ Time slots tự động sinh (`doctor_available_slots`)

---

## 🗂️ Database Schema

### 1. `doctors` - Thông tin bác sĩ
```sql
- doctor_id (PK)
- user_id (FK → users) UNIQUE
- center_id (FK → centers)
- license_number (Số chứng chỉ hành nghề)
- specialization (Chuyên khoa)
- consultation_duration (Thời gian 1 slot: 15/30/45/60 phút)
- max_patients_per_day (Giới hạn bệnh nhân/ngày)
- is_available (Có nhận lịch không)
```

### 2. `doctor_schedules` - Lịch làm việc hàng tuần (Template)
```sql
- schedule_id (PK)
- doctor_id (FK → doctors)
- day_of_week (0=CN, 1=T2, ..., 6=T7)
- start_time, end_time
- is_active
```

**Ví dụ**: BS Nguyễn Văn A làm T2-T6: 8h-12h và 14h-17h

### 3. `doctor_special_schedules` - Lịch đặc biệt (Override cho ngày cụ thể)
```sql
- special_schedule_id (PK)
- doctor_id (FK → doctors)
- work_date (Ngày cụ thể)
- start_time, end_time
- reason
```

**Ví dụ**: Ngày 20/11/2025 BS chỉ làm 10h-14h vì họp buổi sáng

### 4. `doctor_leave` - Nghỉ phép
```sql
- leave_id (PK)
- doctor_id (FK → doctors)
- start_date, end_date
- reason, leave_type (personal/sick/vacation/conference)
- status (pending/approved/rejected)
```

### 5. `doctor_available_slots` ⭐ (Core Scheduling Table)
```sql
- slot_id (PK)
- doctor_id (FK → doctors)
- slot_date, start_time, end_time
- status: 'available'/'booked'/'blocked'
- appointment_id (NULL nếu trống)
```

**Đây là bảng TẤT CẢ slots của bác sĩ được sinh tự động**

### 6. `appointments` - Cập nhật
```sql
+ slot_id (FK → doctor_available_slots) -- NEW
```

---

## 🔄 Workflow Mới

### 1️⃣ Setup: Admin tạo lịch làm việc cho bác sĩ

**Bước 1: Insert doctor record**
```sql
-- Tự động migrate từ users với role=DOCTOR
-- Hoặc admin tạo mới trong giao diện
```

**Bước 2: Tạo lịch làm việc template**
```sql
INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time)
VALUES 
(1, 1, '08:00', '12:00'), -- T2 sáng
(1, 1, '14:00', '17:00'), -- T2 chiều
(1, 2, '08:00', '12:00'), -- T3 sáng
...;
```

**Bước 3: Generate slots cho tháng**
```bash
# Call API hoặc run stored procedure
POST /api/v1/doctors/1/slots/generate
{
  "startDate": "2025-11-01",
  "endDate": "2025-11-30"
}
```

### 2️⃣ Bệnh nhân đăng ký lịch hẹn (PENDING_SCHEDULE)

```javascript
// Frontend: Bệnh nhân submit form
POST /api/v1/appointments
{
  "patientId": 100,
  "centerId": 1,
  "vaccineId": 5,
  "desiredDate": "2025-11-20",
  "notes": "Tiền sử dị ứng thuốc"
}

// Backend tạo appointment với:
status = 'PENDING_SCHEDULE'
doctorId = NULL
slotId = NULL
```

### 3️⃣ CASHIER xem và phân công lịch

**API 1: Lấy danh sách bác sĩ có sẵn**
```javascript
GET /api/v1/doctors/center/1/available

Response:
[
  {
    "doctorId": 1,
    "userId": 10,
    "doctorName": "BS. Nguyễn Văn Minh",
    "specialization": "Tiêm chủng",
    "consultationDuration": 30,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "TT Tiêm Chủng Quận 1"
  },
  ...
]
```

**API 2: Xem slots trống của bác sĩ trong ngày**
```javascript
GET /api/v1/doctors/1/slots/available?date=2025-11-20

Response:
[
  {
    "slotId": 123,
    "doctorId": 1,
    "doctorName": "BS. Nguyễn Văn Minh",
    "slotDate": "2025-11-20",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE"
  },
  {
    "slotId": 124,
    "slotDate": "2025-11-20",
    "startTime": "08:30",
    "endTime": "09:00",
    "status": "AVAILABLE"
  },
  ...
]
```

**API 3: Phân công lịch hẹn (Gắn appointment vào slot)**
```javascript
PUT /api/v1/appointments/101/assign
{
  "doctorId": 1,
  "slotId": 123
}

// Backend:
1. Update appointment:
   - doctorId = 1
   - slotId = 123  
   - scheduledDate = '2025-11-20'
   - scheduledTime = '08:00'
   - status = 'SCHEDULED'

2. Trigger tự động update slot:
   - UPDATE doctor_available_slots
     SET status = 'BOOKED', appointment_id = 101
     WHERE slot_id = 123
```

### 4️⃣ Bác sĩ xem lịch được phân công

```javascript
GET /api/v1/doctors/1/slots?startDate=2025-11-20&endDate=2025-11-20

Response:
[
  {
    "slotId": 123,
    "slotDate": "2025-11-20",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "BOOKED",
    "appointmentId": 101
  },
  {
    "slotId": 124,
    "startTime": "08:30",
    "endTime": "09:00",
    "status": "AVAILABLE",
    "appointmentId": null
  },
  ...
]
```

---

## 🎯 API Endpoints

### 📍 Doctor Management

#### 1. Get Available Doctors by Center
```http
GET /api/v1/doctors/center/{centerId}/available
```

**Response:**
```json
[
  {
    "doctorId": 1,
    "userId": 10,
    "doctorName": "BS. Nguyễn Văn Minh",
    "email": "nvminh@hospital.vn",
    "licenseNumber": "BYT-12345",
    "specialization": "Tiêm chủng",
    "consultationDuration": 30,
    "maxPatientsPerDay": 20,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "TT Tiêm Chủng Quận 1"
  }
]
```

#### 2. Get Doctor Weekly Schedule Template
```http
GET /api/v1/doctors/{doctorId}/schedules
```

**Response:**
```json
[
  {
    "scheduleId": 1,
    "doctorId": 1,
    "dayOfWeek": 1,
    "dayName": "Monday",
    "startTime": "08:00",
    "endTime": "12:00",
    "isActive": true
  },
  {
    "scheduleId": 2,
    "dayOfWeek": 1,
    "dayName": "Monday",
    "startTime": "14:00",
    "endTime": "17:00",
    "isActive": true
  }
]
```

---

### 📍 Slot Management

#### 3. Get Available Slots by Doctor & Date
```http
GET /api/v1/doctors/{doctorId}/slots/available?date=2025-11-20
```

**Query Params:**
- `date` (required): Format `YYYY-MM-DD`

**Response:**
```json
[
  {
    "slotId": 123,
    "doctorId": 1,
    "doctorName": "BS. Nguyễn Văn Minh",
    "slotDate": "2025-11-20",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE",
    "appointmentId": null,
    "notes": null
  }
]
```

#### 4. Get Available Slots by Center & Date
```http
GET /api/v1/doctors/center/{centerId}/slots/available?date=2025-11-20
```

**Use case**: Hiển thị TẤT CẢ slots trống của tất cả bác sĩ trong 1 center

#### 5. Get Doctor Slots in Date Range
```http
GET /api/v1/doctors/{doctorId}/slots?startDate=2025-11-01&endDate=2025-11-30
```

**Use case**: Calendar view của bác sĩ (xem lịch 1 tháng)

#### 6. Generate Slots for Doctor
```http
POST /api/v1/doctors/{doctorId}/slots/generate
Content-Type: application/json

{
  "startDate": "2025-12-01",
  "endDate": "2025-12-31"
}
```

**Response:**
```json
{
  "message": "Slots generated successfully",
  "doctorId": 1,
  "slotsGenerated": 320,
  "startDate": "2025-12-01",
  "endDate": "2025-12-31"
}
```

**Logic:**
- Duyệt từng ngày từ `startDate` → `endDate`
- Kiểm tra doctor có nghỉ phép không
- Ưu tiên special schedule, không có thì dùng weekly schedule
- Chia thành slots theo `consultation_duration`
- Insert vào `doctor_available_slots`

---

## 🔧 Migration Steps

### Step 1: Run Migration V3
```bash
# Migration sẽ tự động:
# 1. Create 5 tables mới
# 2. Add slot_id vào appointments
# 3. Update status check constraint (allow PENDING_APPROVAL)
# 4. Create triggers
# 5. Create stored procedure generate_doctor_slots
# 6. Migrate existing doctors từ users table
```

### Step 2: Setup Doctor Schedules (Manual hoặc UI)
```sql
-- Example: Setup lịch cho BS id=1
INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time)
VALUES 
(1, 1, '08:00', '12:00'), -- Monday morning
(1, 1, '14:00', '17:00'), -- Monday afternoon
(1, 2, '08:00', '12:00'), -- Tuesday morning
(1, 2, '14:00', '17:00'),
(1, 3, '08:00', '12:00'),
(1, 3, '14:00', '17:00'),
(1, 4, '08:00', '12:00'),
(1, 4, '14:00', '17:00'),
(1, 5, '08:00', '12:00'),
(1, 5, '14:00', '17:00');
```

### Step 3: Generate Initial Slots
```bash
# Option 1: Via API
curl -X POST http://localhost:8080/api/v1/doctors/1/slots/generate \
  -H "Content-Type: application/json" \
  -d '{"startDate":"2025-11-01","endDate":"2025-12-31"}'

# Option 2: Via SQL (if using stored procedure)
SELECT * FROM generate_doctor_slots(1, '2025-11-01', '2025-12-31');
```

### Step 4: Setup Cron Job (Auto-generate monthly)
```bash
# Add to crontab để tự động generate slots đầu mỗi tháng
# Run at 00:00 on day 1 of every month
0 0 1 * * curl -X POST http://localhost:8080/api/v1/doctors/1/slots/generate -H "Content-Type: application/json" -d "{\"startDate\":\"$(date +\%Y-\%m-01)\",\"endDate\":\"$(date -d "$(date +\%Y-\%m-01) +1 month -1 day" +\%Y-\%m-\%d)\"}"
```

---

## 🎨 Frontend Integration

### 1. Pending Appointment Page - Get Available Slots

```javascript
// src/pages/staff/pending-appointment.jsx

const loadAvailableSlots = async (doctorId, date) => {
  try {
    const response = await axios.get(
      `/api/v1/doctors/${doctorId}/slots/available`,
      { params: { date: dayjs(date).format('YYYY-MM-DD') } }
    );
    
    setAvailableSlots(response.data);
  } catch (error) {
    message.error('Không thể tải slots trống');
  }
};

// When cashier assigns appointment
const handleAssignAppointment = async (appointmentId, slotId) => {
  try {
    await axios.put(`/api/v1/appointments/${appointmentId}/assign`, {
      slotId
    });
    
    message.success('Phân công lịch hẹn thành công!');
    refreshAppointments();
  } catch (error) {
    message.error('Phân công thất bại');
  }
};
```

### 2. Doctor Schedule Page - View Doctor Slots

```javascript
// src/pages/staff/doctor-schedule.jsx

const loadDoctorSchedule = async (doctorId, startDate, endDate) => {
  try {
    const response = await axios.get(`/api/v1/doctors/${doctorId}/slots`, {
      params: {
        startDate: dayjs(startDate).format('YYYY-MM-DD'),
        endDate: dayjs(endDate).format('YYYY-MM-DD')
      }
    });
    
    // Group by date for calendar view
    const slotsByDate = response.data.reduce((acc, slot) => {
      const date = slot.slotDate;
      if (!acc[date]) acc[date] = [];
      acc[date].push(slot);
      return acc;
    }, {});
    
    setDoctorSlots(slotsByDate);
  } catch (error) {
    message.error('Không thể tải lịch bác sĩ');
  }
};
```

---

## ✅ Ưu Điểm Của Hệ Thống Mới

### 1. **Scalability**
- ✅ Tách riêng doctor profile ra khỏi users
- ✅ Dễ thêm thông tin chuyên môn (chứng chỉ, chuyên khoa)
- ✅ Hỗ trợ nhiều center (1 doctor có thể làm nhiều nơi)

### 2. **Flexibility**
- ✅ Lịch template hàng tuần
- ✅ Override cho ngày đặc biệt
- ✅ Quản lý nghỉ phép
- ✅ Điều chỉnh thời gian khám/slot (15/30/45/60 phút)

### 3. **Performance**
- ✅ Slots pre-generated → query nhanh
- ✅ Index đầy đủ (doctor_id, slot_date, status)
- ✅ Unique constraint tránh double booking

### 4. **Maintainability**
- ✅ Trigger tự động sync slot status
- ✅ Stored procedure generate slots
- ✅ Clear separation of concerns

---

## 🚀 Next Steps

1. **Frontend:**
   - [ ] Update pending-appointment.jsx để dùng API mới
   - [ ] Thêm doctor-schedule.jsx với calendar view
   - [ ] UI quản lý lịch làm việc (CRUD schedules)

2. **Backend:**
   - [ ] API CRUD doctor schedules
   - [ ] API CRUD doctor leave
   - [ ] API statistics (doctor performance)

3. **Admin Panel:**
   - [ ] Trang quản lý bác sĩ
   - [ ] Setup lịch làm việc template
   - [ ] Duyệt nghỉ phép

4. **Automation:**
   - [ ] Cron job auto-generate slots
   - [ ] Email notification cho bác sĩ khi có lịch mới
   - [ ] Reminder cho bệnh nhân trước 1 ngày

---

## 📞 Support

Nếu có vấn đề, check:
1. Migration V3 đã chạy thành công chưa
2. Doctor schedules đã được setup chưa
3. Slots đã được generate chưa (call API generate)
4. Trigger có hoạt động không (check slot status sync)

🎉 Happy Coding!
