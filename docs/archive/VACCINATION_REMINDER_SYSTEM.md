# Hệ thống nhắc nhở lịch tiêm chủng tự động

## Tổng quan

Hệ thống tự động gửi email để nhắc nhở người dùng về lịch tiêm chủng sắp tới.

## Tính năng

### 1. **Tự động tạo reminders**
- Khi appointment được scheduled, hệ thống tự động tạo reminders
- Mặc định gửi trước 1, 3, 7 ngày (có thể cấu hình)
- Hỗ trợ kênh: EMAIL

### 2. **Scheduler tự động**
- Chạy mỗi ngày lúc 8:00 AM để gửi reminders
- Retry failed reminders mỗi 2 giờ
- Exponential backoff cho retry (30 phút, 1 giờ, 2 giờ)

### 3. **Email Templates**
- Template đẹp, responsive với Thymeleaf
- Bao gồm: reminder, confirmation, cancellation

## Cấu hình

### 1. Environment Variables (.env)

```properties
# Email Configuration
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_FROM_EMAIL=noreply@safevax.com
MAIL_FROM_NAME=SafeVax

# Reminder Settings
REMINDER_DAYS_BEFORE=1,3,7
REMINDER_CRON=0 0 8 * * ?
```

### 2. Gmail Setup (cho Email)

1. Đăng nhập Gmail
2. Bật 2-Factor Authentication
3. Tạo App Password:
   - Vào: https://myaccount.google.com/apppasswords
   - Tạo password mới cho "Mail"
   - Copy password vào `MAIL_PASSWORD`

### 3. Twilio Setup (cho SMS)

1. Đăng ký tài khoản: https://www.twilio.com
2. Get your Account SID và Auth Token
3. Mua số điện thoại Twilio
4. Copy credentials vào .env

### 4. Zalo OA Setup

1. Đăng ký Zalo Official Account: https://oa.zalo.me
## Database Schema(50) NOT NULL,   -- PENDING, SENT, FAILED, CANCELLED
    days_before INTEGER NOT NULL,
    recipient_email VARCHAR(255),
    recipient_phone VARCHAR(50),
    recipient_zalo_id VARCHAR(255),
    message TEXT,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    channel VARCHAR(50) NOT NULL,  -- EMAIL only
    scheduled_date DATE NOT NULL,

## API Endpoints

### 1. Get My Reminders
```
GET /api/reminders/my-reminders?userId={userId}
Authorization: Bearer {token}
```

### 2. Get Appointment Reminders
```
GET /api/reminders/appointment/{appointmentId}
Authorization: Bearer {token}
```

### 3. Send Pending Reminders (Admin)
```
POST /api/reminders/send-pending
Authorization: Bearer {admin-token}
```

### 4. Retry Failed Reminders (Admin)
```
POST /api/reminders/retry-failed
Authorization: Bearer {admin-token}
```

### 5. Cancel Appointment Reminders
```
DELETE /api/reminders/appointment/{appointmentId}
Authorization: Bearer {token}
```

### 6. Get Statistics (Admin)
```
GET /api/reminders/statistics?startDate=2024-01-01&endDate=2024-12-31
Authorization: Bearer {admin-token}
```

## Luồng hoạt động

### 1. Tạo Appointment
```
Appointment được SCHEDULED
    ↓
VaccinationReminderService.createRemindersForAppointment()
    ↓
Tạo reminders cho các ngày: -1, -3, -7 days
    ↓
Lưu vào database với status PENDING
```

### 2. Gửi Reminders tự động
```
ReminderScheduler chạy lúc 8:00 AM
    ↓
VaccinationReminderService.sendPendingReminders()
    ↓
Query reminders có scheduled_date = TODAY và status = PENDING
    ↓
Với mỗi reminder:
    - EMAIL: EmailService.sendVaccinationReminder()
    ↓
Update status = SENT hoặc FAILED
```

