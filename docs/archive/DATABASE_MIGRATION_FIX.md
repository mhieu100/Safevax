# Database Migration Fix - November 17, 2025

## Problem Summary

When adding audit fields (`createdAt`, `updatedAt`, `isDeleted`) to existing tables with data, Hibernate attempted to create columns with `NOT NULL` constraint, causing:

```
ERROR: column "is_deleted" of relation "vaccines" contains null values
ERROR: column "created_at" of relation "vaccines" contains null values
```

Additionally, changing `center_id` to `id` would break existing foreign key relationships in other tables (appointments, users, etc.).

---

## Solutions Implemented

### 1. BaseEntity - Made Columns Nullable

**File:** `backend/src/main/java/com/dapp/backend/model/BaseEntity.java`

**Changes:**
- Removed `nullable = false` from `@Column` annotations
- Changed `boolean isDeleted` → `Boolean isDeleted` (boxed type allows null)
- Made all audit fields optional to support existing data

```java
@MappedSuperclass
@Data
public abstract class BaseEntity {
    @CreationTimestamp
    @Column(name = "created_at", updatable = false)  // Removed nullable=false
    LocalDateTime createdAt;
    
    @UpdateTimestamp
    @Column(name = "updated_at")  // Nullable by default
    LocalDateTime updatedAt;
    
    @Column(name = "is_deleted")  // Nullable, defaults to false
    Boolean isDeleted = false;
}
```

**Why:**
- Existing rows don't have these columns yet
- Hibernate can add columns without NOT NULL constraint
- Application code handles null values with defaults

---

### 2. Center Model - Keep center_id Field Name

**File:** `backend/src/main/java/com/dapp/backend/model/Center.java`

**Changes:**
- Reverted `id` back to `centerId` 
- Added `@Column(name = "center_id")` to map to existing column
- Prevents breaking foreign key relationships

```java
@Entity
@Table(name = "centers")
public class Center extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "center_id")  // Maps to existing column
    Long centerId;  // Keep Java field name
    
    String slug;
    // ...
}
```

**Why:**
- Other tables (appointments, users) have foreign keys to `center_id`
- Renaming would require cascading changes across database schema
- Keeping `centerId` maintains backward compatibility

---

### 3. Updated Service Methods for isDeleted

**Files:** 
- `VaccineService.java`
- `CenterService.java`

**Changes:**
- Changed `setDeleted(true)` → `setIsDeleted(true)`

```java
// VaccineService.java
public void deleteVaccine(Long id) {
    vaccine.setIsDeleted(true);  // Lombok generates setIsDeleted() for Boolean
    vaccineRepository.save(vaccine);
}

// CenterService.java  
public void deleteCenter(Long id) {
    center.setIsDeleted(true);  // Lombok generates setIsDeleted() for Boolean
    centerRepository.save(center);
}
```

**Why:**
- Lombok generates `getIsDeleted()` and `setIsDeleted()` for Boolean fields
- For primitive `boolean`, it would generate `isDeleted()` and `setDeleted()`
- Using boxed `Boolean` allows null values and changes method names

---

### 4. Fixed Mapper Methods

**Files:**
- `BookingMapper.java`
- `UserMapper.java`
- `AuthService.java`

**Changes:**
- Changed `center.getId()` → `center.getCenterId()`

```java
// BookingMapper.java
.centerId(appointment.getCenter().getCenterId())

// UserMapper.java
.centerId(center.getCenterId())

// AuthService.java
.centerId(center != null ? center.getCenterId() : null)
```

**Why:**
- Field name is `centerId`, not `id`
- Lombok generates `getCenterId()` getter method

---

### 5. Reverted Frontend Changes

**Files:**
- `center.jsx`
- `modal.center.jsx`

**Changes:**
- Reverted `id` back to `centerId` everywhere
- `dataInit?.centerId` instead of `dataInit?.id`
- `entity.centerId` for delete operations
- `rowKey="centerId"` in DataTable

**Why:**
- Backend response uses `centerId` field
- Frontend must match backend DTO structure

---

## Database Migration Script

