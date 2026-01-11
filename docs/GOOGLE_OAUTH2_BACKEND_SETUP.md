# Google OAuth2 Backend Configuration Guide

## Tổng quan
Project đã được chuyển từ frontend OAuth2 flow (sử dụng @react-oauth/google) sang **backend OAuth2 flow** hoàn toàn xử lý ở Spring Boot backend.

## Cấu hình Google Cloud Console

### 1. Truy cập Google Cloud Console
- URL: https://console.cloud.google.com/
- Chọn project hoặc tạo project mới

### 2. Cấu hình OAuth 2.0 Client ID

#### A. Tạo/Chỉnh sửa OAuth Client ID
1. Vào **APIs & Services** → **Credentials**
2. Tìm OAuth 2.0 Client ID hoặc tạo mới
3. Application type: **Web application**

#### B. Authorized JavaScript origins
**XÓA** các origins frontend (không cần nữa):
- ~~http://localhost:5173~~
- ~~http://localhost:3000~~

**THÊM** backend origins:
```
http://localhost:8080
```

#### C. Authorized redirect URIs
**QUAN TRỌNG** - Chỉ cần URI này:
```
http://localhost:8080/login/oauth2/code/google
```

**Lưu ý:** URI phải khớp chính xác, không có trailing slash!

### 3. Lưu Client ID và Client Secret
- Copy **Client ID** và **Client Secret**
- Thêm vào file `.env` backend

---

## Backend Configuration

### File: `backend/.env`
```env
GOOGLE_CLIENT_ID=your-client-id-here.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret-here
CORS_ALLOWED_ORIGINS=http://localhost:5173
```

### File: `application.properties`
Đã được cấu hình sẵn:
```properties
# OAuth2 Configuration for Google
spring.security.oauth2.client.registration.google.client-id=${GOOGLE_CLIENT_ID}
spring.security.oauth2.client.registration.google.client-secret=${GOOGLE_CLIENT_SECRET}
spring.security.oauth2.client.registration.google.scope=profile,email
spring.security.oauth2.client.registration.google.redirect-uri=http://localhost:8080/login/oauth2/code/google
spring.security.oauth2.client.registration.google.client-name=Google

spring.security.oauth2.client.provider.google.authorization-uri=https://accounts.google.com/o/oauth2/v2/auth
spring.security.oauth2.client.provider.google.token-uri=https://oauth2.googleapis.com/token
spring.security.oauth2.client.provider.google.user-info-uri=https://www.googleapis.com/oauth2/v3/userinfo
spring.security.oauth2.client.provider.google.user-name-attribute=sub
```

---

## Frontend Configuration

### File: `frontend/.env`
```env
VITE_BACKEND_URL=http://localhost:8080
```

**Lưu ý:** Không cần `VITE_GOOGLE_CLIENT_ID` nữa vì OAuth2 xử lý hoàn toàn ở backend.

---

## OAuth2 Flow

### 1. User clicks "Login with Google"
```
Frontend: Click button
↓
Redirect: http://localhost:8080/oauth2/authorization/google
```

### 2. Backend redirects to Google
```
Backend → Google Authorization
User logs in with Google account
```

### 3. Google redirects back to backend
```
Google → http://localhost:8080/login/oauth2/code/google
Backend processes OAuth2 code
```

### 4. Backend creates/updates user and generates JWT
```
Backend:
- Check if user exists (by email)
- If new: Create user with isActive=false
- If exists: Update last login
- Generate JWT access token
- Generate refresh token (HTTP-only cookie)
```

### 5. Backend redirects to frontend with token
```
Backend → http://localhost:5173/oauth2/callback?token=xxx&email=xxx&...
```

### 6. Frontend processes callback
```
Frontend OAuth2Callback.jsx:
- Extract token from URL params
- Store token in localStorage
- Update user store
- Check if profile complete
- Navigate to appropriate page
```

---

## Files Modified/Created

### Backend Files

#### Created:
1. **`OAuth2LoginSuccessHandler.java`**
   - Xử lý sau khi OAuth2 thành công
   - Tạo/update user
   - Generate JWT tokens
   - Redirect về frontend với token

#### Modified:
1. **`SecurityConfiguration.java`**
   - Thêm `.oauth2Login()` configuration
   - Whitelist `/oauth2/**` và `/login/oauth2/**`
   - Inject `OAuth2LoginSuccessHandler`

