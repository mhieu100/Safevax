# 📰 News API - SafeVax Backend

## 📖 Tổng quan

API quản lý tin tức về sức khỏe và vaccine cho hệ thống SafeVax.

## 🚀 Quick Start

### 1. Start Server
```bash
cd backend
mvn spring-boot:run
```

### 2. Test API
```bash
# Sử dụng script test tự động
chmod +x test-news-api.sh
./test-news-api.sh

# Hoặc import Postman collection
# File: News_API.postman_collection.json
```

### 3. Xem hướng dẫn chi tiết
Đọc file: [NEWS_API_TESTING_GUIDE.md](NEWS_API_TESTING_GUIDE.md)

---

## 📋 Danh mục tin tức (NewsCategory)

| Enum | Mô tả |
|------|-------|
| `HEALTH_GENERAL` | Sức khỏe tổng quát |
| `VACCINE_INFO` | Thông tin vaccine |
| `DISEASE_PREVENTION` | Phòng ngừa bệnh tật |
| `NUTRITION` | Dinh dưỡng |
| `CHILDREN_HEALTH` | Sức khỏe trẻ em |
| `WOMEN_HEALTH` | Sức khỏe phụ nữ |
| `ELDERLY_CARE` | Chăm sóc người cao tuổi |
| `MEDICAL_RESEARCH` | Nghiên cứu y khoa |
| `HEALTH_TIPS` | Mẹo sức khỏe |
| `COVID_19` | COVID-19 |
| `SEASONAL_DISEASES` | Bệnh theo mùa |
| `VACCINATION_SCHEDULE` | Lịch tiêm chủng |

---

## 🔌 API Endpoints

### Public Endpoints (Không cần auth)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/news` | Lấy tất cả tin (phân trang + filter) |
| GET | `/news/published` | Lấy tin đã xuất bản |
| GET | `/news/featured` | Lấy tin nổi bật |
| GET | `/news/slug/{slug}` | Lấy tin theo slug (tự động +view) |
| GET | `/news/{id}` | Lấy tin theo ID |
| GET | `/news/category/{category}` | Lấy tin theo danh mục |
| GET | `/news/categories` | Danh sách categories |

### Admin Endpoints (Cần auth - future)

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| POST | `/news` | Tạo tin mới |
| PUT | `/news/{id}` | Cập nhật tin |
| DELETE | `/news/{id}` | Xóa tin (soft delete) |
| PATCH | `/news/{id}/publish` | Xuất bản tin |
| PATCH | `/news/{id}/unpublish` | Gỡ xuất bản |

---

## 📝 Ví dụ Request/Response

### GET /news/featured
**Response:**
```json
[
  {
    "id": 2,
    "slug": "loi-ich-cua-vaccine-covid-19",
    "title": "Lợi ích của Vaccine COVID-19 đối với sức khỏe cộng đồng",
    "shortDescription": "Vaccine COVID-19 không chỉ bảo vệ bản thân...",
    "category": "VACCINE_INFO",
    "author": "PGS.TS Trần Thị Hoa",
    "viewCount": 320,
    "isFeatured": true,
    "isPublished": true,
    "publishedAt": "2024-01-15T10:30:00",
    "tags": "covid-19,vaccine,phòng bệnh",
    "source": "Viện Vệ sinh Dịch tễ Trung ương",
    "createdAt": "2024-01-14T08:00:00",
    "updatedAt": "2024-01-15T10:30:00"
  }
]
```

### POST /news
**Request:**
```json
{
  "title": "Vaccine HPV - Bảo vệ sức khỏe phụ nữ",
  "shortDescription": "Vaccine HPV giúp phòng ngừa ung thư cổ tử cung",
  "content": "<h2>Vaccine HPV</h2><p>Nội dung chi tiết...</p>",
  "category": "VACCINE_INFO",
  "author": "BS. Nguyễn Thị Hoa",
  "isFeatured": true,
  "isPublished": true,
  "tags": "hpv,vaccine,ung thư,phụ nữ",
  "source": "Bộ Y tế"
}
```

