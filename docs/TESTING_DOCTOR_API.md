# 🧪 DOCTOR SCHEDULE API - TESTING GUIDE

## 📋 Prerequisite

Sau khi run migration V4, database sẽ có:
- ✅ ~20 doctors đã migrate từ users table
- ✅ Lịch làm việc T2-T6 (8h-12h, 14h-17h), T7 (8h-12h)
- ✅ Slots đã được generate sẵn cho 60 ngày tiếp theo
- ✅ 2 doctors đang nghỉ phép (doctor_id = 2, 7)
- ✅ 3 doctors có lịch đặc biệt (doctor_id = 1, 5, 10)

---

## 🔐 Authentication

Tất cả API yêu cầu Bearer token (trừ khi có public access).

### Login để lấy token:

**Cashier Login:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "cashier.d@vax.com",
    "password": "123456"
  }'
```

**Doctor Login:**
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "doctor.a@vax.com",
    "password": "123456"
  }'
```

Lưu `accessToken` từ response để dùng cho các request sau.

---

## 🧪 TEST SCENARIOS

### 1️⃣ Get Available Doctors by Center

**Scenario:** CASHIER muốn xem danh sách bác sĩ đang làm việc tại center 1

```bash
curl -X GET "http://localhost:8080/api/v1/doctors/center/1/available" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response:**
```json
[
  {
    "doctorId": 1,
    "userId": 10,
    "doctorName": "Bác sĩ Nguyễn Văn A",
    "email": "doctor.a@vax.com",
    "avatar": "https_example.com/avatars/doc_a.png",
    "licenseNumber": "BYT-000010",
    "specialization": "Tiêm chủng người lớn",
    "consultationDuration": 30,
    "maxPatientsPerDay": 20,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "VNVC Hoàng Văn Thụ"
  },
  {
    "doctorId": 2,
    "userId": 11,
    "doctorName": "Bác sĩ Trần Văn B",
    ...
  }
]
```

**Verification:**
- ✅ Chỉ hiển thị doctors với `isAvailable = true`
- ✅ Chỉ doctors của center_id = 1
- ✅ Trả về đầy đủ thông tin: license, specialization, consultation_duration

---

### 2️⃣ Get Doctor Weekly Schedule Template

**Scenario:** Xem lịch làm việc template hàng tuần của bác sĩ

```bash
curl -X GET "http://localhost:8080/api/v1/doctors/1/schedules" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response:**
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
    "doctorId": 1,
    "dayOfWeek": 1,
    "dayName": "Monday",
    "startTime": "14:00",
    "endTime": "17:00",
    "isActive": true
  },
  {
    "scheduleId": 3,
    "dayOfWeek": 2,
    "dayName": "Tuesday",
    "startTime": "08:00",
    "endTime": "12:00",
    "isActive": true
  },
  ...
]
```

**Verification:**
- ✅ Hiển thị lịch T2-T6 (morning + afternoon)
- ✅ Hiển thị lịch T7 (morning only)
- ✅ Không có lịch CN (day_of_week = 0)

---

### 3️⃣ Get Available Slots by Doctor & Date

**Scenario:** CASHIER muốn xem slots trống của bác sĩ 1 vào ngày mai

```bash
# Get tomorrow's date
TOMORROW=$(date -d "+1 day" +%Y-%m-%d)

curl -X GET "http://localhost:8080/api/v1/doctors/1/slots/available?date=${TOMORROW}" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response:**
```json
[
  {
    "slotId": 123,
    "doctorId": 1,
    "doctorName": "Bác sĩ Nguyễn Văn A",
    "slotDate": "2025-11-18",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE",
    "appointmentId": null,
    "notes": null
  },
  {
    "slotId": 124,
    "slotDate": "2025-11-18",
    "startTime": "08:30",
    "endTime": "09:00",
    "status": "AVAILABLE",
    "appointmentId": null
  },
  ...
]
```

**Verification:**
- ✅ Chỉ hiển thị slots với `status = AVAILABLE`
- ✅ Mỗi slot kéo dài 30 phút (theo consultation_duration)
- ✅ Morning slots: 08:00-12:00 (8 slots)
- ✅ Afternoon slots: 14:00-17:00 (6 slots)
- ✅ Tổng: 14 slots/ngày

