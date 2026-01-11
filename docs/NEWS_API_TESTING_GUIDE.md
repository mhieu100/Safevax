# 📰 News API Testing Guide

## 🚀 Hướng dẫn Test API Tin tức

### 1️⃣ Chuẩn bị

1. **Start Backend Server**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **Import Postman Collection**
   - Mở Postman
   - Import file: `News_API.postman_collection.json`

3. **Kiểm tra Database đã chạy migration**
   - Server sẽ tự động chạy Flyway migration khi start
   - Kiểm tra log: `Flyway: Successfully applied 2 migrations`

---

## 📊 Dữ liệu mẫu đã có

Sau khi migration V6 chạy, bạn sẽ có **13 bài viết tin tức** mẫu với các danh mục:

| Category | Số bài | Ví dụ |
|----------|--------|-------|
| HEALTH_GENERAL | 2 | 10 thói quen tốt cho sức khỏe |
| VACCINE_INFO | 2 | Lợi ích của Vaccine COVID-19 |
| VACCINATION_SCHEDULE | 1 | Lịch tiêm chủng cho trẻ em |
| DISEASE_PREVENTION | 1 | Phòng ngừa bệnh cúm mùa |
| CHILDREN_HEALTH | 1 | Dinh dưỡng cho trẻ dưới 5 tuổi |
| NUTRITION | 1 | Top 15 thực phẩm tăng miễn dịch |
| WOMEN_HEALTH | 1 | Chăm sóc phụ nữ mang thai |
| MEDICAL_RESEARCH | 1 | Vaccine mRNA - Công nghệ tương lai |
| HEALTH_TIPS | 1 | 5 bài tập yoga giảm stress |
| SEASONAL_DISEASES | 1 | Phòng chống sốt xuất huyết mùa mưa |
| ELDERLY_CARE | 1 | Chăm sóc người cao tuổi |
| COVID_19 | 1 | Hội chứng hậu COVID-19 |

**Lưu ý:** Có 1 bài viết nháp (chưa publish) để test chức năng publish/unpublish.

---

## 🧪 Test Cases

### ✅ Test 1: Get All News (Có phân trang)

**Endpoint:** `GET /news?page=0&size=10&sort=publishedAt,desc`

**Expected Result:**
```json
{
  "meta": {
    "page": 1,
    "pageSize": 10,
    "pages": 2,
    "total": 13
  },
  "result": [
    {
      "id": 1,
      "slug": "10-thoi-quen-tot-cho-suc-khoe",
      "title": "10 Thói quen tốt cho sức khỏe mỗi ngày",
      "category": "HEALTH_GENERAL",
      "viewCount": 150,
      "isFeatured": true,
      "isPublished": true,
      ...
    }
  ]
}
```

---

### ✅ Test 2: Get Featured News

**Endpoint:** `GET /news/featured`

**Expected:** Chỉ trả về các bài featured (7 bài):
- 10 thói quen tốt cho sức khỏe
- Lợi ích của Vaccine COVID-19
- Lịch tiêm chủng cho trẻ em
- Dinh dưỡng cho trẻ dưới 5 tuổi
- Top 15 thực phẩm tăng miễn dịch
- 5 bài tập yoga giảm stress
- Hội chứng hậu COVID-19

---

### ✅ Test 3: Get Published News

**Endpoint:** `GET /news/published`

**Expected:** Trả về 12 bài (không bao gồm bài nháp)

---

### ✅ Test 4: Get News by Slug (Tăng view count)

**Endpoint:** `GET /news/slug/loi-ich-cua-vaccine-covid-19`

**Test Steps:**
1. Gọi API lần 1 - Check `viewCount: 320`
2. Gọi API lần 2 - Check `viewCount: 321` ✅
3. Gọi API lần 3 - Check `viewCount: 322` ✅

**Expected:** Mỗi lần gọi, viewCount tăng thêm 1

---

### ✅ Test 5: Filter by Category

**Endpoint:** `GET /news?filter=category:'VACCINE_INFO'`

**Expected:** Trả về 2 bài viết:
- Lợi ích của Vaccine COVID-19
- Lịch tiêm chủng cho trẻ em

---

### ✅ Test 6: Search by Title

**Endpoint:** `GET /news?filter=title~'*vaccine*'`

**Expected:** Trả về các bài có "vaccine" trong title:
- Lợi ích của Vaccine COVID-19
- Lịch tiêm chủng cho trẻ em
- Vaccine mRNA - Công nghệ tương lai

---

### ✅ Test 7: Complex Filter (Category + Published)

**Endpoint:** `GET /news?filter=category:'VACCINE_INFO' and isPublished:true`

**Expected:** Chỉ bài vaccine đã publish

---

### ✅ Test 8: Get News by Category Endpoint

