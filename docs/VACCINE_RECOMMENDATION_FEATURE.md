# Vaccine Recommendation Feature

## Tổng quan
Tính năng gợi ý vaccine phù hợp dựa trên độ tuổi, giới tính và nhu cầu của người dùng.

## Backend API Endpoints

### 1. Lấy vaccine theo độ tuổi và giới tính
```
GET /api/vaccines/recommended?ageInMonths={age}&gender={gender}
```
- `ageInMonths`: Tuổi tính theo tháng (bắt buộc)
- `gender`: MALE, FEMALE, hoặc ALL (mặc định: ALL)

### 2. Lấy vaccine thiết yếu theo độ tuổi
```
GET /api/vaccines/essential?ageInMonths={age}
```

### 3. Lấy vaccine theo nhóm đối tượng
```
GET /api/vaccines/target-group/{targetGroup}
```
Target groups:
- `NEWBORN`: Sơ sinh (0-2 tháng)
- `INFANT`: Trẻ sơ sinh (2-12 tháng)
- `TODDLER`: Trẻ nhỏ (1-3 tuổi)
- `CHILD`: Trẻ em (4-11 tuổi)
- `TEEN`: Thanh thiếu niên (12-17 tuổi)
- `ADULT`: Người lớn (18-64 tuổi)
- `ELDERLY`: Người cao tuổi (65+)
- `PREGNANT`: Phụ nữ mang thai
- `ALL`: Tất cả

### 4. Lấy vaccine theo danh mục
```
GET /api/vaccines/category/{category}
```
Categories:
- `BASIC_CHILDHOOD`: Tiêm chủng cơ bản cho trẻ
- `SCHOOL_AGE`: Tiêm nhắc khi đi học
- `ADULT_ROUTINE`: Tiêm thường xuyên cho người lớn
- `PREGNANCY`: Vaccine liên quan thai kỳ
- `ELDERLY_CARE`: Vaccine cho người cao tuổi
- `TRAVEL`: Vaccine du lịch
- `COVID19`: Vaccine COVID-19

### 5. API cho phụ nữ mang thai

#### An toàn khi mang thai
```
GET /api/vaccines/pregnancy/safe
```

#### Nên tiêm trước khi mang thai
```
GET /api/vaccines/pregnancy/pre
```

#### Nên tiêm sau sinh
```
GET /api/vaccines/pregnancy/post
```

### 6. Lấy danh sách categories và target groups
```
GET /api/vaccines/categories
GET /api/vaccines/target-groups
```

## Database Schema

### Các trường mới trong bảng `vaccines`

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `target_group` | VARCHAR(50) | Nhóm đối tượng: NEWBORN, INFANT, TODDLER, CHILD, TEEN, ADULT, ELDERLY, PREGNANT, ALL |
| `min_age_months` | INT | Tuổi tối thiểu (tháng) |
| `max_age_months` | INT | Tuổi tối đa (tháng), NULL = không giới hạn |
| `gender_specific` | VARCHAR(10) | MALE, FEMALE, ALL |
| `pregnancy_safe` | BOOLEAN | An toàn cho phụ nữ mang thai |
| `pre_pregnancy` | BOOLEAN | Nên tiêm trước mang thai |
| `post_pregnancy` | BOOLEAN | Nên tiêm sau sinh |
| `priority_level` | VARCHAR(20) | ESSENTIAL, RECOMMENDED, OPTIONAL, TRAVEL |
| `category` | VARCHAR(50) | Danh mục vaccine |

## Frontend Component

### RecommendedVaccinesSection

Component hiển thị vaccine gợi ý trên trang Home với các tab:
- **Cho bạn**: Vaccine phù hợp với người dùng đang đăng nhập (dựa trên birthday và gender)
- **Người thân**: Vaccine phù hợp cho thành viên gia đình
- **Trước mang thai**: Vaccine nên tiêm trước khi mang thai
- **Khi mang thai**: Vaccine an toàn trong thai kỳ
- **Sau sinh**: Vaccine nên tiêm sau sinh

### Sử dụng

Component tự động:
1. Lấy thông tin user từ `useAccountStore`
2. Tính tuổi theo tháng từ `birthday`
3. Gọi API phù hợp dựa trên tab được chọn
4. Hiển thị grid vaccine với thông tin priority, target group

## Migration

Chạy migration để cập nhật database:

```bash
cd backend
./mvnw flyway:migrate
```

Hoặc restart ứng dụng Spring Boot (Flyway sẽ tự động chạy migration).

## File đã thay đổi

### Backend
- `src/main/resources/db/migration/V2__add_vaccine_target_groups.sql`
- `src/main/java/com/dapp/backend/model/Vaccine.java`
- `src/main/java/com/dapp/backend/repository/VaccineRepository.java`
- `src/main/java/com/dapp/backend/service/VaccineService.java`
- `src/main/java/com/dapp/backend/controller/VaccineController.java`
- `src/main/java/com/dapp/backend/dto/response/VaccineResponse.java`
- `src/main/java/com/dapp/backend/dto/request/VaccineRequest.java`
- `src/main/java/com/dapp/backend/dto/mapper/VaccineMapper.java`

### Frontend
- `src/services/vaccine.service.js`
- `src/pages/client/home/components/RecommendedVaccinesSection.jsx`
- `src/pages/client/home/index.jsx`

## Cách tính tuổi theo tháng

```javascript
const calculateAgeInMonths = (birthday) => {
  const birthDate = new Date(birthday);
  const today = new Date();
  const months = (today.getFullYear() - birthDate.getFullYear()) * 12 +
                 (today.getMonth() - birthDate.getMonth());
  return months;
};
```

Ví dụ:
- Trẻ 6 tuần tuổi ≈ 1.5 tháng → `ageInMonths = 1`
- Trẻ 9 tháng → `ageInMonths = 9`
- Người 25 tuổi → `ageInMonths = 300`

## Testing

### Test API với cURL

```bash
# Vaccine cho trẻ 6 tháng
curl "http://localhost:8080/api/vaccines/recommended?ageInMonths=6&gender=ALL"

# Vaccine thiết yếu cho trẻ 2 tuổi
curl "http://localhost:8080/api/vaccines/essential?ageInMonths=24"

# Vaccine cho phụ nữ mang thai
curl "http://localhost:8080/api/vaccines/pregnancy/safe"

# Vaccine theo target group
curl "http://localhost:8080/api/vaccines/target-group/INFANT"
```
