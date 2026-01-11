# Birthday Validation Guide

Hướng dẫn validate ngày sinh (birthday) trong hệ thống SafeVax.

## 📋 Quy tắc validation

### Backend (Java)

#### 1. **Validation Rules**

```java
@ValidBirthday(required = true, maxAge = 150)
private LocalDate birthday;
```

**Quy tắc:**
- ✅ Birthday phải ở quá khứ (không thể sinh trong tương lai)
- ✅ Birthday không được quá 150 năm trước (người sống lâu nhất thế giới: 122 tuổi)
- ✅ Birthday có thể là hôm nay (cho trẻ sơ sinh)
- ✅ Format: `yyyy-MM-dd` (LocalDate)

#### 2. **Custom Validator: @ValidBirthday**

Located: `com.dapp.backend.validation.ValidBirthday`

```java
@ValidBirthday(
    required = true,    // Birthday có bắt buộc không
    maxAge = 150        // Tuổi tối đa cho phép
)
```

**Error Messages:**
- `"Birthday is required"` - Khi required=true và birthday null
- `"Birthday cannot be in the future"` - Khi nhập ngày tương lai
- `"Birthday cannot be more than 150 years ago"` - Khi quá 150 tuổi

#### 3. **Usage trong DTOs**

**CompleteProfileRequest** (Bắt buộc):
```java
@ValidBirthday(required = true, maxAge = 150)
private LocalDate birthday;
```

**UpdateProfileRequest** (Không bắt buộc):
```java
@ValidBirthday(required = false, maxAge = 150)
private LocalDate birthday;
```

### Frontend (React)

#### 1. **Birthday Validation Utility**

Located: `frontend/src/utils/birthdayValidation.js`

```javascript
import { birthdayValidation } from '@/utils/birthdayValidation';

// Check if birthday is valid
const isValid = birthdayValidation.isValidBirthday(date);

// Calculate age
const age = birthdayValidation.calculateAge(birthday);

// Get age category
const category = birthdayValidation.getAgeCategory(birthday);
// Returns: 'NEWBORN' | 'CHILD' | 'ADULT'

// Format birthday
const formatted = birthdayValidation.format(birthday, 'DD/MM/YYYY');
```

#### 2. **Form Validation Rules**

```jsx
<Form.Item
  name="birthday"
  label="Date of Birth"
  rules={birthdayValidation.getFormRules(true)} // true = required
>
  <DatePicker
    className="w-full"
    format="DD/MM/YYYY"
    disabledDate={birthdayValidation.disabledDate}
  />
</Form.Item>
```

#### 3. **DatePicker Configuration**

```jsx
<DatePicker
  format="DD/MM/YYYY"
  disabledDate={birthdayValidation.disabledDate}
  // Disable:
  // - Future dates
  // - Dates more than 150 years ago
/>
```

## 🎯 Validation theo Use Case

### 1. **Complete Profile (Bắt buộc)**

**Backend:**
```java
@ValidBirthday(required = true, maxAge = 150)
private LocalDate birthday;
```

**Frontend:**
```jsx
rules={birthdayValidation.getFormRules(true)}
```

### 2. **Update Profile (Không bắt buộc)**

**Backend:**
```java
@ValidBirthday(required = false, maxAge = 150)
private LocalDate birthday;
```

**Frontend:**
```jsx
rules={birthdayValidation.getFormRules(false)}
```

### 3. **Admin tạo User (Có thể bỏ trống)**

**Backend:**
```java
@ValidBirthday(required = false, maxAge = 150)
private LocalDate birthday;
```

**Frontend:**
```jsx
rules={birthdayValidation.getFormRules(false)}
```

## 📊 Age Categories

Hệ thống phân loại theo tuổi để quản lý vaccine phù hợp:

| Category | Age Range | Identity Type |
|----------|-----------|---------------|
| NEWBORN  | 0-11 months | NEWBORN |
| CHILD    | 1-17 years | CHILD |
| ADULT    | 18+ years | ADULT |

```javascript
// Get age category
const category = birthdayValidation.getAgeCategory(birthday);

if (category === 'NEWBORN') {
  // Show vaccine schedule for newborns
} else if (category === 'CHILD') {
  // Show vaccine schedule for children
} else {
  // Show vaccine schedule for adults
}
```

## ⚠️ Edge Cases

### 1. **Trẻ sơ sinh (sinh hôm nay)**
- ✅ Backend: Cho phép (birthday = today)
- ✅ Frontend: Cho phép chọn hôm nay
- ✅ Age: 0 tuổi, category: NEWBORN

### 2. **Người cao tuổi (> 100 tuổi)**
- ✅ Backend: Cho phép đến 150 tuổi
- ✅ Frontend: Cho phép chọn đến 150 năm trước
- ✅ Lý do: Record người sống lâu nhất: 122 tuổi

### 3. **Nhập ngày không hợp lệ**
- ❌ 31/02/2024 - LocalDate tự động validate
- ❌ 32/01/2024 - Không cho phép
- ❌ Ngày tương lai - Bị reject

