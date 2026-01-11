# Google OAuth Login Flow Documentation

## Overview
Google OAuth login cho phép người dùng đăng nhập nhanh chóng với tài khoản Google, nhưng vẫn thu thập đầy đủ thông tin bệnh nhân như đăng ký bằng mật khẩu.

## Flow Diagram

```
User clicks "Login with Google"
         ↓
Frontend gets Google ID Token
         ↓
POST /auth/login/google {googleToken}
         ↓
Backend validates Google token
         ↓
   Is existing user?
   ↙           ↘
YES              NO
 ↓               ↓
Has profile?   Create basic user
 ↓              (email, name, avatar)
YES / NO        ↓
 ↓              Return: isProfileComplete = false
Return token    ↓
with profile    Frontend redirects to
status          /complete-profile page
                ↓
              User fills patient info
              (phone, address, birthday, etc.)
                ↓
              POST /auth/complete-google-profile
                ↓
              Save complete profile
                ↓
              Return full user + token
                ↓
              Login complete!
```

## API Endpoints

### 1. Login with Google
**POST** `/auth/login/google`

**Request Body:**
```json
{
  "googleToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI3M..."
}
```

**Response (New User - Profile Incomplete):**
```json
{
  "statusCode": 200,
  "message": "Login with Google",
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "isProfileComplete": false,
    "user": {
      "id": 123,
      "email": "user@gmail.com",
      "fullName": "Nguyen Van A",
      "avatar": "https://lh3.googleusercontent.com/...",
      "role": "PATIENT"
    }
  }
}
```

**Response (Existing User - Profile Complete):**
```json
{
  "statusCode": 200,
  "message": "Login with Google",
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "isProfileComplete": true,
    "user": {
      "id": 123,
      "email": "user@gmail.com",
      "fullName": "Nguyen Van A",
      "avatar": "https://lh3.googleusercontent.com/...",
      "role": "PATIENT",
      "phone": "0912345678",
      "address": "123 Nguyen Hue, Q1, HCM",
      "birthday": "1990-01-01T00:00:00.000Z",
      "gender": "MALE",
      "identityNumber": "001090001234",
      "bloodType": "O_POSITIVE",
      "heightCm": 175.0,
      "weightKg": 70.0,
      "occupation": "Software Engineer",
      "lifestyleNotes": "Active lifestyle",
      "insuranceNumber": "INS123456",
      "consentForAIAnalysis": true
    }
  }
}
```

### 2. Complete Google Profile
**POST** `/auth/complete-google-profile`

**Authentication:** Required (Bearer token from Google login response)

**Request Body:**
```json
{
  "patientProfile": {
    "phone": "0912345678",
    "address": "123 Nguyen Hue, District 1, Ho Chi Minh City",
    "birthday": "1990-01-01",
    "gender": "MALE",
    "identityNumber": "001090001234",
    "bloodType": "O_POSITIVE",
    "heightCm": 175.0,
    "weightKg": 70.0,
    "occupation": "Software Engineer",
    "lifestyleNotes": "Regular exercise, no smoking",
    "insuranceNumber": "INS123456",
    "consentForAIAnalysis": true
  }
}
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Complete Google profile with patient information",
  "data": {
    "id": 123,
    "email": "user@gmail.com",
    "fullName": "Nguyen Van A",
    "avatar": "https://lh3.googleusercontent.com/...",
    "role": "PATIENT",
    "phone": "0912345678",
    "address": "123 Nguyen Hue, District 1, Ho Chi Minh City",
    "birthday": "1990-01-01T00:00:00.000Z",
    "gender": "MALE",
    "identityNumber": "001090001234",
    "bloodType": "O_POSITIVE",
    "heightCm": 175.0,
    "weightKg": 70.0,
    "occupation": "Software Engineer",
    "lifestyleNotes": "Regular exercise, no smoking",
    "insuranceNumber": "INS123456",
    "consentForAIAnalysis": true
  }
}
```