**Test Edge Cases:**

**Case 1: Doctor on Leave (doctor_id = 2)**
```bash
curl -X GET "http://localhost:8080/api/v1/doctors/2/slots/available?date=2025-11-20" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```
Expected: `[]` (empty array vì đang nghỉ phép)

**Case 2: Doctor with Special Schedule (doctor_id = 1, 7 days from now)**
```bash
SPECIAL_DATE=$(date -d "+7 days" +%Y-%m-%d)
curl -X GET "http://localhost:8080/api/v1/doctors/1/slots/available?date=${SPECIAL_DATE}" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```
Expected: Chỉ có slots từ 10:00-14:00 (thay vì 08:00-12:00, 14:00-17:00)

---

### 4️⃣ Get Available Slots by Center & Date

**Scenario:** Xem TẤT CẢ slots trống của tất cả bác sĩ trong center 1

```bash
TOMORROW=$(date -d "+1 day" +%Y-%m-%d)

curl -X GET "http://localhost:8080/api/v1/doctors/center/1/slots/available?date=${TOMORROW}" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response:**
```json
[
  {
    "slotId": 123,
    "doctorId": 1,
    "doctorName": "Bác sĩ Nguyễn Văn A",
    "slotDate": "2025-11-18",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE"
  },
  {
    "slotId": 200,
    "doctorId": 2,
    "doctorName": "Bác sĩ Trần Văn B",
    "slotDate": "2025-11-18",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE"
  },
  ...
]
```

**Verification:**
- ✅ Slots của nhiều doctors (sorted by doctor_id)
- ✅ Chỉ center_id = 1
- ✅ Tổng slots = (số doctors * 14 slots/ngày)

**Use Case:** CASHIER muốn tìm slot sớm nhất có sẵn trong center, không quan tâm bác sĩ nào.

---

### 5️⃣ Get Doctor Slots in Date Range (Calendar View)

**Scenario:** Bác sĩ muốn xem lịch của mình trong 1 tuần

```bash
START_DATE=$(date +%Y-%m-%d)
END_DATE=$(date -d "+7 days" +%Y-%m-%d)

curl -X GET "http://localhost:8080/api/v1/doctors/1/slots?startDate=${START_DATE}&endDate=${END_DATE}" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Expected Response:**
```json
[
  {
    "slotId": 123,
    "doctorId": 1,
    "doctorName": "Bác sĩ Nguyễn Văn A",
    "slotDate": "2025-11-17",
    "startTime": "08:00",
    "endTime": "08:30",
    "status": "AVAILABLE",
    "appointmentId": null
  },
  {
    "slotId": 124,
    "slotDate": "2025-11-17",
    "startTime": "08:30",
    "endTime": "09:00",
    "status": "BOOKED",
    "appointmentId": 101
  },
  ...
]
```

**Verification:**
- ✅ Bao gồm CẢ 3 status: AVAILABLE, BOOKED, BLOCKED
- ✅ Sorted by date, then by time
- ✅ Hiển thị `appointmentId` nếu slot đã booked

**Use Case:** 
- Doctor Dashboard - xem lịch tuần
- Calendar View - hiển thị slots trống vs đã đặt

---

### 6️⃣ Generate Slots for Doctor

**Scenario:** Admin muốn generate slots cho bác sĩ mới hoặc regenerate cho tháng mới

```bash
curl -X POST "http://localhost:8080/api/v1/doctors/1/slots/generate" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "startDate": "2025-12-01",
    "endDate": "2025-12-31"
  }'
```

**Expected Response:**
```json
{
  "message": "Slots generated successfully",
  "doctorId": 1,
  "slotsGenerated": 308,
  "startDate": "2025-12-01",
  "endDate": "2025-12-31"
}
```

**Calculation:**
- Tháng 12/2025: 31 ngày
- Weekdays (T2-T6): ~22 ngày × 14 slots = 308 slots
- Saturday (T7): ~4 ngày × 8 slots = 32 slots
- Sunday (CN): 0 slots (no schedule)
- **Total: ~340 slots**