**Response:** (201 Created)
```json
{
  "id": 14,
  "slug": "vaccine-hpv-bao-ve-suc-khoe-phu-nu",
  "title": "Vaccine HPV - Bảo vệ sức khỏe phụ nữ",
  "shortDescription": "Vaccine HPV giúp phòng ngừa ung thư cổ tử cung",
  "content": "<h2>Vaccine HPV</h2><p>Nội dung chi tiết...</p>",
  "category": "VACCINE_INFO",
  "author": "BS. Nguyễn Thị Hoa",
  "viewCount": 0,
  "isFeatured": true,
  "isPublished": true,
  "publishedAt": "2024-01-16T14:20:30",
  "tags": "hpv,vaccine,ung thư,phụ nữ",
  "source": "Bộ Y tế",
  "createdAt": "2024-01-16T14:20:30",
  "updatedAt": "2024-01-16T14:20:30"
}
```

---

## 🔍 Filtering Examples

### Filter by Category
```
GET /news?filter=category:'VACCINE_INFO'
```

### Search by Title
```
GET /news?filter=title~'*vaccine*'
```

### Complex Filter
```
GET /news?filter=isFeatured:true and isPublished:true&sort=viewCount,desc
```

### Pagination + Sort
```
GET /news?page=0&size=10&sort=publishedAt,desc
```

---

## ✨ Tính năng nổi bật

- ✅ **Auto-generate slug** từ tiếng Việt
- ✅ **View counter** tự động tăng khi xem bài
- ✅ **Soft delete** - không xóa thật khỏi database
- ✅ **Featured news** - đánh dấu bài nổi bật
- ✅ **Publish workflow** - draft → published
- ✅ **Full-text search** - tìm kiếm trong title, content
- ✅ **Dynamic filtering** - filter theo bất kỳ field nào
- ✅ **Pagination** - phân trang linh hoạt
- ✅ **Multiple images** - thumbnail + cover image
- ✅ **Tags & categories** - phân loại đa dạng
- ✅ **Timestamps** - tự động track created/updated time

---

## 📊 Dữ liệu mẫu

Hệ thống có sẵn **13 bài viết mẫu** sau khi chạy migration:
- 7 bài featured (nổi bật)
- 12 bài published
- 1 bài draft (để test publish)
- Đa dạng các danh mục

---

## 🏗️ Cấu trúc Code

```
backend/src/main/java/com/dapp/backend/
├── model/News.java                    # Entity
├── enums/NewsCategory.java            # Enum categories
├── dto/
│   ├── request/NewsRequest.java       # Request DTO
│   ├── response/NewsResponse.java     # Response DTO
│   └── mapper/NewsMapper.java         # Mapper
├── repository/NewsRepository.java     # JPA Repository
├── service/
│   ├── NewsService.java               # Business Logic
│   └── spec/NewsSpecifications.java   # Dynamic Filters
└── controller/NewsController.java     # REST Endpoints
```

**Database Migration:**
```
src/main/resources/db/migration/
├── V5__create_news_table.sql          # Create table + indexes
└── V6__seed_news_data.sql             # Sample data
```

---

## 🧪 Testing

### Automated Test
```bash
./test-news-api.sh
```

### Postman Collection
Import file: `News_API.postman_collection.json`

### Manual cURL
```bash
# Get all news
curl http://localhost:8080/news

# Get featured
curl http://localhost:8080/news/featured

# Create news
curl -X POST http://localhost:8080/news \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","content":"Test","category":"HEALTH_GENERAL"}'
```

---

## 🔐 Security (Future Enhancement)

Hiện tại API đang public. Cần thêm:
- ✅ Spring Security cho admin endpoints
- ✅ JWT authentication
- ✅ Role-based access (ADMIN, EDITOR, USER)
- ✅ Rate limiting cho view counter

---

## 📞 Liên hệ

Nếu có vấn đề, kiểm tra:
1. Server logs
2. Database connection
3. [Testing Guide](NEWS_API_TESTING_GUIDE.md)

---

**Happy Coding! 🚀**
