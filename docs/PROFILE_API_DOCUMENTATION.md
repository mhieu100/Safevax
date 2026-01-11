# Profile API Documentation

## Overview
ProfileController cung cấp 4 bộ API riêng biệt cho từng role: PATIENT, DOCTOR, CASHIER, ADMIN.

Mỗi role có 2 endpoints:
- `GET /api/profile/{role}` - Lấy thông tin profile
- `PUT /api/profile/{role}` - Cập nhật thông tin profile

---

## 1. PATIENT Profile APIs

### 1.1. Get Patient Profile
```http
GET /api/profile/patient
Authorization: Bearer <token>
Role: PATIENT
```

**Response:**
```json
{
  "code": 200,
  "message": "Get patient profile successfully",
  "data": {
    "id": 1,
    "avatar": "http://localhost:8080/storage/user/avatar.png",
    "fullName": "Nguyễn Văn A",
    "email": "patient@example.com",
    "phone": "0987654321",
    "gender": "MALE",
    "birthday": "1990-01-15",
    "address": "123 Đường ABC, Quận 1, TP.HCM",
    "role": "PATIENT",
    "patientId": 1,
    "identityNumber": "079090001234",
    "bloodType": "O_POSITIVE",
    "heightCm": 170.5,
    "weightKg": 65.0,
    "occupation": "Software Engineer",
    "lifestyleNotes": "Regular exercise, no smoking",
    "insuranceNumber": "INS123456789",
    "consentForAIAnalysis": true
  }
}
```

### 1.2. Update Patient Profile
```http
PUT /api/profile/patient
Authorization: Bearer <token>
Role: PATIENT
Content-Type: application/json
```

**Request Body:**
```json
{
  "fullName": "Nguyễn Văn A",
  "phone": "0987654321",
  "gender": "MALE",
  "birthday": "1990-01-15",
  "address": "123 Đường ABC, Quận 1, TP.HCM",
  "identityNumber": "079090001234",
  "bloodType": "O_POSITIVE",
  "heightCm": 171.0,
  "weightKg": 66.0,
  "occupation": "Senior Software Engineer",
  "lifestyleNotes": "Regular exercise, no smoking, vegetarian",
  "insuranceNumber": "INS123456789",
  "consentForAIAnalysis": true
}
```

**Response:** Same as Get Patient Profile

---

## 2. DOCTOR Profile APIs

### 2.1. Get Doctor Profile
```http
GET /api/profile/doctor
Authorization: Bearer <token>
Role: DOCTOR
```

**Response:**
```json
{
  "code": 200,
  "message": "Get doctor profile successfully",
  "data": {
    "id": 2,
    "avatar": "http://localhost:8080/storage/user/doctor.png",
    "fullName": "Dr. Trần Thị B",
    "email": "doctor@example.com",
    "phone": "0912345678",
    "gender": "FEMALE",
    "birthday": "1985-05-20",
    "address": "456 Đường XYZ, Quận 3, TP.HCM",
    "role": "DOCTOR",
    "doctorId": 1,
    "licenseNumber": "DOC123456",
    "specialization": "Pediatrics",
    "consultationDuration": 30,
    "maxPatientsPerDay": 20,
    "isAvailable": true,
    "centerId": 1,
    "centerName": "Trung tâm Y tế Quận 1",
    "centerAddress": "100 Lê Lợi, Quận 1, TP.HCM"
  }
}
```

### 2.2. Update Doctor Profile
```http
PUT /api/profile/doctor
Authorization: Bearer <token>
Role: DOCTOR
Content-Type: application/json
```

**Request Body:**
```json
{
  "fullName": "Dr. Trần Thị B",
  "phone": "0912345678",
  "gender": "FEMALE",
  "birthday": "1985-05-20",
  "address": "456 Đường XYZ, Quận 3, TP.HCM",
  "specialization": "Pediatrics & Vaccination",
  "consultationDuration": 30,
  "maxPatientsPerDay": 25
}
```

**Response:** Same as Get Doctor Profile

**Note:** Doctor chỉ có thể update thông tin cá nhân và một số thông tin chuyên môn. Center assignment được quản lý bởi ADMIN.

---

## 3. CASHIER Profile APIs

### 3.1. Get Cashier Profile
```http
GET /api/profile/cashier
Authorization: Bearer <token>
Role: CASHIER
```

**Response:**
```json
{
  "code": 200,
  "message": "Get cashier profile successfully",
  "data": {
    "id": 3,
    "avatar": "http://localhost:8080/storage/user/cashier.png",
    "fullName": "Lê Văn C",
    "email": "cashier@example.com",
    "phone": "0923456789",
    "gender": "MALE",
    "birthday": "1995-08-10",
    "address": "789 Đường DEF, Quận 5, TP.HCM",
    "role": "CASHIER",
    "cashierId": 1,
    "employeeCode": "CASH000001",
    "shiftStartTime": "08:00",
    "shiftEndTime": "17:00",
    "isActive": true,
    "centerId": 1,
    "centerName": "Trung tâm Y tế Quận 1",
    "centerAddress": "100 Lê Lợi, Quận 1, TP.HCM"
  }
}
```

### 3.2. Update Cashier Profile
```http
PUT /api/profile/cashier
Authorization: Bearer <token>
Role: CASHIER
Content-Type: application/json
```

**Request Body:**
```json
{
  "fullName": "Lê Văn C",
  "phone": "0923456789",
  "gender": "MALE",
  "birthday": "1995-08-10",
  "address": "789 Đường DEF, Quận 5, TP.HCM",
  "shiftStartTime": "08:00",
  "shiftEndTime": "17:00"
}
```

**Response:** Same as Get Cashier Profile