**Verification:**
```bash
# Query DB to verify
SELECT 
    COUNT(*) as total_slots,
    COUNT(CASE WHEN status = 'AVAILABLE' THEN 1 END) as available_slots
FROM doctor_available_slots
WHERE doctor_id = 1
  AND slot_date BETWEEN '2025-12-01' AND '2025-12-31';
```

**Edge Cases:**

**Case 1: Generate with overlapping leave**
```bash
# First, create leave for doctor 1 in December
INSERT INTO doctor_leave (doctor_id, start_date, end_date, reason, leave_type, status)
VALUES (1, '2025-12-10', '2025-12-15', 'Nghỉ phép', 'VACATION', 'APPROVED');

# Then generate slots
curl -X POST "http://localhost:8080/api/v1/doctors/1/slots/generate" ...
```
Expected: Slots từ 10-15/12 sẽ bị skip (không generate)

**Case 2: Generate with special schedule**
```bash
# First, create special schedule
INSERT INTO doctor_special_schedules (doctor_id, work_date, start_time, end_time, reason)
VALUES (1, '2025-12-25', '10:00', '14:00', 'Giáng sinh - làm ngắn');

# Then generate slots
curl -X POST "http://localhost:8080/api/v1/doctors/1/slots/generate" ...
```
Expected: Ngày 25/12 chỉ có slots từ 10:00-14:00

---

## 🎯 INTEGRATION TEST WORKFLOW

### Complete Flow: Assign Appointment to Slot

**Step 1: Bệnh nhân đăng ký lịch hẹn (PENDING_SCHEDULE)**
```bash
curl -X POST "http://localhost:8080/api/v1/appointments" \
  -H "Authorization: Bearer PATIENT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "vaccineId": 1,
    "centerId": 1,
    "desiredDate": "2025-11-20",
    "notes": "Tiền sử dị ứng thuốc"
  }'
```

Response: `{ "appointmentId": 101, "status": "PENDING_SCHEDULE" }`

**Step 2: CASHIER xem slots trống**
```bash
curl -X GET "http://localhost:8080/api/v1/doctors/1/slots/available?date=2025-11-20" \
  -H "Authorization: Bearer CASHIER_TOKEN"
```

Response: List of available slots (chọn slot_id = 500)

**Step 3: CASHIER phân công lịch hẹn vào slot**
```bash
curl -X PUT "http://localhost:8080/api/v1/appointments/101/assign" \
  -H "Authorization: Bearer CASHIER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "slotId": 500
  }'
```

Expected:
1. ✅ Appointment: `status = SCHEDULED`, `slot_id = 500`, `scheduled_date = 2025-11-20`, `scheduled_time = 08:00`
2. ✅ Slot 500: `status = BOOKED`, `appointment_id = 101`

**Step 4: Verify slot is now booked**
```bash
curl -X GET "http://localhost:8080/api/v1/doctors/1/slots/available?date=2025-11-20" \
  -H "Authorization: Bearer CASHIER_TOKEN"
```

Expected: Slot 500 không còn trong list (vì status = BOOKED)

**Step 5: Doctor xem lịch của mình**
```bash
curl -X GET "http://localhost:8080/api/v1/doctors/1/slots?startDate=2025-11-20&endDate=2025-11-20" \
  -H "Authorization: Bearer DOCTOR_TOKEN"
```

Expected: Thấy slot 500 với `status = BOOKED`, `appointmentId = 101`

---

## 🔍 DATABASE VERIFICATION QUERIES

### Check doctor migration
```sql
SELECT 
    d.doctor_id,
    u.full_name,
    d.license_number,
    d.specialization,
    d.consultation_duration,
    c.name as center_name,
    d.is_available
FROM doctors d
JOIN users u ON d.user_id = u.id
JOIN centers c ON d.center_id = c.center_id
ORDER BY d.doctor_id;
```

### Check schedules created
```sql
SELECT 
    d.doctor_id,
    u.full_name,
    COUNT(ds.schedule_id) as schedule_count
FROM doctors d
JOIN users u ON d.user_id = u.id
LEFT JOIN doctor_schedules ds ON d.doctor_id = ds.doctor_id
GROUP BY d.doctor_id, u.full_name
ORDER BY d.doctor_id;
```