### 4. **Null birthday**
- Complete Profile: ❌ Bắt buộc
- Update Profile: ✅ Cho phép (giữ nguyên giá trị cũ)

## 🔧 Testing

### Backend Unit Tests

```java
@Test
void testValidBirthday() {
    // Valid: Today (newborn)
    LocalDate today = LocalDate.now();
    assertTrue(validator.isValid(today, context));
    
    // Valid: 30 years ago
    LocalDate thirtyYearsAgo = LocalDate.now().minusYears(30);
    assertTrue(validator.isValid(thirtyYearsAgo, context));
    
    // Invalid: Future date
    LocalDate tomorrow = LocalDate.now().plusDays(1);
    assertFalse(validator.isValid(tomorrow, context));
    
    // Invalid: More than 150 years ago
    LocalDate tooOld = LocalDate.now().minusYears(151);
    assertFalse(validator.isValid(tooOld, context));
}
```

### Frontend Unit Tests

```javascript
describe('birthdayValidation', () => {
  test('valid birthday - today', () => {
    const today = dayjs();
    expect(birthdayValidation.isValidBirthday(today)).toBe(true);
  });

  test('invalid birthday - future', () => {
    const tomorrow = dayjs().add(1, 'day');
    expect(birthdayValidation.isValidBirthday(tomorrow)).toBe(false);
  });

  test('invalid birthday - too old', () => {
    const tooOld = dayjs().subtract(151, 'year');
    expect(birthdayValidation.isValidBirthday(tooOld)).toBe(false);
  });

  test('calculate age correctly', () => {
    const birthday = dayjs().subtract(25, 'year');
    expect(birthdayValidation.calculateAge(birthday)).toBe(25);
  });

  test('age category - NEWBORN', () => {
    const newborn = dayjs().subtract(6, 'month');
    expect(birthdayValidation.getAgeCategory(newborn)).toBe('NEWBORN');
  });

  test('age category - CHILD', () => {
    const child = dayjs().subtract(10, 'year');
    expect(birthdayValidation.getAgeCategory(child)).toBe('CHILD');
  });

  test('age category - ADULT', () => {
    const adult = dayjs().subtract(25, 'year');
    expect(birthdayValidation.getAgeCategory(adult)).toBe('ADULT');
  });
});
```

## 📝 Examples

### 1. **Complete Profile Form**

```jsx
<Form.Item
  name="birthday"
  label="Date of Birth"
  rules={birthdayValidation.getFormRules(true)}
>
  <DatePicker
    className="w-full"
    size="large"
    format="DD/MM/YYYY"
    placeholder="Select your birthday"
    disabledDate={birthdayValidation.disabledDate}
  />
</Form.Item>
```

### 2. **Profile Edit Form**

```jsx
<Form.Item
  name="birthday"
  label="Date of Birth"
  rules={birthdayValidation.getFormRules(false)}
>
  <DatePicker
    className="w-full"
    size="large"
    format="DD/MM/YYYY"
    placeholder="Select date (optional)"
    disabledDate={birthdayValidation.disabledDate}
  />
</Form.Item>
```

### 3. **Display Age**

```jsx
const age = birthdayValidation.calculateAge(user.birthday);
const category = birthdayValidation.getAgeCategory(user.birthday);

<div>
  <p>Age: {age} years old</p>
  <p>Category: {category}</p>
  <p>Birthday: {birthdayValidation.format(user.birthday)}</p>
</div>
```

## 🚀 Best Practices

1. **Always use @ValidBirthday** thay vì @Past
   - Kiểm tra đầy đủ hơn
   - Custom error messages rõ ràng
   - Có thể config maxAge

2. **Frontend: Sử dụng birthdayValidation utility**
   - Consistency trong toàn project
   - Reusable validation logic
   - Easy to maintain

3. **DatePicker thay vì Input**
   - Better UX
   - Built-in calendar picker
   - Auto format validation

4. **Display format: DD/MM/YYYY**
   - User-friendly cho người Việt
   - Backend format: yyyy-MM-dd (ISO 8601)

5. **Calculate age dynamically**
   - Không lưu age trong DB
   - Tính từ birthday mỗi lần cần
   - Đảm bảo luôn chính xác

## 🔒 Security Considerations

1. **Validate cả frontend và backend**
   - Frontend: UX và feedback ngay
   - Backend: Security và data integrity

2. **Không trust client-side validation**
   - Always validate on backend
   - Frontend validation chỉ là helper

3. **Log suspicious inputs**
   - Birthday > 150 years ago
   - Birthday in future
   - Multiple failed validation attempts

## 📚 References

- Backend Validator: `com.dapp.backend.validation.BirthdayValidator`
- Frontend Utility: `frontend/src/utils/birthdayValidation.js`
- DTOs: `CompleteProfileRequest`, `UpdateProfileRequest`
- Components: `CompleteProfilePage.jsx`, `tab.edit-user.jsx`
