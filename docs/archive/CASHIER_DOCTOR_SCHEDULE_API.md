# Doctor Schedule API - Cashier View

## Overview
API endpoint để hiển thị danh sách bác sĩ với lịch làm việc hôm nay cho cashier. API tự động lấy center của cashier đang đăng nhập.

## Endpoint

### Get Doctors with Today's Schedule in My Center
Lấy danh sách bác sĩ thuộc trung tâm của cashier đang đăng nhập, kèm theo thông tin lịch làm việc và thống kê slots.

**URL:** `GET /api/v1/doctors/my-center/with-schedule`

**Authentication:** Required (Bearer Token)

**Query Parameters:**
- `date` (optional): Date in format `YYYY-MM-DD` (default: today)
  - Example: `2025-11-23`

**Request Example:**
```bash
# Get today's schedule
curl -X GET "http://localhost:8080/api/v1/doctors/my-center/with-schedule" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"

# Get schedule for specific date
curl -X GET "http://localhost:8080/api/v1/doctors/my-center/with-schedule?date=2025-11-25" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Response (200 OK):**
```json
[
  {
    "doctorId": 1,
    "userId": 5,
    "doctorName": "Nguyễn Văn Minh",
    "email": "doctor.center1.a@vax.com",
    "avatar": null,
    "phone": "doctor.center1.a@vax.com",
    "licenseNumber": "BYT-000001",
    "specialization": "Nhi khoa",
    "consultationDuration": 30,
    "maxPatientsPerDay": 20,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "Trung tâm Tiêm chủng Quận 1",
    "totalSlotsToday": 14,
    "availableSlotsToday": 10,
    "bookedSlotsToday": 4,
    "blockedSlotsToday": 0,
    "workingHoursToday": "08:00 - 17:00",
    "todaySchedule": [
      {
        "slotId": 1,
        "doctorId": 1,
        "doctorName": "Nguyễn Văn Minh",
        "slotDate": "2025-11-23",
        "startTime": "08:00",
        "endTime": "08:30",
        "status": "AVAILABLE",
        "appointmentId": null,
        "notes": null
      },
      {
        "slotId": 2,
        "doctorId": 1,
        "doctorName": "Nguyễn Văn Minh",
        "slotDate": "2025-11-23",
        "startTime": "08:30",
        "endTime": "09:00",
        "status": "BOOKED",
        "appointmentId": 123,
        "notes": "Tiêm vắc xin COVID-19"
      }
      // ... more slots
    ]
  },
  {
    "doctorId": 2,
    "userId": 6,
    "doctorName": "Trần Thị Lan",
    "email": "doctor.center1.b@vax.com",
    "avatar": null,
    "phone": "doctor.center1.b@vax.com",
    "licenseNumber": "BYT-000002",
    "specialization": "Đa khoa",
    "consultationDuration": 30,
    "maxPatientsPerDay": 20,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "Trung tâm Tiêm chủng Quận 1",
    "totalSlotsToday": 14,
    "availableSlotsToday": 12,
    "bookedSlotsToday": 2,
    "blockedSlotsToday": 0,
    "workingHoursToday": "08:00 - 17:00",
    "todaySchedule": [
      // ... slots for this doctor
    ]
  }
  // ... more doctors
]
```

**Error Responses:**

**401 Unauthorized:**
```json
{
  "message": "Unauthorized access"
}
```

**404 Not Found:**
```json
{
  "message": "User not found"
}
```

**400 Bad Request:**
```json
{
  "message": "User is not assigned to any center"
}
```

---

## Response Fields

### DoctorWithScheduleResponse
| Field | Type | Description |
|-------|------|-------------|
| `doctorId` | Long | ID của bác sĩ |
| `userId` | Long | ID của user account |
| `doctorName` | String | Tên đầy đủ của bác sĩ |
| `email` | String | Email của bác sĩ |
| `avatar` | String | URL avatar (nullable) |
| `phone` | String | Số điện thoại hoặc email |
| `licenseNumber` | String | Số chứng chỉ hành nghề (VD: BYT-000001) |
| `specialization` | String | Chuyên khoa (VD: Nhi khoa, Đa khoa) |
| `consultationDuration` | Integer | Thời gian khám mỗi bệnh nhân (phút) |
| `maxPatientsPerDay` | Integer | Số bệnh nhân tối đa mỗi ngày |
| `isAvailable` | Boolean | Bác sĩ có đang hoạt động không |
| `centerId` | Long | ID trung tâm |
| `centerName` | String | Tên trung tâm |
| `totalSlotsToday` | Integer | Tổng số slot trong ngày |
| `availableSlotsToday` | Integer | Số slot còn trống |
| `bookedSlotsToday` | Integer | Số slot đã đặt |
| `blockedSlotsToday` | Integer | Số slot bị chặn |
| `workingHoursToday` | String | Giờ làm việc (VD: "08:00 - 17:00") |
| `todaySchedule` | Array | Danh sách slots chi tiết |

### DoctorAvailableSlotResponse (in todaySchedule)
| Field | Type | Description |
|-------|------|-------------|
| `slotId` | Long | ID của slot |
| `doctorId` | Long | ID bác sĩ |
| `doctorName` | String | Tên bác sĩ |
| `slotDate` | LocalDate | Ngày (YYYY-MM-DD) |
| `startTime` | String | Giờ bắt đầu (HH:mm) |
| `endTime` | String | Giờ kết thúc (HH:mm) |
| `status` | String | AVAILABLE / BOOKED / BLOCKED |
| `appointmentId` | Long | ID lịch hẹn (nếu đã đặt) |
| `notes` | String | Ghi chú |

---

## Slot Status
| Status | Description |
|--------|-------------|
| `AVAILABLE` | Slot trống, có thể đặt lịch |
| `BOOKED` | Slot đã có lịch hẹn |
| `BLOCKED` | Slot bị chặn (bác sĩ nghỉ, bảo trì, v.v.) |

---

## Business Logic

### 1. Authentication
- API yêu cầu Bearer token
- Token phải thuộc user role CASHIER hoặc ADMIN
- Tự động lấy center_id từ user đang đăng nhập

### 2. Date Selection
- Mặc định: Ngày hôm nay
- Có thể chọn ngày khác qua query parameter `date`
- Format: `YYYY-MM-DD`

### 3. Doctor Filtering
- Chỉ hiển thị doctors có `isAvailable = true`
- Chỉ hiển thị doctors thuộc center của cashier
- Sắp xếp theo doctorId

### 4. Schedule Calculation
- `workingHoursToday`: Lấy từ schedule template hoặc special schedule
- Nếu có special schedule: ưu tiên special schedule
- Nếu không: lấy từ weekly schedule (0=Sunday, 1=Monday, ..., 6=Saturday)
- Nếu doctor nghỉ phép: không có slot

### 5. Statistics
- `totalSlotsToday`: Tổng số slots được generate
- `availableSlotsToday`: Đếm slots có status = AVAILABLE
- `bookedSlotsToday`: Đếm slots có status = BOOKED
- `blockedSlotsToday`: Đếm slots có status = BLOCKED

---

## Frontend Integration

### React Component Usage
```javascript
import { getDoctorsWithScheduleAPI } from '../../config/api.doctor.schedule';
import dayjs from 'dayjs';

