# Registration Flow Update - Two-Phase Registration

## Tổng quan thay đổi

Đã chỉnh sửa flow đăng ký để tách làm 2 giai đoạn:
1. **Đăng ký ban đầu**: Chỉ cần email, password, fullName
2. **Hoàn thiện profile**: Bổ sung đầy đủ thông tin bệnh nhân

## Các thay đổi chính

### Backend Changes

#### 1. User Model (`User.java`)
```java
// Thêm trường isActive
boolean isActive = false; // Mặc định là false khi tạo tài khoản
```

#### 2. RegisterPatientRequest (`RegisterPatientRequest.java`)
- **Loại bỏ** `@NotNull`, `@NotBlank` khỏi các trường trong `PatientProfileRequest`
- Cho phép đăng ký mà không cần thông tin patient profile

#### 3. AuthService (`AuthService.java`)
**Phương thức `register()`:**
- Tạo User với `isActive = false`
- **KHÔNG** tạo Patient profile
- Trả về RegisterPatientResponse đơn giản (không có patientProfile)

**Phương thức `loginWithGoogle()`:**
- Tạo User mới với `isActive = false`
- **KHÔNG** tạo Patient profile ngay lập tức

**Phương thức mới `completeProfile()`:**
- Dùng chung cho cả đăng ký password và Google
- Kiểm tra profile chưa hoàn thiện
- Kiểm tra identityNumber unique
- Tạo Patient profile với đầy đủ validation
- Set `user.isActive = true` sau khi hoàn thiện

**Phương thức `completeGoogleProfile()`:**
- Giữ lại để backward compatibility
- Logic tương tự `completeProfile()`

#### 4. AuthController (`AuthController.java`)
**Endpoint mới:**
```java
POST /auth/complete-profile
- Body: CompleteProfileRequest
- Requires: JWT authentication
- Returns: UserLogin với refresh token cookie
```

#### 5. Security Configuration (`SecurityConfiguration.java`)
**Whitelist cập nhật:**
```java
"/auth/complete-profile"  // Cho phép hoàn thiện profile
"/auth/complete-google-profile"  // Cho phép hoàn thiện Google profile
```

#### 6. Database Migration (`V7__add_is_active_to_users.sql`)
```sql
ALTER TABLE users ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT FALSE;
UPDATE users SET is_active = TRUE WHERE patient_profile EXISTS;
```

#### 7. DTO mới: `CompleteProfileRequest.java`
- Validation đầy đủ cho tất cả các trường bắt buộc:
  - address (required)
  - phone (required, 9-11 digits)
  - birthday (required, past date)
  - gender (required)
  - identityNumber (required, 9-12 digits)
  - bloodType (required)
  - heightCm (optional, positive)
  - weightKg (optional, positive)
  - occupation (optional)
  - lifestyleNotes (optional)
  - insuranceNumber (optional)
  - consentForAIAnalysis (optional, default false)

### Frontend Changes

#### 1. Register Page (`register.jsx`)
**Thay đổi:**
- Loại bỏ TẤT CẢ các trường patient profile
- Chỉ giữ lại: fullName, email, password, confirmPassword
- Bỏ agreement checkbox
- Message: "Registration successful! Please login and complete your profile."
- Redirect về `/login` sau khi đăng ký thành công

**UI đơn giản hơn:**
```jsx
- Full Name
- Email
- Password
- Confirm Password
- [Create Account Button]
- [Sign up with Google]
```

#### 2. Login Page (`login.jsx`)
**Thêm kiểm tra profile:**
```javascript
// Sau khi login thành công
if (!userData.phone || !userData.address) {
  message.info('Please complete your profile to continue');
  navigate('/complete-profile');
  return;
}
```

#### 3. Complete Profile Page (`CompleteProfilePage.jsx`)
**Cập nhật:**
- Sử dụng API `/auth/complete-profile` thay vì `/auth/complete-google-profile`
- Dùng chung cho cả password và Google registration
- Blood type options: A, B, AB, O (không có +/-)
- Full validation cho tất cả trường bắt buộc

