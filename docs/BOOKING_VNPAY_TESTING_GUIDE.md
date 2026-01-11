# Hướng Dẫn Test VNPay Payment với Postman

## Chuẩn Bị

### 1. Import Postman Collection
- Mở Postman
- Click **Import** → Chọn file `Booking_VNPay_Test.postman_collection.json`
- Collection sẽ có 3 requests:
  - ✅ Create Booking with VNPay Payment (web)
  - ✅ Create Booking with Bank Payment
  - ✅ Create Booking - Mobile User Agent

### 2. Cấu Hình Variables
Sau khi import, cần set 2 biến môi trường:

#### Option A: Collection Variables (Khuyến nghị)
1. Click vào collection name → Tab **Variables**
2. Set giá trị:
   - `base_url`: `http://localhost:8080` (hoặc URL backend của bạn)
   - `access_token`: JWT token lấy từ login endpoint

#### Option B: Environment Variables
1. Create new environment: **SafeVax Local**
2. Add variables:
   ```
   base_url: http://localhost:8080
   access_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

### 3. Lấy Access Token
Nếu chưa có token, cần login trước:

**Request:**
```http
POST {{base_url}}/auth/login
Content-Type: application/json

{
  "username": "your_username",
  "password": "your_password"
}
```

**Response:**
```json
{
  "statusCode": 200,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "..."
  }
}
```

Copy `accessToken` và paste vào biến `access_token` trong Postman.

---

## Cách Test

### Test 1: Create Booking với VNPay (Web Platform)

**Request Body:**
```json
{
  "vaccineId": 1,
  "familyMemberId": 1,
  "appointmentDate": "2025-12-15",
  "appointmentTime": "SLOT_08_00",
  "appointmentCenter": 1,
  "amount": 500000,
  "paymentMethod": "VNPAY"
}
```

**Các Field Quan Trọng:**
- `vaccineId`: ID của vaccine (phải tồn tại trong DB)
- `familyMemberId`: ID thành viên gia đình (có thể null nếu đặt cho chính mình)
- `appointmentDate`: Ngày hẹn (format: YYYY-MM-DD)
- `appointmentTime`: Slot thời gian, các giá trị hợp lệ:
  - `SLOT_07_00` (07:00-09:00)
  - `SLOT_08_00` (08:00-10:00)
  - `SLOT_09_00` (09:00-11:00)
  - `SLOT_10_00` (10:00-12:00)
  - `SLOT_13_00` (13:00-15:00)
  - `SLOT_14_00` (14:00-16:00)
  - `SLOT_15_00` (15:00-17:00)
  - `SLOT_16_00` (16:00-18:00)
- `appointmentCenter`: ID của trung tâm tiêm chủng
- `amount`: Số tiền (VND)
- `paymentMethod`: Phương thức thanh toán:
  - `VNPAY`: VNPay
  - `BANK`: Chuyển khoản ngân hàng (cũng dùng VNPay)
  - `PAYPAL`: PayPal
  - `METAMASK`: Crypto

**Expected Response:**
```json
{
  "statusCode": 200,
  "message": "Create a booking",
  "data": {
    "paymentUrl": "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=50000000&vnp_Command=pay&vnp_CreateDate=20251201153411&vnp_CurrCode=VND&vnp_IpAddr=127.0.0.1&vnp_Locale=vn&vnp_OrderInfo=12345&vnp_OrderType=other&vnp_ReturnUrl=http%3A%2F%2Flocalhost%3A8080%2Fpayments%2Fvnpay%2Freturn%3Fpayment%3D67890%26type%3DAPPOINTMENT%26referenceId%3D12345%26platform%3Dweb&vnp_TmnCode=TEST_TMN_CODE&vnp_TxnRef=1764578051686&vnp_Version=2.1.0&vnp_SecureHash=756b3d6c93e80e082390bc270e80e9cf..."
  }
}
```

**Kiểm Tra:**
✅ Status code: 200  
✅ Response có `data.paymentUrl`  
✅ URL chứa `vnpayment.vn`  
✅ URL decode chứa `platform=web`  

**Copy URL và mở trong browser** để test thanh toán trên VNPay sandbox.

---

### Test 2: Create Booking với Mobile User-Agent

Request này test platform detection để verify rằng mobile app sẽ nhận được deep link redirect.

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {{access_token}}
User-Agent: okhttp/4.9.0 (Android 11; Mobile)  👈 Quan trọng!
```

**Request Body:** (Giống Test 1)
```json
{
  "vaccineId": 1,
  "familyMemberId": 1,
  "appointmentDate": "2025-12-15",
  "appointmentTime": "SLOT_10_00",
  "appointmentCenter": 1,
  "amount": 600000,
  "paymentMethod": "VNPAY"
}
```

**Kiểm Tra:**
✅ URL decode chứa `platform=mobile` (thay vì `platform=web`)  
✅ Khi payment success, sẽ redirect về `myapp://payment/success`  

**Automated Test Script:**
```javascript
pm.test("Payment URL contains platform=mobile", function () {
    var jsonData = pm.response.json();
    var decodedUrl = decodeURIComponent(jsonData.data.paymentUrl);
    pm.expect(decodedUrl).to.include('platform=mobile');
    console.log("Decoded URL: " + decodedUrl);
});
```