**Note:** Cashier có thể update thông tin cá nhân. Shift times thường được quản lý bởi ADMIN nhưng có thể cho phép tự điều chỉnh.

---

## 4. ADMIN Profile APIs

### 4.1. Get Admin Profile
```http
GET /api/profile/admin
Authorization: Bearer <token>
Role: ADMIN
```

**Response:**
```json
{
  "code": 200,
  "message": "Get admin profile successfully",
  "data": {
    "id": 4,
    "avatar": "http://localhost:8080/storage/user/admin.png",
    "fullName": "Phạm Thị D",
    "email": "admin@example.com",
    "phone": "0934567890",
    "gender": "FEMALE",
    "birthday": "1980-03-25",
    "address": "321 Đường GHI, Quận Bình Thạnh, TP.HCM",
    "role": "ADMIN"
  }
}
```

### 4.2. Update Admin Profile
```http
PUT /api/profile/admin
Authorization: Bearer <token>
Role: ADMIN
Content-Type: application/json
```

**Request Body:**
```json
{
  "fullName": "Phạm Thị D",
  "phone": "0934567890",
  "gender": "FEMALE",
  "birthday": "1980-03-25",
  "address": "321 Đường GHI, Quận Bình Thạnh, TP.HCM"
}
```

**Response:** Same as Get Admin Profile

**Note:** Admin chỉ có common user fields, không có role-specific profile.

---

## Common Fields (All Roles)

Tất cả các role đều có các trường chung:
- `id`: User ID
- `avatar`: URL ảnh đại diện
- `fullName`: Họ tên đầy đủ
- `email`: Email (không thể thay đổi)
- `phone`: Số điện thoại (9-11 chữ số)
- `gender`: Giới tính (MALE, FEMALE, OTHER)
- `birthday`: Ngày sinh (phải là ngày trong quá khứ)
- `address`: Địa chỉ
- `role`: Vai trò của user

## Role-Specific Fields

### PATIENT
- `patientId`: ID bệnh nhân
- `identityNumber`: CMND/CCCD (9-12 chữ số)
- `bloodType`: Nhóm máu (A_POSITIVE, A_NEGATIVE, B_POSITIVE, B_NEGATIVE, AB_POSITIVE, AB_NEGATIVE, O_POSITIVE, O_NEGATIVE)
- `heightCm`: Chiều cao (cm)
- `weightKg`: Cân nặng (kg)
- `occupation`: Nghề nghiệp
- `lifestyleNotes`: Ghi chú về lối sống
- `insuranceNumber`: Số bảo hiểm y tế
- `consentForAIAnalysis`: Đồng ý phân tích AI

### DOCTOR
- `doctorId`: ID bác sĩ
- `licenseNumber`: Số giấy phép hành nghề
- `specialization`: Chuyên khoa
- `consultationDuration`: Thời gian khám (phút)
- `maxPatientsPerDay`: Số bệnh nhân tối đa/ngày
- `isAvailable`: Trạng thái sẵn sàng
- `centerId`: ID trung tâm
- `centerName`: Tên trung tâm
- `centerAddress`: Địa chỉ trung tâm

### CASHIER
- `cashierId`: ID thu ngân
- `employeeCode`: Mã nhân viên
- `shiftStartTime`: Giờ bắt đầu ca (HH:mm)
- `shiftEndTime`: Giờ kết thúc ca (HH:mm)
- `isActive`: Trạng thái hoạt động
- `centerId`: ID trung tâm
- `centerName`: Tên trung tâm
- `centerAddress`: Địa chỉ trung tâm

---

## Validation Rules

### Common Fields
- `fullName`: Required, không được trống
- `phone`: Pattern `^[0-9]{9,11}$`
- `birthday`: Phải là ngày trong quá khứ

### PATIENT Specific
- `identityNumber`: Pattern `^[0-9]{9,12}$`, phải unique
- `heightCm`: Phải > 0
- `weightKg`: Phải > 0

---

## Error Responses

### 400 Bad Request - Validation Error
```json
{
  "code": 400,
  "message": "Validation failed",
  "errors": {
    "phone": "Phone must be 9-11 digits",
    "birthday": "Birthday must be in the past"
  }
}
```

### 401 Unauthorized
```json
{
  "code": 401,
  "message": "Unauthorized"
}
```

### 403 Forbidden - Wrong Role
```json
{
  "code": 403,
  "message": "Access Denied"
}
```

### 404 Not Found - Profile Not Found
```json
{
  "code": 404,
  "message": "Patient profile not found"
}
```

### 409 Conflict - Duplicate Identity Number
```json
{
  "code": 409,
  "message": "Identity number already exists"
}
```

---

## Security Notes

1. **Authentication**: Tất cả endpoints yêu cầu JWT token trong Authorization header
2. **Authorization**: Mỗi endpoint chỉ cho phép role tương ứng truy cập
3. **Email không thể thay đổi**: Email là unique identifier và không thể update qua profile API
4. **Center assignment**: DOCTOR và CASHIER không thể tự thay đổi center, chỉ ADMIN mới có quyền

---

## Usage Examples

### Get Current User Profile (based on role)
```javascript
// Frontend code
const token = localStorage.getItem('token');
const userRole = getUserRole(); // 'PATIENT', 'DOCTOR', 'CASHIER', or 'ADMIN'

const response = await fetch(`/api/profile/${userRole.toLowerCase()}`, {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const data = await response.json();
console.log(data.data); // Profile info
```

### Update Profile
```javascript
const updateData = {
  fullName: "New Name",
  phone: "0987654321",
  address: "New Address"
  // ... other fields
};

const response = await fetch(`/api/profile/${userRole.toLowerCase()}`, {
  method: 'PUT',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(updateData)
});

const result = await response.json();
if (result.code === 200) {
  console.log('Profile updated successfully');
}
```
