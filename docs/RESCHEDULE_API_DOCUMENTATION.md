# Reschedule Appointment API Documentation

## Overview
This API allows patients to request rescheduling of their appointments. The rescheduled appointment will be flagged for cashier review and doctor reassignment.

## Workflow
1. **Patient requests reschedule** → Patient submits new desired date/time
2. **System updates appointment** → Status changes to `PENDING_APPROVAL`
3. **Appointment flagged for review** → Original doctor assignment retained but needs cashier review
4. **Cashier reviews and processes** → Cashier verifies new time slot and reassigns doctor if needed
5. **Appointment confirmed** → Status changes to `SCHEDULED` with new date/time

## API Endpoint

### Reschedule Appointment
**PUT** `/appointments/reschedule`

#### Authentication
Required. Patient must own the appointment (either as patient or family member).

#### Request Body
```json
{
  "appointmentId": 1,
  "desiredDate": "2025-11-25",
  "desiredTime": "14:30:00",
  "reason": "Có việc đột xuất, muốn đổi sang chiều"
}
```

#### Request Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| appointmentId | Long | Yes | ID of the appointment to reschedule |
| desiredDate | LocalDate | Yes | New desired date (must be in future) |
| desiredTime | LocalTime | Yes | New desired time |
| reason | String | No | Reason for rescheduling |

#### Response (Success - 200 OK)
```json
{
  "appointmentId": 1,
  "oldDate": "2025-11-20",
  "oldTime": "10:00:00",
  "newDate": "2025-11-25",
  "newTime": "14:30:00",
  "status": "PENDING_APPROVAL",
  "message": "Reschedule request submitted successfully. Waiting for cashier approval and doctor reassignment."
}
```

#### Response (Error - 400 Bad Request)
```json
{
  "timestamp": "2025-11-17T10:00:00.000+00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Cannot reschedule completed appointments"
}
```

#### Error Cases
- `400`: Appointment already completed or cancelled
- `401`: Unauthorized (not logged in)
- `403`: User doesn't own the appointment
- `404`: Appointment not found
- `422`: Invalid date (not in future)

## Appointment Status Flow

```
PENDING_SCHEDULE → (initial booking)
    ↓
SCHEDULED → (cashier assigns doctor) → (patient requests reschedule)
    ↓
PENDING_APPROVAL → (awaiting cashier review)
    ↓
SCHEDULED → (cashier approves and reassigns doctor)
    ↓
COMPLETED or CANCELLED
```

## Database Changes

### Appointment Table - New Columns
```sql
ALTER TABLE appointments 
ADD COLUMN desired_date DATE,
ADD COLUMN desired_time TIME,
ADD COLUMN reschedule_reason VARCHAR(500),
ADD COLUMN rescheduled_at TIMESTAMP;
```

### Updated Appointment Status Enum
```java
public enum AppointmentEnum {
    PENDING_SCHEDULE,
    PENDING_APPROVAL,  // NEW - for rescheduled appointments
    RESCHEDULED,
    SCHEDULED,
    COMPLETED,
    CANCELLED
}
```

## Cashier Processing

When cashier processes a `PENDING_APPROVAL` appointment:

**PUT** `/appointments` (existing endpoint)
```json
{
  "appointmentId": 1,
  "doctorId": 5
}
```

The system will:
1. Check if appointment is in `PENDING_APPROVAL` status
2. Apply the `desiredDate` and `desiredTime` to `scheduledDate` and `scheduledTime`
3. Assign the new doctor
4. Update status to `SCHEDULED`

## Frontend Integration Example

### Patient Reschedule Request
```javascript
const rescheduleAppointment = async (appointmentId, newDate, newTime, reason) => {
  try {
    const response = await fetch('/api/appointments/reschedule', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify({
        appointmentId: appointmentId,
        desiredDate: newDate,
        desiredTime: newTime,
        reason: reason
      })
    });
    
    const data = await response.json();
    
    if (response.ok) {
      console.log('Reschedule request submitted:', data);
      alert(data.message);
    } else {
      console.error('Error:', data.message);
    }
  } catch (error) {
    console.error('Network error:', error);
  }
};

// Usage
rescheduleAppointment(1, '2025-11-25', '14:30:00', 'Có việc đột xuất');
```

### Cashier View - Display Pending Approvals
```javascript
// Filter appointments by status
const pendingApprovals = appointments.filter(
  apt => apt.status === 'PENDING_APPROVAL'
);

// Display reschedule information
pendingApprovals.forEach(apt => {
  console.log(`
    Appointment ID: ${apt.id}
    Patient: ${apt.patientName}
    Old Schedule: ${apt.scheduledDate} ${apt.scheduledTime}
    Desired Schedule: ${apt.desiredDate} ${apt.desiredTime}
    Reason: ${apt.rescheduleReason}
    Requested At: ${apt.rescheduledAt}
  `);
});
```

## Testing with Postman

### 1. Login as Patient
```
POST /auth/login
Body:
{
  "username": "patient@example.com",
  "password": "password"
}
```

### 2. Get Appointments
```
GET /appointments/my-appointments
Headers:
Authorization: Bearer {token}
```

### 3. Reschedule Appointment
```
PUT /appointments/reschedule
Headers:
Authorization: Bearer {token}
Content-Type: application/json

Body:
{
  "appointmentId": 1,
  "desiredDate": "2025-12-01",
  "desiredTime": "15:00:00",
  "reason": "Need to change due to personal matter"
}
```

### 4. Login as Cashier
```
POST /auth/login
Body:
{
  "username": "cashier@example.com",
  "password": "password"
}
```

### 5. View Pending Approvals
```
GET /appointments/center?filter=status:'PENDING_APPROVAL'
Headers:
Authorization: Bearer {token}
```

### 6. Approve and Assign Doctor
```
PUT /appointments
Headers:
Authorization: Bearer {token}
Content-Type: application/json

Body:
{
  "appointmentId": 1,
  "doctorId": 5
}
```

## Notes

- Only patients who own the appointment can reschedule
- Completed or cancelled appointments cannot be rescheduled
- The desired date must be in the future
- Original doctor assignment is retained until cashier reassigns
- Cashier can see all reschedule requests with `PENDING_APPROVAL` status
- When cashier approves, the desired date/time automatically becomes the scheduled date/time

