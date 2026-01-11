# API Documentation - SafeVax Backend

> Tài liệu tổng hợp tất cả các API endpoints với @ApiMessage description

## 📋 Tổng quan
- **Tổng số API endpoints**: 77
- **Ngày cập nhật**: December 2, 2025
- **Base URL**: `http://localhost:8080` (Development)
- **Production URL**: `http://52.197.232.53:8080`

---

## 🔐 Authentication APIs (`/auth`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/auth/login/password` | Login patient | No |
| POST | `/auth/login/google` | Login with Google | No |
| POST | `/auth/complete-google-profile` | Complete Google profile with patient information | Yes |
| POST | `/auth/update-password` | Update password | Yes |
| POST | `/auth/register` | Register new patient | No |
| GET | `/auth/refresh` | Refresh token | No (Cookie) |
| POST | `/auth/update-account` | Update account | Yes |
| GET | `/auth/account` | Get profile | Yes |
| GET | `/auth/booking` | Get booking of user | Yes |
| GET | `/auth/history-booking` | Get history booking of user | Yes |
| POST | `/auth/logout` | Logout user | Yes |
| POST | `/auth/avatar` | Update avatar | Yes |

---

## 🏥 Center APIs (`/centers`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/centers/{slug}` | Get center by slug | No |
| GET | `/centers` | Get all centers | No |
| POST | `/centers` | Create a new center | Yes (Admin) |
| PUT | `/centers/{id}` | Update a center | Yes (Admin) |
| DELETE | `/centers/{id}` | Delete a center | Yes (Admin) |

---

## 💉 Vaccine APIs (`/vaccines`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/vaccines` | Get all vaccines | No |
| GET | `/vaccines/countries` | Get all countries | No |
| GET | `/vaccines/{slug}` | Get a vaccine by slug with full info | No |
| POST | `/vaccines` | Create a new vaccine | Yes (Admin) |
| PUT | `/vaccines/{id}` | Update a vaccine | Yes (Admin) |
| DELETE | `/vaccines/{id}` | Delete a vaccine | Yes (Admin) |

---

## 📰 News APIs (`/news`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/news` | Get all news with pagination and filtering | No |
| GET | `/news/published` | Get all published news | No |
| GET | `/news/featured` | Get featured news | No |
| GET | `/news/slug/{slug}` | Get news by slug | No |
| GET | `/news/{id}` | Get news by ID | Yes (Admin) |
| GET | `/news/category/{category}` | Get news by category | No |
| GET | `/news/categories` | Get all news categories | No |
| POST | `/news` | Create new news article | Yes (Admin) |
| PUT | `/news/{id}` | Update news article | Yes (Admin) |
| DELETE | `/news/{id}` | Delete news article | Yes (Admin) |
| PATCH | `/news/{id}/publish` | Publish news article | Yes (Admin) |
| PATCH | `/news/{id}/unpublish` | Unpublish news article | Yes (Admin) |

---

## 📅 Appointment APIs (`/appointments`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/appointments/center` | Get all appointments of center | Yes (Staff) |
| PUT | `/appointments` | Update a appointment of cashier | Yes (Cashier) |
| GET | `/appointments/my-schedules` | Get all appointments of doctor | Yes (Doctor) |
| PUT | `/appointments/{id}/complete` | Complete a appointment | Yes (Doctor) |
| PUT | `/appointments/reschedule` | Reschedule an appointment | Yes (User) |
| PUT | `/appointments/{id}/cancel` | Cancel a appointment | Yes (User) |
| GET | `/appointments/urgent` | Get urgent appointments for cashier dashboard | Yes (Cashier) |
| GET | `/appointments/today` | Get today's appointments for doctor dashboard | Yes (Doctor) |

---

## 👨‍⚕️ Doctor Schedule APIs (`/api/v1/doctors`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/api/v1/doctors/my-center/with-schedule` | Get all doctors with today's schedule in current user's center | Yes (Staff) |
| GET | `/api/v1/doctors/center/{centerId}/available` | Get all available doctors by center | Yes |
| GET | `/api/v1/doctors/{doctorId}/schedules` | Get doctor's weekly schedule template | Yes |
| GET | `/api/v1/doctors/{doctorId}/slots/available` | Get available slots for a doctor on a specific date | Yes |
| GET | `/api/v1/doctors/center/{centerId}/slots/available` | Get all available slots for a center on a specific date | Yes |
| GET | `/api/v1/doctors/{doctorId}/slots` | Get doctor's slots in a date range (for calendar view) | Yes |
| POST | `/api/v1/doctors/{doctorId}/slots/generate` | Generate slots for a doctor in a date range | Yes (Admin) |

---

## 📖 Booking APIs (`/bookings`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/bookings` | Create a booking | Yes (User) |
| GET | `/bookings` | Get all bookings | Yes (Admin/Staff) |

---

