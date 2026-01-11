# 🧪 FULL FLOW TEST - Hệ thống nhắc nhở tiêm chủng

## Test với Vaccine 2 mũi (ví dụ: Twinrix)

---

## 📋 Prerequisites

1. ✅ Backend đang chạy trên `http://localhost:8080`
2. ✅ Database đã có migration V100 và V101
3. ✅ Email config đã được set (Gmail App Password)
4. ✅ User có email hợp lệ trong database

---

## 🎯 Test Flow

### **PHASE 1: Appointment Reminder (Nhắc lịch hẹn Mũi 1)**

#### Step 1: Tạo appointment cho Mũi 1
```bash
POST http://localhost:8080/api/test/create-test-appointment?daysFromNow=1&userId=1
```

**Expected Response:**
```json
{
  "success": true,
  "appointmentId": 123,
  "appointmentDate": "2025-12-03",
  "patientName": "Văn Hiếu Nguyễn",
  "patientEmail": "hieunguyen201103@gmail.com",
  "vaccineName": "Twinrix",
  "remindersCreated": true,
  "reminderDates": ["2025-12-02", "2025-11-30", "2025-11-26"]
}
```

✅ **Kết quả**: 
- Appointment được tạo với status = SCHEDULED
- 3 reminders được tạo tự động (1, 3, 7 ngày trước)

---

#### Step 2: Gửi email nhắc nhở ngay (test)
```bash
POST http://localhost:8080/api/test/send-test-reminder
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Test reminders sent successfully. Check your email!"
}
```

✅ **Kiểm tra email**: 
📧 Subject: "Nhắc nhở: Lịch tiêm chủng của bạn"
- Hiển thị: Vaccine, ngày giờ, địa điểm, mũi số 1

---

#### Step 3: Xem reminders đã tạo
```bash
GET http://localhost:8080/api/reminders/my-reminders?userId=1
```

**Expected Response:**
```json
[
  {
    "id": 1,
    "reminderType": "APPOINTMENT_REMINDER",
    "scheduledDate": "2025-12-02",
    "status": "SENT",
    "channel": "EMAIL",
    "daysBefore": 1
  },
  {
    "id": 2,
    "reminderType": "APPOINTMENT_REMINDER",
    "scheduledDate": "2025-11-30",
    "status": "PENDING",
    "daysBefore": 3
  },
  {
    "id": 3,
    "reminderType": "APPOINTMENT_REMINDER",
    "scheduledDate": "2025-11-26",
    "status": "PENDING",
    "daysBefore": 7
  }
]
```

---

### **PHASE 2: Complete Dose 1 & Next Dose Reminder**

#### Step 4: Hoàn thành Mũi 1 (giả lập bác sĩ complete)
```bash
POST http://localhost:8080/api/test/complete-appointment/123
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Appointment completed successfully",
  "appointmentId": 123,
  "completedDate": "2025-12-02",
  "nextDoseReminderCreated": true
}
```

✅ **Kết quả**:
- Appointment status = COMPLETED
- vaccinationDate = hôm nay
- Next dose reminder được tạo tự động
- scheduledDate = hôm nay + vaccine.duration (ví dụ: 28 ngày)

---

#### Step 5: Kiểm tra next dose reminder
```bash
GET http://localhost:8080/api/reminders/my-reminders?userId=1
```

**Expected**: Thấy thêm reminder mới
```json
{
  "id": 4,
  "reminderType": "NEXT_DOSE_REMINDER",
  "scheduledDate": "2025-12-30",  // Ngày dự kiến mũi 2
  "status": "PENDING",
  "channel": "EMAIL",
  "nextDoseNumber": 2,
  "vaccineId": 1
}
```

---

#### Step 6: Gửi next dose reminder (test)
```bash
POST http://localhost:8080/api/reminders/send-pending
Authorization: Bearer YOUR_ADMIN_TOKEN
```