## Frontend Implementation Steps

### 1. Setup Google OAuth
```bash
npm install @react-oauth/google
```

### 2. Configure Google Provider in App.jsx
```jsx
import { GoogleOAuthProvider } from '@react-oauth/google';

function App() {
  return (
    <GoogleOAuthProvider clientId="YOUR_GOOGLE_CLIENT_ID">
      {/* Your app components */}
    </GoogleOAuthProvider>
  );
}
```

### 3. Create Google Login Button
```jsx
import { useGoogleLogin } from '@react-oauth/google';
import { loginWithGoogle } from '@/services/auth.service';

function LoginPage() {
  const handleGoogleLogin = useGoogleLogin({
    onSuccess: async (tokenResponse) => {
      try {
        const response = await loginWithGoogle(tokenResponse.access_token);
        
        if (!response.isProfileComplete) {
          // Redirect to profile completion page
          navigate('/complete-profile', { 
            state: { 
              accessToken: response.accessToken,
              user: response.user 
            } 
          });
        } else {
          // Login complete, save token and redirect to dashboard
          localStorage.setItem('accessToken', response.accessToken);
          navigate('/dashboard');
        }
      } catch (error) {
        console.error('Google login failed:', error);
      }
    },
    onError: () => {
      console.error('Google login failed');
    },
  });

  return (
    <button onClick={handleGoogleLogin}>
      Login with Google
    </button>
  );
}
```

### 4. Create Profile Completion Page
```jsx
import { useLocation, useNavigate } from 'react-router-dom';
import { completeGoogleProfile } from '@/services/auth.service';

function CompleteProfilePage() {
  const location = useLocation();
  const navigate = useNavigate();
  const { accessToken, user } = location.state;
  
  const handleSubmit = async (formData) => {
    try {
      // Set token for authenticated request
      const response = await completeGoogleProfile(formData, accessToken);
      
      // Save token and redirect
      localStorage.setItem('accessToken', accessToken);
      navigate('/dashboard');
    } catch (error) {
      console.error('Profile completion failed:', error);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form fields matching CompleteGoogleProfileRequest */}
      <input name="phone" required />
      <input name="address" required />
      <input name="birthday" type="date" required />
      <select name="gender" required>
        <option value="MALE">Male</option>
        <option value="FEMALE">Female</option>
        <option value="OTHER">Other</option>
      </select>
      <input name="identityNumber" required />
      <select name="bloodType" required>
        <option value="O_POSITIVE">O+</option>
        <option value="O_NEGATIVE">O-</option>
        <option value="A_POSITIVE">A+</option>
        <option value="A_NEGATIVE">A-</option>
        <option value="B_POSITIVE">B+</option>
        <option value="B_NEGATIVE">B-</option>
        <option value="AB_POSITIVE">AB+</option>
        <option value="AB_NEGATIVE">AB-</option>
      </select>
      <input name="heightCm" type="number" step="0.1" />
      <input name="weightKg" type="number" step="0.1" />
      <input name="occupation" />
      <textarea name="lifestyleNotes" />
      <input name="insuranceNumber" />
      <label>
        <input 
          name="consentForAIAnalysis" 
          type="checkbox" 
        />
        I consent to AI analysis of my health data
      </label>
      <button type="submit">Complete Profile</button>
    </form>
  );
}
```