## 🛒 Order APIs (`/orders`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/orders` | Create a new order | Yes (User) |
| GET | `/orders` | Get all orders of user | Yes (User) |

---

## 💳 Payment APIs (`/payments`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/payments/paypal/success` | Handle PayPal payment success callback | No |
| GET | `/payments/paypal/cancel` | Handle PayPal payment cancel callback | No |
| GET | `/payments/vnpay/return` | Handle VNPay payment return callback | No |
| POST | `/payments/meta-mask` | Update payment with MetaMask | Yes (User) |

---

## 👥 User APIs (`/users`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/users` | Get all users | Yes (Admin) |
| GET | `/users/doctors` | Get all doctors of center | Yes (Staff) |
| PUT | `/users` | Update a user | Yes (Admin) |
| DELETE | `/users/{id}` | Delete a user | Yes (Admin) |

---

## 👨‍👩‍👧‍👦 Family Member APIs (`/api/family-members`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/api/family-members` | Add a new family member | Yes (User) |
| PUT | `/api/family-members` | Update a family member | Yes (User) |
| DELETE | `/api/family-members/{id}` | Delete a family member | Yes (User) |
| GET | `/api/family-members` | Get all family members | Yes (User) |
| GET | `/api/family-members/{id}` | Get family member by id | Yes (User) |

---

## 🔑 Role APIs (`/roles`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/roles` | Get all roles | Yes (Admin) |
| GET | `/roles/{id}` | Get a role by id | Yes (Admin) |
| PUT | `/roles/{id}` | Update a role | Yes (Admin) |

---

## 🔒 Permission APIs (`/permissions`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/permissions` | Create a permission | Yes (Admin) |
| GET | `/permissions` | Get all permissions | Yes (Admin) |
| PUT | `/permissions` | Update a permission | Yes (Admin) |
| DELETE | `/permissions/{id}` | Delete a permission | Yes (Admin) |

---

## 📁 File APIs (`/files`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| POST | `/files` | Upload single file | Yes |

---

## 🏥 Health Check APIs (`/api/v1`)

| Method | Endpoint | Description | Authentication Required |
|--------|----------|-------------|------------------------|
| GET | `/api/v1/hello` | Health check endpoint | No |
| GET | `/api/v1/hello-secure` | Secure health check endpoint | Yes |

---

## 📊 Thống kê API theo module

| Module | Số lượng API |
|--------|--------------|
| Authentication | 10 |
| Center | 5 |
| Vaccine | 6 |
| News | 12 |
| Appointment | 8 |
| Doctor Schedule | 7 |
| Booking | 2 |
| Order | 2 |
| Payment | 4 |
| User | 4 |
| Family Member | 5 |
| Role | 3 |
| Permission | 4 |
| File | 1 |
| Health Check | 2 |
| **Tổng cộng** | **75** |

---

## 🔍 Ghi chú quan trọng

### Authentication
- Sử dụng JWT token trong header: `Authorization: Bearer <token>`
- Refresh token được lưu trong HTTP-only cookie
- Token expiration: Access token (1 hour), Refresh token (7 days)

### Pagination
Tất cả các API trả về danh sách đều hỗ trợ pagination với query params:
- `page`: Số trang (bắt đầu từ 0)
- `size`: Số lượng items mỗi trang
- `sort`: Sắp xếp theo field (vd: `sort=createdAt,desc`)

### Filtering
Sử dụng Spring Filter syntax:
- `filter=field:'value'`: Equal
- `filter=field~'*value*'`: Like
- `filter=field>'value'`: Greater than
- `filter=field:'value' and field2:'value2'`: AND condition
- `filter=field:'value' or field2:'value2'`: OR condition

### Response Format
Tất cả API response theo format:
```json
{
  "statusCode": 200,
  "message": "Success message from @ApiMessage",
  "data": { ... }
}
```

### Error Response
```json
{
  "statusCode": 400,
  "error": "Error message",
  "message": "Detailed error description"
}
```

---

## 🚀 Deployment Information

### Development
- URL: `http://localhost:8080`
- Database: PostgreSQL 15
- Docker: `docker-compose up`

### Production (EC2)
- URL: `http://52.197.232.53:8080`
- Docker Hub: `mhieu100/safevax-backend:latest`
- Deploy: Push to `main` branch triggers GitHub Actions CI/CD

---

## 📝 Changelog

### Version 1.0.0 (November 30, 2025)
- ✅ Bổ sung @ApiMessage cho tất cả 75 API endpoints
- ✅ Tạo tài liệu API đầy đủ
- ✅ Chuẩn hóa response format
- ✅ Cleanup console.log statements
- ✅ Fix lint errors

---

**Developed by**: SafeVax Team  
**Contact**: mhieu100@example.com  
**Repository**: [safevax-blockchain](https://github.com/mhieu100/safevax-blockchain)
