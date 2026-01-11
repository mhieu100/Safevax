# 🔐 Hướng dẫn lấy Access Token

## Cách 1: Sử dụng file news.http (REST Client Extension)

### Bước 1: Mở file news.http
```
backend/test/news.http
```

### Bước 2: Gọi API Login
Tìm đến request đầu tiên:
```http
### 0. Login to get Access Token
POST http://localhost:8080/auth/login
Content-Type: application/json

{
  "username": "admin@safevax.com",
  "password": "admin123"
}
```

Click **"Send Request"**

### Bước 3: Copy Access Token từ Response
Response sẽ có dạng:
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "...",
  "user": {
    "id": 1,
    "username": "admin@safevax.com"
  }
}
```

**Copy giá trị của `access_token`**

### Bước 4: Paste vào biến @accessToken
Tìm đến dòng 9 trong file news.http:
```http
@accessToken = YOUR_ACCESS_TOKEN_HERE
```

Thay `YOUR_ACCESS_TOKEN_HERE` bằng token vừa copy:
```http
@accessToken = eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Bước 5: Test API với Token
Bây giờ bạn có thể gọi các API ADMIN:
- Create News (Request #31-35)
- Update News (Request #36-37)
- Publish/Unpublish (Request #38-40)
- Delete News (Request #41-42)

---

## Cách 2: Sử dụng cURL

### Bước 1: Login
```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin@safevax.com",
    "password": "admin123"
  }'
```

### Bước 2: Copy access_token từ output

### Bước 3: Sử dụng token trong request
```bash
TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."

curl -X POST http://localhost:8080/news \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Test News",
    "content": "Content",
    "category": "HEALTH_GENERAL"
  }'
```

---

## Cách 3: Sử dụng Postman

### Bước 1: Import Collection
Import file: `News_API.postman_collection.json`

### Bước 2: Tạo request Login mới
```
POST http://localhost:8080/auth/login
Body (JSON):
{
  "username": "admin@safevax.com",
  "password": "admin123"
}
```

### Bước 3: Copy token từ Response

### Bước 4: Tạo Collection Variable
1. Click vào Collection "News API"
2. Tab "Variables"
3. Thêm variable:
   - Key: `accessToken`
   - Value: [paste token vào đây]

### Bước 5: Sử dụng trong requests
Thêm vào Headers:
```
Authorization: Bearer {{accessToken}}
```

---

## 📋 Thông tin tài khoản mặc định

### Admin Account
```
Username: admin@safevax.com
Password: admin123
Role: ADMIN
```

### Staff Account (nếu có)
```
Username: staff@safevax.com
Password: staff123
Role: STAFF
```

### User Account (nếu có)
```
Username: user@safevax.com
Password: user123
Role: USER
```

---

## ⚠️ Lưu ý quan trọng

1. **Token có thời hạn**: Thường là 1-24 giờ. Hết hạn cần login lại để lấy token mới.

2. **Token format**: Luôn thêm prefix `Bearer ` trước token:
   ```
   Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

3. **Endpoints không cần token** (Public):
   - GET /news
   - GET /news/published
   - GET /news/featured
   - GET /news/slug/{slug}
   - GET /news/{id}
   - GET /news/category/{category}
   - GET /news/categories

4. **Endpoints cần token** (Admin):
   - POST /news
   - PUT /news/{id}
   - DELETE /news/{id}
   - PATCH /news/{id}/publish
   - PATCH /news/{id}/unpublish

---

## 🔍 Kiểm tra Token có hợp lệ không?

### Cách 1: Test API
Gọi một API ADMIN với token:
```bash
curl -X POST http://localhost:8080/news \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Test"}'
```

- **401 Unauthorized** → Token hết hạn hoặc sai
- **200/201** → Token hợp lệ

### Cách 2: Decode JWT Token
Vào trang: https://jwt.io/
Paste token vào → Xem thông tin và thời gian hết hạn

---

## 🐛 Troubleshooting

### Lỗi: 401 Unauthorized
- Token hết hạn → Login lại
- Token sai format → Kiểm tra có prefix "Bearer "
- Chưa login → Gọi API login trước

### Lỗi: 403 Forbidden
- Tài khoản không có quyền ADMIN
- Cần login bằng tài khoản admin

### Lỗi: Invalid credentials
- Sai username/password
- Kiểm tra lại thông tin đăng nhập

---

## 💡 Tips

1. **Save token vào file**: Tạo file `.env` hoặc `token.txt` để lưu token
2. **Auto refresh**: Sử dụng refresh_token để lấy access_token mới
3. **Postman Environment**: Lưu token vào environment variable để dùng chung

---

**Happy Testing! 🚀**