### 3. Retry Failed Reminders
```
ReminderScheduler chạy mỗi 2 giờ
    ↓
VaccinationReminderService.retryFailedReminders()
    ↓
Query reminders có status = FAILED và next_retry_at <= NOW
    ↓
Retry gửi (tối đa 3 lần)
    ↓
Exponential backoff: 30min → 1h → 2h
```

## Services

### 1. EmailService
- `sendVaccinationReminder()`: Gửi email nhắc nhở
- `sendAppointmentConfirmation()`: Email xác nhận
- `sendAppointmentCancellation()`: Email hủy lịch
- `sendHtmlEmail()`: Gửi HTML email
- `sendSimpleEmail()`: Gửi plain text email

- `sendSimpleEmail()`: Gửi plain text email

### 2. VaccinationReminderServiceeminders hôm nay
- `retryFailedReminders()`: Retry reminders bị lỗi
- `cancelRemindersForAppointment()`: Hủy reminders
- `getUserReminders()`: Lấy reminders của user
- `getReminderStatistics()`: Thống kê reminders

## Testing

### Test Email locally

```bash
# Start backend
cd backend
mvn spring-boot:run

# Call API to send pending reminders
curl -X POST http://localhost:8080/api/reminders/send-pending \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

### Test SMS locally

```bash
# Make sure Twilio credentials are set
# Call SMS service directly or through scheduler
```

### Test Scheduler

```properties
# Cấu hình chạy mỗi phút để test
REMINDER_CRON=0 * * * * ?
```

## Monitoring

### 1. Logs
```bash
# Xem logs scheduler
grep "daily reminder scheduler" logs/spring.log

# Xem logs gửi email
grep "Email sent successfully" logs/spring.log

# Xem logs lỗi
grep "Failed to send reminder" logs/spring.log
```

### 2. Database Query
```sql
-- Reminders pending hôm nay
SELECT * FROM vaccination_reminders 
WHERE scheduled_date = CURRENT_DATE 
AND status = 'PENDING';

-- Reminders đã gửi
SELECT * FROM vaccination_reminders 
WHERE status = 'SENT' 
ORDER BY sent_at DESC;

-- Reminders bị lỗi
SELECT * FROM vaccination_reminders 
WHERE status = 'FAILED' 
ORDER BY updated_at DESC;

-- Thống kê theo channel
SELECT channel, status, COUNT(*) 
FROM vaccination_reminders 
GROUP BY channel, status;
```

## Troubleshooting

### Email không gửi được
1. Kiểm tra MAIL_USERNAME và MAIL_PASSWORD
2. Gmail: Cần App Password, không dùng password thường
3. Check logs: `grep "Email" logs/spring.log`

### SMS không gửi được
1. Kiểm tra Twilio credentials
2. Kiểm tra số điện thoại format: +84xxxxxxxxx
3. Kiểm tra tài khoản Twilio có credit không

### Zalo không gửi được
### Email không gửi được
1. Kiểm tra MAIL_USERNAME và MAIL_PASSWORD
2. Gmail: Cần App Password, không dùng password thường
3. Check logs: `grep "Email" logs/spring.log`

### Scheduler không chạyđủ để debug
6. **Error Handling**: Không fail appointment nếu reminder fail

## Future Enhancements

1. Push notification (Firebase)
2. WhatsApp integration
3. Multi-language support
4. Custom reminder templates per user
5. User preference cho reminder channels
6. A/B testing cho message content
7. Analytics dashboard cho reminder performance
## Best Practices

1. **Email**: Dùng template HTML đẹp, responsive
2. **Retry**: Giới hạn số lần retry (max 3)
3. **Logging**: Log đầy đủ để debug
4. **Error Handling**: Không fail appointment nếu reminder fail## Future Enhancements

1. SMS integration (Twilio)
2. Zalo OA integration
3. Push notification (Firebase)
4. WhatsApp integration
5. Multi-language support
6. Custom reminder templates per user
7. User preference cho reminder channels
8. A/B testing cho message content
9. Analytics dashboard cho reminder performance