**Endpoint:** `GET /news/category/CHILDREN_HEALTH`

**Expected:** Trả về 1 bài: "Dinh dưỡng cho trẻ dưới 5 tuổi"

---

### ✅ Test 9: Get All Categories

**Endpoint:** `GET /news/categories`

**Expected:**
```json
[
  "HEALTH_GENERAL",
  "VACCINE_INFO",
  "VACCINATION_SCHEDULE",
  "DISEASE_PREVENTION",
  "CHILDREN_HEALTH",
  "NUTRITION",
  "WOMEN_HEALTH",
  "MEDICAL_RESEARCH",
  "HEALTH_TIPS",
  "SEASONAL_DISEASES",
  "ELDERLY_CARE",
  "COVID_19"
]
```

---

### ✅ Test 10: Create News (Auto-generate Slug)

**Endpoint:** `POST /news`

**Request Body:**
```json
{
  "title": "Vaccine HPV - Bảo vệ sức khỏe phụ nữ",
  "shortDescription": "Vaccine HPV giúp phòng ngừa ung thư cổ tử cung",
  "content": "<h2>Vaccine HPV</h2><p>Nội dung...</p>",
  "category": "VACCINE_INFO",
  "author": "BS. Nguyễn Thị Hoa",
  "isFeatured": true,
  "isPublished": true,
  "tags": "hpv,vaccine,ung thư,phụ nữ",
  "source": "Bộ Y tế"
}
```

**Expected:**
- Status: `201 Created`
- Slug auto-generated: `vaccine-hpv-bao-ve-suc-khoe-phu-nu`
- `publishedAt` tự động set = current timestamp
- `viewCount` = 0
- Response chứa đầy đủ thông tin

---

### ✅ Test 11: Create News with Vietnamese Characters in Title

**Request:**
```json
{
  "title": "Phòng ngừa sốt xuất huyết dengue mùa mưa",
  "shortDescription": "Hướng dẫn chi tiết...",
  "content": "<p>Nội dung...</p>",
  "category": "SEASONAL_DISEASES",
  "author": "BS. Trần Văn Bình",
  "isPublished": false
}
```

**Expected:**
- Slug: `phong-ngua-sot-xuat-huyet-dengue-mua-mua`
- Vietnamese characters converted correctly
- `isPublished: false` → `publishedAt: null`

---

### ✅ Test 12: Update News

**Endpoint:** `PUT /news/1`

**Request Body:**
```json
{
  "title": "10 Thói quen tốt cho sức khỏe - Cập nhật 2024",
  "shortDescription": "Cập nhật mới nhất...",
  "content": "<h2>Nội dung mới</h2>",
  "category": "HEALTH_GENERAL",
  "author": "BS. Nguyễn Văn An",
  "isFeatured": true,
  "isPublished": true,
  "tags": "sức khỏe,thói quen,2024",
  "source": "Bộ Y tế"
}
```

**Expected:**
- Status: `200 OK`
- `updatedAt` được update
- Slug không đổi (nếu không truyền slug mới)

---

### ✅ Test 13: Publish News (Draft → Published)

**Endpoint:** `PATCH /news/13/publish`

**Test Steps:**
1. Get news ID 13 (bài nháp) - Check `isPublished: false`
2. Call PATCH `/news/13/publish`
3. Get news ID 13 again - Check:
   - `isPublished: true` ✅
   - `publishedAt: <timestamp>` ✅

---

### ✅ Test 14: Unpublish News

**Endpoint:** `PATCH /news/1/unpublish`

**Expected:**
- `isPublished: false`
- `publishedAt` không đổi (giữ nguyên thời gian publish trước đó)

---

### ✅ Test 15: Delete News (Soft Delete)

**Endpoint:** `DELETE /news/13`

**Test Steps:**
1. Delete news ID 13
2. Status: `204 No Content`
3. Try to get by ID: `GET /news/13` → `404 Not Found` hoặc error
4. Check database: `is_deleted = true`

---

### ✅ Test 16: Pagination

**Test Steps:**
1. `GET /news?page=0&size=5` → 5 bài đầu
2. `GET /news?page=1&size=5` → 5 bài tiếp theo
3. Check `meta.pages`, `meta.total`

---

### ✅ Test 17: Sorting

**Test Ascending:**
```
GET /news?sort=viewCount,asc
```
Expected: Bài có view thấp nhất lên đầu

**Test Descending:**
```
GET /news?sort=publishedAt,desc
```
Expected: Bài mới nhất lên đầu

---

## 🔍 Advanced Filter Examples

### Filter by Featured + Category
```
GET /news?filter=isFeatured:true and category:'VACCINE_INFO'
```

### Filter by View Count Range
```
GET /news?filter=viewCount>200 and viewCount<500
```