2. **`application.properties`**
   - Thêm Spring Security OAuth2 client configuration
   - Cấu hình Google provider

### Frontend Files

#### Created:
1. **`OAuth2Callback.jsx`**
   - Page xử lý callback từ backend
   - Extract token và user info từ URL params
   - Store token và navigate

#### Modified:
1. **`login.jsx`**
   - Xóa `GoogleLogin` component
   - Thêm button redirect đến backend OAuth2 endpoint
   - Xóa `handleGoogleSuccess/Error` handlers

2. **`register.jsx`**
   - Xóa `GoogleLogin` component
   - Thêm button redirect đến backend OAuth2 endpoint
   - Xóa `handleGoogleSuccess/Error` handlers

3. **`App.jsx`**
   - Xóa `GoogleOAuthProvider` wrapper
   - Không cần frontend Google OAuth library nữa

4. **`routes.jsx`**
   - Thêm route `/oauth2/callback`

---

## Testing Flow

### 1. Start Backend
```bash
cd backend
mvn spring-boot:run
```

### 2. Start Frontend
```bash
cd frontend
npm run dev
```

### 3. Test Login
1. Vào http://localhost:5173/login
2. Click "Sign in with Google"
3. Browser redirect đến Google login
4. Sau khi login Google, redirect về backend
5. Backend xử lý và redirect về frontend callback
6. Frontend xử lý token và navigate

### 4. Kiểm tra
- Token được lưu trong localStorage
- User info trong Zustand store
- Redirect đúng based on profile status
- Refresh token cookie được set

---

## Troubleshooting

### Lỗi: "redirect_uri_mismatch"
**Nguyên nhân:** URI trong Google Cloud Console không khớp

**Giải pháp:**
- Đảm bảo URI chính xác: `http://localhost:8080/login/oauth2/code/google`
- Không có trailing slash
- Protocol phải là `http://` (hoặc `https://` cho production)

### Lỗi: "invalid_client"
**Nguyên nhân:** Client ID hoặc Client Secret sai

**Giải pháp:**
- Kiểm tra `.env` backend
- Đảm bảo GOOGLE_CLIENT_ID và GOOGLE_CLIENT_SECRET đúng

### Lỗi: CORS
**Nguyên nhân:** Frontend URL chưa được whitelist

**Giải pháp:**
- Thêm frontend URL vào `CORS_ALLOWED_ORIGINS` trong backend `.env`

### Token không được set
**Nguyên nhân:** Callback URL params bị mất

**Giải pháp:**
- Kiểm tra `OAuth2LoginSuccessHandler` có redirect đúng URL
- Kiểm tra `OAuth2Callback.jsx` extract params đúng

---

## Production Configuration

### Google Cloud Console
**Authorized redirect URIs:**
```
https://yourdomain.com/login/oauth2/code/google
```

### Backend `.env`
```env
GOOGLE_CLIENT_ID=your-production-client-id
GOOGLE_CLIENT_SECRET=your-production-client-secret
CORS_ALLOWED_ORIGINS=https://yourfrontend.com
```

### Frontend `.env`
```env
VITE_BACKEND_URL=https://api.yourdomain.com
```

### Security Enhancements
1. Set `refreshTokenCookie.setSecure(true)` trong `OAuth2LoginSuccessHandler`
2. Use HTTPS cho tất cả endpoints
3. Configure proper CORS policies
4. Use environment-specific client credentials

---

## Dependencies

### Backend (đã có sẵn)
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

### Frontend
**Có thể xóa (không cần nữa):**
- `@react-oauth/google`

---

## Benefits of Backend OAuth2 Flow

✅ **Security**: Client Secret không expose ra frontend
✅ **Simplicity**: Không cần Google OAuth library ở frontend
✅ **Control**: Backend kiểm soát hoàn toàn authentication flow
✅ **Consistency**: Tất cả auth logic tập trung ở backend
✅ **Token Management**: Refresh token được lưu securely (HTTP-only cookie)

---

## Summary

**Trước:**
- Frontend sử dụng `@react-oauth/google`
- Frontend gửi id_token đến backend
- Backend validate token với Google API

**Sau:**
- Frontend chỉ redirect đến backend OAuth2 endpoint
- Backend xử lý toàn bộ OAuth2 flow với Google
- Backend trả JWT token về frontend qua callback URL

**URL duy nhất cần config trong Google Cloud Console:**
```
http://localhost:8080/login/oauth2/code/google
```
