# Hệ thống nhắc lịch thông minh (Smart Reminder System) - HOÀN CHỈNH

## ✅ Tổng quan

Hệ thống nhắc nhở thông minh với **2 loại reminder**:

### 1. **Appointment Reminder** (Nhắc lịch hẹn đã book)
- **Áp dụng**: Mũi 1 hoặc bất kỳ mũi nào đã đặt lịch
- **Cơ chế**: Dựa trên ngày/giờ user đã book
- **Mục đích**: Nhắc user đến đúng giờ hẹn
- **Thời điểm gửi**: Trước lịch hẹn 1, 3, 7 ngày (configurable)

### 2. **Next Dose Reminder** (Nhắc mũi tiếp theo)
- **Áp dụng**: Mũi 2, 3, Booster
- **Cơ chế**: Dựa trên phác đồ vaccine (Vaccine Protocol)
- **Mục đích**: Nhắc user vào đặt lịch mũi tiếp theo
- **Trigger**: Tự động sau khi hoàn thành appointment (status = COMPLETED)
- **Tính toán**: Ngày mũi tiếp theo = Ngày hoàn thành + `vaccine.duration` (days)

---

## 📊 Database Schema

### **Bảng `vaccination_reminders`** (Đã cập nhật)
```sql
- reminder_type: APPOINTMENT_REMINDER | NEXT_DOSE_REMINDER
- appointment_id: Nullable (null nếu là NEXT_DOSE_REMINDER)
- vaccine_id: ID vaccine cho mũi tiếp theo
- next_dose_number: Số mũi tiếp theo (2, 3, 4...)
```

### **Bảng `user_notification_settings`** (Mới)
```sql
- email_enabled: Cho phép nhận email
- sms_enabled: Cho phép nhận SMS (future)
- zalo_enabled: Cho phép nhận Zalo (future)
- preferred_channel: EMAIL | SMS | ZALO
- appointment_reminder_enabled: Bật/tắt nhắc lịch hẹn
- next_dose_reminder_enabled: Bật/tắt nhắc mũi tiếp theo
```

### **Bảng `notification_logs`** (Mới)
```sql
- Ghi log tất cả notifications đã gửi
- Tránh spam và gửi trùng lặp
- Track status: SENT | FAILED
```

---

## 🔧 Triển khai kỹ thuật

### **1. Services mới**

#### `NotificationLogService`
- Kiểm tra user preferences
- Kiểm tra đã gửi gần đây (prevent spam)
- Ghi log success/failure

#### `NextDoseReminderService`
- Tạo reminder khi appointment COMPLETED
- Tính toán ngày mũi tiếp theo từ `vaccine.duration`
- Gửi email nhắc nhở với template riêng

### **2. Scheduler**

```java
@Scheduled(cron = "0 0 8 * * ?") // 8:00 AM daily
public void sendDailyReminders() {
    reminderService.sendPendingReminders(); // Appointment reminders
}

@Scheduled(cron = "0 0 8 * * ?") // 8:00 AM daily  
public void sendNextDoseReminders() {
    nextDoseReminderService.sendNextDoseReminders(); // Next dose reminders
}

@Scheduled(cron = "0 0 */2 * * ?") // Every 2 hours
public void retryFailedReminders() {
    reminderService.retryFailedReminders(); // Retry failures
}
```

### **3. Workflow**

#### **Appointment Reminder Flow:**
```
User đặt lịch 
    ↓
AppointmentService.createAppointment()
    ↓
VaccinationReminderService.createRemindersForAppointment()
    ↓
Tạo reminders cho -1, -3, -7 days
    ↓
Scheduler gửi vào 8:00 AM khi scheduled_date = TODAY
```

#### **Next Dose Reminder Flow:**
```
Doctor hoàn thành appointment
    ↓
AppointmentService.complete() → status = COMPLETED
    ↓
NextDoseReminderService.createNextDoseReminder()
    ↓
Kiểm tra vaccine.dosesRequired (còn mũi nào không?)
    ↓
Tính toán: nextDoseDate = completedDate + vaccine.duration
    ↓
Tạo NEXT_DOSE_REMINDER với scheduled_date = nextDoseDate
    ↓
Scheduler gửi khi đến nextDoseDate
```

---

## 📧 Email Templates