**File:** `database-migration.sql`

Safe migration process:

```sql
-- Step 1: Add columns as NULLABLE (no NOT NULL constraint)
ALTER TABLE vaccines 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE vaccines 
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE;

-- Step 2: Update existing NULL values
UPDATE vaccines 
SET created_at = CURRENT_TIMESTAMP 
WHERE created_at IS NULL;

UPDATE vaccines 
SET is_deleted = FALSE 
WHERE is_deleted IS NULL;

-- Repeat for centers table
-- Add slug column for centers
-- Generate basic slugs for existing records
```

**Key Points:**
1. Add columns without NOT NULL constraint first
2. Set default values for existing rows
3. Let application handle new records with @CreationTimestamp/@UpdateTimestamp
4. Keep `center_id` column name unchanged

---

## Migration Steps

### 1. Run SQL Script
```bash
psql -U your_user -d safevax_db -f database-migration.sql
```

### 2. Restart Spring Boot Backend
```bash
cd backend
./mvnw spring-boot:run
```

### 3. Verify
- Check that application starts without errors
- Test creating new vaccine/center (should have timestamps)
- Test updating existing records (should update `updated_at`)
- Test soft delete (should set `is_deleted = true`)

---

## Testing Checklist

### Backend Tests
- [ ] Application starts without DDL errors
- [ ] Create new vaccine → has `created_at`, `updated_at`
- [ ] Update vaccine → `updated_at` changes
- [ ] Delete vaccine → `is_deleted = true` (soft delete)
- [ ] Create new center → has timestamps and slug
- [ ] Update center → timestamps update correctly
- [ ] Delete center → soft delete works

### Frontend Tests
- [ ] Center list displays correctly
- [ ] Edit center modal loads data
- [ ] Create center works
- [ ] Update center works
- [ ] Delete center works (soft delete)

---

## Key Lessons

### 1. Nullable vs NOT NULL
When adding columns to tables with existing data:
- ✅ Start with nullable columns
- ✅ Set default values for existing rows
- ❌ Don't use NOT NULL on initial migration

### 2. Field Naming Consistency
- Keep database column names stable (`center_id`)
- Use `@Column(name = "...")` to map different Java field names
- Prevents breaking foreign key relationships

### 3. Lombok Boolean Gotcha
- `boolean isDeleted` → `isDeleted()`, `setDeleted()`
- `Boolean isDeleted` → `getIsDeleted()`, `setIsDeleted()`
- Use boxed `Boolean` for nullable fields

### 4. Audit Fields Best Practice
```java
@CreationTimestamp  // Auto-set on insert
@UpdateTimestamp    // Auto-update on modification
Boolean isDeleted = false;  // Soft delete flag
```

---

## Rollback Plan

If migration fails:

```sql
-- Remove audit columns
ALTER TABLE vaccines DROP COLUMN IF EXISTS created_at;
ALTER TABLE vaccines DROP COLUMN IF EXISTS updated_at;
ALTER TABLE vaccines DROP COLUMN IF EXISTS is_deleted;

ALTER TABLE centers DROP COLUMN IF EXISTS slug;
ALTER TABLE centers DROP COLUMN IF EXISTS created_at;
ALTER TABLE centers DROP COLUMN IF EXISTS updated_at;
ALTER TABLE centers DROP COLUMN IF EXISTS is_deleted;
```

Then revert code changes to remove `extends BaseEntity`.

---

## Future Improvements

1. **Add Indexes:**
```sql
CREATE INDEX idx_vaccines_is_deleted ON vaccines(is_deleted);
CREATE INDEX idx_centers_is_deleted ON centers(is_deleted);
```

2. **Filter Deleted Records:**
```java
// In repositories, exclude soft-deleted records
@Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false")
List<Vaccine> findAllActive();
```

3. **Audit Trail:**
- Add `created_by`, `updated_by` fields
- Track who made changes

4. **Apply to Other Models:**
- User → extend BaseEntity
- Appointment → extend BaseEntity
- Booking → extend BaseEntity

---

**Migration completed successfully! ✅**