### 5. Auth Service Methods
```javascript
// src/services/auth.service.js

export const loginWithGoogle = async (googleToken) => {
  const response = await apiClient.post('/auth/login/google', {
    googleToken
  });
  return response.data;
};

export const completeGoogleProfile = async (profileData, token) => {
  const response = await apiClient.post(
    '/auth/complete-google-profile',
    {
      patientProfile: {
        phone: profileData.phone,
        address: profileData.address,
        birthday: profileData.birthday,
        gender: profileData.gender,
        identityNumber: profileData.identityNumber,
        bloodType: profileData.bloodType,
        heightCm: profileData.heightCm ? parseFloat(profileData.heightCm) : null,
        weightKg: profileData.weightKg ? parseFloat(profileData.weightKg) : null,
        occupation: profileData.occupation || null,
        lifestyleNotes: profileData.lifestyleNotes || null,
        insuranceNumber: profileData.insuranceNumber || null,
        consentForAIAnalysis: profileData.consentForAIAnalysis || false
      }
    },
    {
      headers: {
        Authorization: `Bearer ${token}`
      }
    }
  );
  return response.data;
};
```

## Backend Configuration

### 1. Environment Variables
Add to `.env` file:
```env
GOOGLE_CLIENT_ID=your_google_client_id_from_console.developers.google.com
```

### 2. Get Google Client ID
1. Go to [Google Cloud Console](https://console.developers.google.com/)
2. Create a new project or select existing project
3. Enable "Google+ API"
4. Go to "Credentials" → "Create Credentials" → "OAuth 2.0 Client ID"
5. Configure OAuth consent screen
6. Set Authorized JavaScript origins: `http://localhost:5173`, `https://yourdomain.com`
7. Set Authorized redirect URIs: `http://localhost:5173/auth/callback`, `https://yourdomain.com/auth/callback`
8. Copy the Client ID

## Data Validation

### Required Fields for Profile Completion
- `phone` - String, not blank
- `address` - String, not blank
- `birthday` - LocalDate, not null
- `gender` - Enum (MALE, FEMALE, OTHER), not null
- `identityNumber` - String, not blank, unique
- `bloodType` - Enum (O_POSITIVE, O_NEGATIVE, etc.), not null

### Optional Fields
- `heightCm` - Double
- `weightKg` - Double
- `occupation` - String
- `lifestyleNotes` - String
- `insuranceNumber` - String
- `consentForAIAnalysis` - Boolean (default false)

## Error Handling

### Common Errors

**Invalid Google Token**
```json
{
  "statusCode": 400,
  "message": "Invalid Google token"
}
```

**Email Already Exists (with password account)**
```json
{
  "statusCode": 400,
  "message": "Email already exists"
}
```

**Identity Number Already Exists**
```json
{
  "statusCode": 400,
  "message": "Identity number already exists"
}
```

**Profile Already Completed**
```json
{
  "statusCode": 400,
  "message": "Profile already completed"
}
```

## Security Considerations

1. **Token Validation**: Backend validates Google ID token với Google's public keys
2. **HTTPS Only**: Production phải dùng HTTPS cho Google OAuth
3. **Refresh Tokens**: Google login cũng tạo refresh token trong HTTP-only cookie
4. **Rate Limiting**: Implement rate limiting cho Google login endpoint
5. **Identity Number Uniqueness**: Kiểm tra trùng lặp CMND/CCCD khi hoàn thiện profile

## Testing

### Test Google Login (New User)
```bash
curl -X POST http://localhost:8080/auth/login/google \
  -H "Content-Type: application/json" \
  -d '{
    "googleToken": "VALID_GOOGLE_ID_TOKEN"
  }'
```

### Test Complete Profile
```bash
curl -X POST http://localhost:8080/auth/complete-google-profile \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "patientProfile": {
      "phone": "0912345678",
      "address": "123 Nguyen Hue, Q1, HCM",
      "birthday": "1990-01-01",
      "gender": "MALE",
      "identityNumber": "001090001234",
      "bloodType": "O_POSITIVE",
      "consentForAIAnalysis": true
    }
  }'
```

## Migration Guide

Nếu có user đã đăng ký bằng email/password muốn link với Google:
1. User login bằng password
2. Frontend call Google login
3. Backend check email trùng
4. Merge accounts hoặc báo lỗi

*Note: Feature này cần implement riêng nếu cần thiết.*