#### 4. Auth Service (`auth.service.js`)
**Phương thức mới:**
```javascript
callCompleteProfile(payload) // Unified API cho hoàn thiện profile
```

## Flow người dùng

### Flow đăng ký bằng Password:

1. **Register Page** → Nhập: fullName, email, password
2. Click "Create Account"
3. Backend tạo User với `isActive = false`, **KHÔNG có** Patient profile
4. Redirect về **Login Page**
5. User đăng nhập
6. Backend check: không có phone/address → redirect **Complete Profile**
7. **Complete Profile Page** → Nhập đầy đủ thông tin:
   - address*, phone*, birthday*, gender*
   - identityNumber*, bloodType*
   - heightCm, weightKg, occupation, insurance, etc.
8. Submit → Backend tạo Patient profile + set `isActive = true`
9. Redirect về homepage với tài khoản đã kích hoạt

### Flow đăng ký bằng Google:

1. Click "Sign in with Google"
2. Google authentication
3. Backend tạo User với `isActive = false`, **KHÔNG có** Patient profile
4. Check `isProfileComplete = false` → redirect **Complete Profile**
5. **Complete Profile Page** → Nhập đầy đủ thông tin (giống password flow)
6. Submit → Backend tạo Patient profile + set `isActive = true`
7. Redirect về homepage với tài khoản đã kích hoạt

## Validation Rules

### Required Fields (Complete Profile):
- ✅ Address
- ✅ Phone (9-11 digits)
- ✅ Birthday (must be past date)
- ✅ Gender (MALE/FEMALE/OTHER)
- ✅ Identity Number (9-12 digits)
- ✅ Blood Type (A/B/AB/O)

### Optional Fields:
- Height (cm) - must be positive if provided
- Weight (kg) - must be positive if provided
- Occupation
- Lifestyle Notes
- Insurance Number
- Consent for AI Analysis (default: false)

## Testing Checklist

### Backend:
- [ ] Đăng ký password: User được tạo với `isActive = false`
- [ ] Đăng ký Google: User được tạo với `isActive = false`
- [ ] Complete profile: Patient profile được tạo + `isActive = true`
- [ ] Login với profile chưa hoàn thiện: trả về user với phone/address = null
- [ ] Database migration chạy thành công
- [ ] Validation errors trả về đúng cho missing fields

### Frontend:
- [ ] Register form chỉ có 4 fields
- [ ] Đăng ký thành công → redirect login
- [ ] Login với profile chưa hoàn thiện → redirect complete-profile
- [ ] Complete profile form có đầy đủ validation
- [ ] Submit complete profile thành công → redirect homepage
- [ ] Google OAuth flow hoạt động đúng
- [ ] Blood type dropdown có 4 options: A, B, AB, O

## API Endpoints

### Đăng ký
```
POST /auth/register
Body: {
  user: { fullName, email, password },
  patientProfile: {} // Empty
}
Response: { id, avatar, fullName, email, role, isActive: false }
```

### Login
```
POST /auth/login/password
Body: { username, password }
Response: {
  accessToken,
  user: { ... } // phone, address = null if not completed
}
```

### Complete Profile
```
POST /auth/complete-profile
Headers: Authorization: Bearer <token>
Body: {
  patientProfile: {
    address*, phone*, birthday*, gender*,
    identityNumber*, bloodType*,
    heightCm, weightKg, occupation, etc.
  }
}
Response: { id, fullName, email, phone, address, ... }
+ Set-Cookie: refresh_token
```

## Breaking Changes

⚠️ **IMPORTANT**: Existing users cần migrate:
- Migration tự động set `isActive = true` cho users có patient profile
- Frontend sẽ redirect users chưa có profile về complete-profile page

## Notes

- `isActive` field được thêm với default = false
- Users cũ tự động được set `isActive = true` nếu có patient profile
- Security endpoints `/auth/complete-profile` và `/auth/complete-google-profile` được thêm vào whitelist
- RegisterPatientResponse không còn field `patientProfile`, thay bằng `isActive`