### **1. `vaccination-reminder.html`**
- Nhắc lịch hẹn đã book
- Hiển thị: Ngày giờ, vaccine, trung tâm

### **2. `next-dose-reminder.html`** (Mới)
- Nhắc mũi tiếp theo
- Hiển thị: Vaccine, mũi số mấy
- CTA: "Đặt lịch ngay"

---

## 🔌 API Endpoints

### **Notification Settings**
```
GET /api/notification-settings
PUT /api/notification-settings
```

### **Test Endpoints**
```
POST /api/test/create-test-appointment?daysFromNow=3&userId=1
POST /api/test/send-test-reminder
```

---

## ⚙️ Configuration

```properties
# application.properties
reminder.days.before=1,3,7
reminder.cron=0 0 8 * * ?

spring.mail.host=smtp.gmail.com
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
```

---

## 📝 Migration Script

**File:** `V101__add_next_dose_reminder_and_notification_settings.sql`

Chạy migration này để:
- Thêm `reminder_type`, `vaccine_id`, `next_dose_number` vào `vaccination_reminders`
- Tạo bảng `user_notification_settings`
- Tạo bảng `notification_logs`

---

## 🧪 Testing

### **Test Appointment Reminder:**
```bash
# 1. Tạo appointment 3 ngày sau
POST /api/test/create-test-appointment?daysFromNow=3&userId=1

# 2. Gửi reminders ngay
POST /api/test/send-test-reminder
```

### **Test Next Dose Reminder:**
```bash
# 1. Complete một appointment (giả sử ID = 123)
PUT /appointments/123/complete

# 2. Kiểm tra reminder được tạo
SELECT * FROM vaccination_reminders 
WHERE reminder_type = 'NEXT_DOSE_REMINDER' 
AND user_id = 1;

# 3. Đợi scheduler hoặc trigger manually
POST /api/reminders/send-pending
```

---

## 🚀 Features đã implement

✅ **Appointment Reminder** (Nhắc lịch hẹn)
✅ **Next Dose Reminder** (Nhắc mũi tiếp theo theo phác đồ)
✅ **User Notification Settings** (Bật/tắt từng loại)
✅ **Notification Logs** (Tránh spam và duplicate)
✅ **Email Templates** (2 loại riêng biệt)
✅ **Scheduler** (Chạy tự động 8:00 AM)
✅ **Retry Logic** (Exponential backoff)
✅ **Test Endpoints** (Dễ dàng testing)

---

## 🎯 Next Steps (Future Enhancements)

1. **SMS Integration** (Twilio)
2. **Zalo OA Integration**
3. **Push Notifications** (Firebase)
4. **Multi-language Support**
5. **Custom Templates per User**
6. **A/B Testing** cho message content
7. **Analytics Dashboard** cho reminder performance

---

## 📚 Files Created/Modified

### **New Files:**
- `ReminderType.java` - Enum
- `UserNotificationSetting.java` - Entity
- `NotificationLog.java` - Entity
- `NotificationLogService.java` - Service
- `NextDoseReminderService.java` - Service
- `NotificationSettingController.java` - Controller
- `next-dose-reminder.html` - Template
- `V101__add_next_dose_reminder_and_notification_settings.sql` - Migration
- `*Repository.java` - 2 repositories

### **Modified Files:**
- `VaccinationReminder.java` - Added reminderType, vaccineId, nextDoseNumber
- `VaccinationReminderService.java` - Added reminderType to creation
- `EmailService.java` - Added sendNextDoseReminder()
- `ReminderScheduler.java` - Added sendNextDoseReminders()
- `AppointmentService.java` - Integrated next dose reminder creation

---

## 🎉 Summary

Hệ thống đã **HOÀN CHỈNH** theo đúng yêu cầu:

1. ✅ **Nhắc lịch hẹn** (Appointment Reminder): Nhắc user đến đúng giờ đã book
2. ✅ **Nhắc mũi tiếp theo** (Next Dose Reminder): Tự động dựa trên phác đồ vaccine
3. ✅ **Kênh gửi**: Email (SMS/Zalo ready to add)
4. ✅ **Scheduler**: Chạy tự động 8:00 AM hàng ngày
5. ✅ **User Settings**: Bật/tắt từng loại notification
6. ✅ **Notification Log**: Tránh spam và track history

**Ready to deploy!** 🚀