### Filter by Author
```
GET /news?filter=author~'*Nguyễn*'
```

### Filter by Tags
```
GET /news?filter=tags~'*covid*'
```

### Complex Query
```
GET /news?filter=(category:'VACCINE_INFO' or category:'COVID_19') and isPublished:true&sort=viewCount,desc&page=0&size=5
```

---

## ❌ Error Testing

### Test Invalid Category
**Request:**
```json
POST /news
{
  "title": "Test",
  "content": "Test",
  "category": "INVALID_CATEGORY"
}
```
**Expected:** `400 Bad Request` - Validation error

### Test Missing Required Fields
**Request:**
```json
POST /news
{
  "shortDescription": "Only description"
}
```
**Expected:** `400 Bad Request` - "Title is required", "Content is required", "Category is required"

### Test Get Non-existent News
**Request:** `GET /news/99999`
**Expected:** `404 Not Found` or `AppException`

### Test Duplicate Slug
**Steps:**
1. Create news with slug: `test-slug`
2. Create another news with same slug: `test-slug`
**Expected:** `400 Bad Request` - "News with slug already exists"

---

## 📈 Performance Testing

### Test View Counter Concurrency
```bash
# Gọi API 10 lần liên tiếp
for i in {1..10}; do
  curl http://localhost:8080/news/slug/loi-ich-cua-vaccine-covid-19
done
```
**Expected:** viewCount tăng chính xác 10 lần

---

## 🎯 UI Integration Testing

### Homepage - Featured News Widget
```javascript
// Frontend code
fetch('http://localhost:8080/news/featured')
  .then(res => res.json())
  .then(data => {
    // Display top 5 featured news
    displayFeaturedNews(data.slice(0, 5));
  });
```

### News Category Page
```javascript
// Frontend code
const category = 'VACCINE_INFO';
fetch(`http://localhost:8080/news/category/${category}`)
  .then(res => res.json())
  .then(data => displayNewsList(data));
```

### News Detail Page with View Tracking
```javascript
// Frontend code
const slug = 'loi-ich-cua-vaccine-covid-19';
fetch(`http://localhost:8080/news/slug/${slug}`)
  .then(res => res.json())
  .then(data => {
    displayNewsDetail(data);
    // viewCount tự động tăng khi gọi API này
  });
```

### Search Functionality
```javascript
// Frontend code
const keyword = 'vaccine';
fetch(`http://localhost:8080/news?filter=title~'*${keyword}*' or content~'*${keyword}*'`)
  .then(res => res.json())
  .then(data => displaySearchResults(data.result));
```

---

## 📝 Quick Test Commands (Using curl)

### Get all news
```bash
curl http://localhost:8080/news
```

### Get featured news
```bash
curl http://localhost:8080/news/featured
```

### Get news by slug
```bash
curl http://localhost:8080/news/slug/loi-ich-cua-vaccine-covid-19
```

### Create news
```bash
curl -X POST http://localhost:8080/news \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test News",
    "content": "Test content",
    "category": "HEALTH_GENERAL",
    "isPublished": true
  }'
```

### Filter by category
```bash
curl "http://localhost:8080/news?filter=category:'VACCINE_INFO'"
```

### Publish news
```bash
curl -X PATCH http://localhost:8080/news/13/publish
```

### Delete news
```bash
curl -X DELETE http://localhost:8080/news/13
```

---

## ✅ Checklist trước khi Deploy

- [ ] Tất cả API endpoints hoạt động đúng
- [ ] Pagination hoạt động
- [ ] Filtering hoạt động với tất cả trường
- [ ] Sorting hoạt động
- [ ] View counter tăng chính xác
- [ ] Auto-generate slug hoạt động với tiếng Việt
- [ ] Publish/unpublish workflow hoạt động
- [ ] Soft delete hoạt động
- [ ] Validation errors trả về đúng
- [ ] Created/Updated timestamps tự động
- [ ] Response format đúng chuẩn

---

## 🐛 Troubleshooting

### Lỗi: Table 'news' doesn't exist
**Solution:** Kiểm tra Flyway migration đã chạy chưa. Restart server.

### Lỗi: Cannot convert string to NewsCategory enum
**Solution:** Kiểm tra category value phải đúng với enum (viết HOA, có dấu gạch dưới)

### Lỗi: Slug already exists
**Solution:** Đổi title hoặc provide custom slug khác

### View count không tăng
**Solution:** Check transaction configuration, database lock

---

## 📞 Support

Nếu gặp vấn đề, kiểm tra:
1. Server logs: `mvn spring-boot:run`
2. Database logs
3. Request/Response trong Postman
4. Network tab trong browser DevTools

---

**Happy Testing! 🚀**