// Get today's schedule
const fetchDoctors = async () => {
  try {
    const response = await getDoctorsWithScheduleAPI();
    setDoctors(response.data);
  } catch (error) {
    message.error('Không thể tải danh sách bác sĩ');
  }
};

// Get schedule for specific date
const fetchDoctorsForDate = async (date) => {
  try {
    const dateStr = dayjs(date).format('YYYY-MM-DD');
    const response = await getDoctorsWithScheduleAPI(dateStr);
    setDoctors(response.data);
  } catch (error) {
    message.error('Không thể tải danh sách bác sĩ');
  }
};
```

### Display Doctor Card
```javascript
doctors.map(doctor => (
  <Card key={doctor.doctorId}>
    <h3>BS. {doctor.doctorName}</h3>
    <p>Chuyên khoa: {doctor.specialization}</p>
    <p>Ca làm việc: {doctor.workingHoursToday}</p>
    
    <div>
      <Badge 
        count={`${doctor.availableSlotsToday} trống`} 
        style={{ backgroundColor: '#52c41a' }} 
      />
      <Badge 
        count={`${doctor.bookedSlotsToday} đã đặt`} 
        style={{ backgroundColor: '#f5222d' }} 
      />
    </div>
    
    {doctor.todaySchedule.map(slot => (
      <div key={slot.slotId}>
        <span>{slot.startTime} - {slot.endTime}</span>
        <Badge 
          status={slot.status === 'AVAILABLE' ? 'success' : 'error'} 
          text={slot.status === 'AVAILABLE' ? 'Trống' : 'Đã đặt'} 
        />
      </div>
    ))}
  </Card>
))
```

---

## Testing

### Manual Test with curl
```bash
# 1. Login as cashier
TOKEN=$(curl -s -X POST "http://localhost:8080/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"cashier.d@vax.com","password":"123456"}' \
  | jq -r '.accessToken')

# 2. Get today's schedule
curl -X GET "http://localhost:8080/api/v1/doctors/my-center/with-schedule" \
  -H "Authorization: Bearer $TOKEN" | jq

# 3. Get tomorrow's schedule
curl -X GET "http://localhost:8080/api/v1/doctors/my-center/with-schedule?date=2025-11-24" \
  -H "Authorization: Bearer $TOKEN" | jq
```

### Automated Test Script
```bash
# Run test script
chmod +x test-cashier-doctor-schedule.sh
./test-cashier-doctor-schedule.sh
```

---

## Expected Results

### Typical Response for a Center with 4 Doctors
- **Doctor 1**: Nhi khoa - 14 slots (10 available, 4 booked)
- **Doctor 2**: Đa khoa - 14 slots (12 available, 2 booked)
- **Doctor 3**: Truyền nhiễm - 16 slots (12 available, 4 booked)
- **Doctor 4**: Sản Phụ khoa - 8 slots (3 available, 5 booked)

**Total:**
- Total Doctors: 4
- Total Slots: 52
- Available: 37
- Booked: 15
- Availability Rate: 71%

### Edge Cases

**Case 1: Doctor on Leave**
- `todaySchedule`: empty array
- `totalSlotsToday`: 0
- `workingHoursToday`: "Không có lịch làm việc"

**Case 2: Doctor with Special Schedule**
- `workingHoursToday`: Shows special hours (e.g., "10:00 - 14:00")
- Fewer slots than normal day

**Case 3: No Doctors in Center**
- Returns empty array `[]`
- HTTP 200 OK

**Case 4: Cashier Not Assigned to Center**
- HTTP 400 Bad Request
- Message: "User is not assigned to any center"

---

## Performance

### Response Time
- Expected: < 500ms for 20 doctors
- Optimized with:
  - Single query to fetch doctors
  - Batch query for slots
  - Database indexes on (doctor_id, slot_date, status)

### Caching Strategy
- Consider caching for 1-5 minutes
- Invalidate cache when:
  - New appointment created
  - Appointment cancelled
  - Doctor schedule updated

---

## Security

### Authorization Rules
1. Only CASHIER and ADMIN roles can access
2. Cashier can only see doctors in their center
3. ADMIN can see all doctors (future enhancement)

### Data Protection
- No sensitive patient information in response
- Only shows appointment exists (appointmentId)
- Patient details require separate API call

---

## Related APIs

### Other Doctor Schedule APIs
- `GET /api/v1/doctors/center/{centerId}/available` - Simple doctor list
- `GET /api/v1/doctors/{doctorId}/schedules` - Weekly template
- `GET /api/v1/doctors/{doctorId}/slots/available?date=XXX` - Slots for one doctor
- `GET /api/v1/doctors/center/{centerId}/slots/available?date=XXX` - All slots in center
- `GET /api/v1/doctors/{doctorId}/slots?startDate=XXX&endDate=XXX` - Date range
- `POST /api/v1/doctors/{doctorId}/slots/generate` - Generate new slots

---

## Changelog

### Version 1.0 (2025-11-23)
- Initial release
- Added `GET /api/v1/doctors/my-center/with-schedule`
- Support date parameter
- Return complete doctor info with schedule and statistics
- Optimized for cashier doctor-schedule page

---

## Support

For issues or questions:
1. Check backend logs for errors
2. Verify migrations V3 and V4 executed
3. Ensure slots are generated for the target date
4. Confirm user has center_id assigned

**Last Updated:** 2025-11-23
**Version:** 1.0.0