✅ **Kiểm tra email**:
📧 Subject: "Nhắc nhở: Đã đến lịch tiêm mũi tiếp theo - SafeVax"
- Hiển thị: Vaccine Twinrix, Mũi số 2
- CTA: "Đặt lịch ngay"

---

### **PHASE 3: Dose 2 Appointment (Lặp lại flow)**

#### Step 7: User đặt lịch Mũi 2
```bash
POST http://localhost:8080/api/test/create-test-appointment?daysFromNow=30&userId=1
```

**Lưu ý**: Appointment này có `doseNumber = 2`

---

#### Step 8: Gửi appointment reminders cho Mũi 2
```bash
POST http://localhost:8080/api/test/send-test-reminder
```

✅ **Kiểm tra email**: Nhận email nhắc lịch hẹn Mũi 2

---

#### Step 9: Complete Mũi 2
```bash
POST http://localhost:8080/api/test/complete-appointment/{appointmentId}
```

✅ **Kết quả**:
- Mũi 2 hoàn thành
- **KHÔNG** tạo next dose reminder (vì `dosesRequired = 2`, current = 2)

---

## 🎬 Quick Test Script

Chạy script tự động:
```bash
cd backend/test
chmod +x test-full-flow.sh
./test-full-flow.sh
```

Hoặc dùng REST Client trong VS Code:
```
Mở file: backend/test/full-flow-test.http
Click "Send Request" từng bước
```

---

## 📊 Verification Queries

### Check all reminders:
```sql
SELECT 
    vr.id,
    vr.reminder_type,
    vr.scheduled_date,
    vr.status,
    vr.channel,
    vr.days_before,
    vr.next_dose_number,
    a.dose_number as appointment_dose,
    a.status as appointment_status
FROM vaccination_reminders vr
LEFT JOIN appointments a ON vr.appointment_id = a.id
WHERE vr.user_id = 1
ORDER BY vr.created_at;
```

### Check notification logs:
```sql
SELECT 
    nl.id,
    nl.reminder_type,
    nl.channel,
    nl.status,
    nl.sent_at,
    nl.dose_number,
    nl.recipient
FROM notification_logs nl
WHERE nl.user_id = 1
ORDER BY nl.sent_at DESC;
```

### Check appointments:
```sql
SELECT 
    id,
    dose_number,
    status,
    appointment_date,
    vaccination_date,
    created_at
FROM appointments
WHERE user_id = 1
ORDER BY dose_number;
```

---

## ✅ Expected Results Summary

| Phase | Action | Email Subject | Reminder Type |
|-------|--------|---------------|---------------|
| 1 | Tạo appointment mũi 1 | "Nhắc nhở: Lịch tiêm chủng của bạn" | APPOINTMENT_REMINDER |
| 2 | Complete mũi 1 | "Nhắc nhở: Đã đến lịch tiêm mũi tiếp theo" | NEXT_DOSE_REMINDER |
| 3 | Tạo appointment mũi 2 | "Nhắc nhở: Lịch tiêm chủng của bạn" | APPOINTMENT_REMINDER |
| 4 | Complete mũi 2 | (No email - completed) | - |

**Total emails**: 3-4 emails cho full cycle 2 mũi

---

## 🐛 Troubleshooting

### Email không gửi?
- Check `spring.mail.password` có đúng không
- Check logs: `grep "Email" logs/spring.log`
- Verify Gmail App Password

### Reminder không tạo?
- Check appointment có booking không
- Check user có email không
- Check logs: `grep "Creating reminders" logs/spring.log`

### Next dose reminder không tạo?
- Check vaccine.dosesRequired và dosesRequired > currentDose
- Check vaccine.duration (số ngày giữa các mũi)
- Check logs: `grep "Next dose" logs/spring.log`

---

## 🎉 Test hoàn thành khi:

✅ Nhận đủ 3-4 emails theo đúng flow
✅ Database có đầy đủ reminders và logs
✅ Status của appointments chuyển đúng
✅ Next dose reminder được tạo sau khi complete mũi 1
✅ Không có next dose reminder sau khi complete mũi 2

**Happy testing!** 🚀