---

### Test 3: Create Booking với BANK Payment

**Request Body:**
```json
{
  "vaccineId": 1,
  "familyMemberId": null,
  "appointmentDate": "2025-12-20",
  "appointmentTime": "SLOT_14_00",
  "appointmentCenter": 2,
  "amount": 750000,
  "paymentMethod": "BANK"
}
```

**Lưu ý:** 
- `familyMemberId: null` → Đặt cho chính người dùng
- `paymentMethod: "BANK"` → Vẫn tạo VNPay payment URL

---

## Decode VNPay URL

Để xem chi tiết các tham số trong URL, dùng một trong các cách sau:

### 1. Postman Console
Mở **Console** (bottom left) → Xem log output từ test script

### 2. Online URL Decoder
Copy payment URL → Paste vào https://www.urldecoder.org/

### 3. Browser Console
```javascript
decodeURIComponent("https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=...")
```

**Decoded URL sẽ có dạng:**
```
https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?
vnp_Amount=50000000&
vnp_Command=pay&
vnp_CreateDate=20251201153411&
vnp_CurrCode=VND&
vnp_IpAddr=127.0.0.1&
vnp_Locale=vn&
vnp_OrderInfo=12345&
vnp_OrderType=other&
vnp_ReturnUrl=http://localhost:8080/payments/vnpay/return?payment=67890&type=APPOINTMENT&referenceId=12345&platform=web&
vnp_TmnCode=TEST_TMN_CODE&
vnp_TxnRef=1764578051686&
vnp_Version=2.1.0&
vnp_SecureHash=756b3d6c93e80e082390bc270e80e9cf...
```

**Các tham số quan trọng:**
- `vnp_Amount`: Số tiền x100 (VND cents)
- `vnp_ReturnUrl`: Callback URL sau khi thanh toán
  - Chứa `payment`: Payment ID
  - Chứa `type`: APPOINTMENT hoặc ORDER
  - Chứa `referenceId`: Booking/Order ID
  - Chứa `platform`: web hoặc mobile
- `vnp_SecureHash`: Chữ ký bảo mật

---

## Troubleshooting

### 1. Error: "Unauthorized" (401)
❌ **Nguyên nhân:** Token hết hạn hoặc không hợp lệ  
✅ **Giải pháp:** Login lại để lấy token mới

### 2. Error: "Vaccine not found" (404)
❌ **Nguyên nhân:** `vaccineId` không tồn tại trong DB  
✅ **Giải pháp:** Dùng ID vaccine có sẵn (check GET `/vaccines`)

### 3. Error: "Center not found" (404)
❌ **Nguyên nhân:** `appointmentCenter` không tồn tại  
✅ **Giải pháp:** Dùng ID center có sẵn (check GET `/centers`)

### 4. Error: "Invalid time slot"
❌ **Nguyên nhân:** `appointmentTime` không đúng format  
✅ **Giải pháp:** Dùng enum value như `SLOT_08_00`, `SLOT_14_00`, etc.

### 5. Payment URL không chứa platform parameter
❌ **Nguyên nhân:** Backend chưa deploy code mới với platform detection  
✅ **Giải pháp:** Pull latest code và restart backend

---

## Test Flow Hoàn Chỉnh

### Bước 1: Login
```http
POST /auth/login
```
→ Lưu `accessToken`

### Bước 2: Get Available Data
```http
GET /vaccines         # Lấy danh sách vaccine
GET /centers          # Lấy danh sách trung tâm
GET /family-members   # Lấy danh sách thành viên gia đình (nếu cần)
```

### Bước 3: Create Booking
```http
POST /bookings
Authorization: Bearer {accessToken}
```
→ Nhận `paymentUrl`

### Bước 4: Test Payment
- Copy `paymentUrl` 
- Mở trong browser
- Login VNPay sandbox (nếu cần)
- Test thanh toán

### Bước 5: Verify Callback
Backend sẽ nhận callback từ VNPay tại:
```
GET /payments/vnpay/return?vnp_ResponseCode=00&vnp_TxnRef=...&payment=xxx&type=APPOINTMENT&referenceId=xxx&platform=web
```

**Success Response:** Redirect về frontend URL hoặc deep link

---

## VNPay Sandbox Test Cards

Khi test trên VNPay sandbox, dùng thẻ test sau:

**Ngân hàng:** NCB  
**Số thẻ:** `9704198526191432198`  
**Tên chủ thẻ:** `NGUYEN VAN A`  
**Ngày phát hành:** `07/15`  
**Mật khẩu OTP:** `123456`

---

## Next Steps

Sau khi test thành công:
1. ✅ Verify booking được tạo trong DB
2. ✅ Verify payment record được tạo
3. ✅ Test callback handler
4. ✅ Test frontend integration
5. ✅ Test mobile app deep link redirect

---

## Support

Nếu gặp vấn đề, kiểm tra:
- ✅ Backend logs: Check console output
- ✅ Database: Verify bookings/payments tables
- ✅ VNPay config: Check application.properties
- ✅ Network: Ensure backend is running on correct port