### Check slots generated
```sql
SELECT 
    d.doctor_id,
    u.full_name,
    COUNT(das.slot_id) as total_slots,
    COUNT(CASE WHEN das.status = 'AVAILABLE' THEN 1 END) as available_slots,
    COUNT(CASE WHEN das.status = 'BOOKED' THEN 1 END) as booked_slots,
    MIN(das.slot_date) as first_slot_date,
    MAX(das.slot_date) as last_slot_date
FROM doctors d
JOIN users u ON d.user_id = u.id
LEFT JOIN doctor_available_slots das ON d.doctor_id = das.doctor_id
GROUP BY d.doctor_id, u.full_name
ORDER BY d.doctor_id;
```

### Check doctors on leave
```sql
SELECT 
    d.doctor_id,
    u.full_name,
    dl.start_date,
    dl.end_date,
    dl.reason,
    dl.leave_type,
    dl.status
FROM doctor_leave dl
JOIN doctors d ON dl.doctor_id = d.doctor_id
JOIN users u ON d.user_id = u.id
WHERE dl.status = 'APPROVED'
  AND dl.end_date >= CURRENT_DATE
ORDER BY dl.start_date;
```

### Check available slots for tomorrow
```sql
SELECT 
    das.slot_id,
    d.doctor_id,
    u.full_name as doctor_name,
    das.slot_date,
    das.start_time,
    das.end_time,
    das.status
FROM doctor_available_slots das
JOIN doctors d ON das.doctor_id = d.doctor_id
JOIN users u ON d.user_id = u.id
WHERE das.slot_date = CURRENT_DATE + INTERVAL '1 day'
  AND das.status = 'AVAILABLE'
ORDER BY d.doctor_id, das.start_time;
```

---

## 📊 EXPECTED METRICS

After V4 migration:

| Metric | Expected Value |
|--------|---------------|
| Total Doctors | ~20 |
| Doctors per Center | 3-5 |
| Schedules per Doctor | 11 (Mon-Fri: 2 shifts × 5 days + Sat: 1 shift) |
| Slots per Day per Doctor | 14 (morning: 8 slots, afternoon: 6 slots) |
| Total Slots (60 days) | ~16,800 (20 doctors × 14 slots × 60 days × 0.7 weekdays ratio) |
| Doctors on Leave | 2 |
| Doctors with Special Schedule | 3 |

---

## 🐛 TROUBLESHOOTING

### Issue 1: No slots returned
**Check:**
```sql
SELECT COUNT(*) FROM doctor_available_slots WHERE doctor_id = 1;
```
If 0 → Run generate slots API

### Issue 2: All slots empty for a date
**Check if doctor on leave:**
```sql
SELECT * FROM doctor_leave 
WHERE doctor_id = 1 
  AND '2025-11-20' BETWEEN start_date AND end_date 
  AND status = 'APPROVED';
```

### Issue 3: Unexpected slot times
**Check schedule:**
```sql
SELECT * FROM doctor_schedules WHERE doctor_id = 1;
```

**Check special schedule:**
```sql
SELECT * FROM doctor_special_schedules 
WHERE doctor_id = 1 
  AND work_date = '2025-11-20';
```

---

## ✅ SUCCESS CRITERIA

- [x] Can list all doctors by center
- [x] Can view doctor weekly schedule template
- [x] Can get available slots for specific date
- [x] Can get available slots across center
- [x] Can generate slots for date range
- [x] Slots respect leave periods (no slots during leave)
- [x] Slots respect special schedules (override normal schedule)
- [x] Slots have correct duration (30 minutes)
- [x] Slots can be booked (status changes to BOOKED)
- [x] Trigger auto-updates slot status when appointment assigned

---

## 🚀 NEXT STEPS

1. **Frontend Integration:**
   - Update `pending-appointment.jsx` to use new APIs
   - Create doctor schedule UI
   - Calendar view with slot visualization

2. **Admin Panel:**
   - CRUD doctor schedules
   - Approve doctor leave
   - Bulk generate slots

3. **Automation:**
   - Cron job: Auto-generate slots monthly
   - Notification: Email doctors when slots generated
   - Reminder: SMS patients 1 day before appointment

Happy Testing! 🎉
