# Doctor Schedule System - Migration Checklist

## 📋 Overview
This checklist tracks the migration from simple `doctor_id` FK to comprehensive doctor schedule management system.

**Migration Date:** _________________  
**Executed By:** _________________  
**Environment:** Development / Staging / Production

---

## 🎯 Pre-Migration Checklist

### Database Backup
- [ ] Full database backup created
- [ ] Backup verified and tested
- [ ] Backup location documented: _________________

### Environment Check
- [ ] PostgreSQL version: 13+ ✓
- [ ] Spring Boot application builds successfully
- [ ] Flyway migrations up to V2 executed
- [ ] No pending uncommitted code changes

### Data Verification (Old System)
- [ ] Count existing doctors: `SELECT COUNT(*) FROM users WHERE role = 'DOCTOR'`
  - Expected: ~20 doctors
  - Actual: _____ doctors
- [ ] Count existing appointments: `SELECT COUNT(*) FROM appointments WHERE doctor_id IS NOT NULL`
  - Actual: _____ appointments
- [ ] Check data integrity: All doctor_id in appointments exist in users table
  - [ ] No orphaned foreign keys

---

## 🚀 Migration Execution

### Step 1: Run Migration V3 (Create New Tables)
- [ ] Start Spring Boot application
- [ ] Verify migration V3 executed successfully
  - Check logs: `Migration V3__create_doctor_schedule_system.sql completed`
- [ ] Verify in `flyway_schema_history`:
  ```sql
  SELECT version, description, success FROM flyway_schema_history 
  WHERE version = '3';
  ```
  - [ ] Version 3 exists with `success = true`

### Step 2: Verify Table Creation
- [ ] Table `doctors` created
  ```sql
  SELECT COUNT(*) FROM doctors;  -- Should be 0 at this point
  ```
- [ ] Table `doctor_schedules` created
- [ ] Table `doctor_special_schedules` created
- [ ] Table `doctor_leave` created
- [ ] Table `doctor_available_slots` created

### Step 3: Verify Triggers and Functions
- [ ] Function `generate_doctor_slots` exists:
  ```sql
  SELECT routine_name FROM information_schema.routines 
  WHERE routine_name = 'generate_doctor_slots';
  ```
- [ ] Trigger `update_slot_status_on_assignment` exists:
  ```sql
  SELECT trigger_name FROM information_schema.triggers 
  WHERE trigger_name LIKE 'update_slot_status_%';
  ```

### Step 4: Run Migration V4 (Migrate Data)
- [ ] Restart application or wait for V4 to execute
- [ ] Check logs for V4 execution messages:
  - [ ] "Doctors migrated: XX"
  - [ ] "Schedules created: XXX"
  - [ ] "Special schedules created: X"
  - [ ] "Leave records created: X"
  - [ ] "Slots generation completed"

### Step 5: Verify Data Migration
- [ ] Check migrated doctors:
  ```sql
  SELECT COUNT(*) FROM doctors;
  -- Expected: ~20 (same as old doctor count)
  ```
  - Actual: _____ doctors

- [ ] Verify doctor details:
  ```sql
  SELECT doctor_id, user_id, specialization, license_number, 
         consultation_duration, max_patients_per_day 
  FROM doctors LIMIT 5;
  ```
  - [ ] All fields populated correctly
  - [ ] License numbers follow format: BYT-XXXXXX

- [ ] Check weekly schedules:
  ```sql
  SELECT COUNT(*) FROM doctor_schedules;
  -- Expected: ~220 (20 doctors × 11 schedules)
  ```
  - Actual: _____ schedules
  - [ ] Each doctor has 11 schedules (Mon-Fri 8-12, 14-17; Sat 8-12)

- [ ] Check special schedules:
  ```sql
  SELECT COUNT(*) FROM doctor_special_schedules;
  -- Expected: 3
  ```
  - Actual: _____ special schedules

- [ ] Check leave records:
  ```sql
  SELECT COUNT(*) FROM doctor_leave;
  -- Expected: 2
  ```
  - Actual: _____ leave records

- [ ] Check generated slots:
  ```sql
  SELECT COUNT(*) FROM doctor_available_slots;
  -- Expected: ~16,800 (20 doctors × 14 slots/day × 60 days)
  ```
  - Actual: _____ slots

- [ ] Verify slot distribution:
  ```sql
  SELECT status, COUNT(*) 
  FROM doctor_available_slots 
  GROUP BY status;
  ```
  - [ ] Most slots are AVAILABLE
  - [ ] No BOOKED slots (unless appointments assigned)
  - [ ] Some BLOCKED slots possible

---

## 🧪 API Testing

### Setup
- [ ] Backend running on `http://localhost:8080`
- [ ] Test user credentials ready:
  - Cashier: cashier.d@vax.com / 123456
  - Doctor: doctor.center1.a@vax.com / 123456

### Option 1: Using Bash Script
- [ ] Make script executable: `chmod +x test-doctor-api.sh`
- [ ] Run script: `./test-doctor-api.sh`
- [ ] All tests pass successfully

### Option 2: Using Postman
- [ ] Import collection: `Doctor_Schedule_API.postman_collection.json`
- [ ] Set `baseUrl` variable to `http://localhost:8080`
- [ ] Run "Authentication > Login as Cashier"
- [ ] Copy token and run tests in order
- [ ] All requests return 200 status

### Option 3: Manual Testing (TESTING_DOCTOR_API.md)
- [ ] Test 1: Get Available Doctors - SUCCESS
  - Response: _____ doctors found
- [ ] Test 2: Get Doctor Schedules - SUCCESS
  - Response: _____ schedules found
- [ ] Test 3: Get Available Slots by Doctor - SUCCESS
  - Response: _____ slots found
- [ ] Test 4: Get Available Slots by Center - SUCCESS
  - Response: _____ slots found
- [ ] Test 5: Get Slots in Date Range - SUCCESS
  - Response: _____ slots found
- [ ] Test 6: Generate Slots - SUCCESS
  - Response: _____ slots generated

### Edge Case Testing
- [ ] Doctor on leave returns empty slots
- [ ] Special schedule shows correct limited hours
- [ ] Weekend slots respect Sat/Sun rules

---

## 🔍 Validation Queries

Run these queries to validate the migration:

### Query 1: Doctor-User Relationship
```sql
SELECT d.doctor_id, d.user_id, u.full_name, u.email, d.specialization
FROM doctors d
JOIN users u ON d.user_id = u.id
WHERE u.role = 'DOCTOR'
ORDER BY d.doctor_id
LIMIT 10;
```
- [ ] All doctors have corresponding user records
- [ ] User emails match expected pattern

### Query 2: Schedule Coverage
```sql
SELECT 
    d.doctor_id,
    u.full_name,
    COUNT(DISTINCT ds.day_of_week) as days_covered,
    COUNT(ds.schedule_id) as total_schedules
FROM doctors d
JOIN users u ON d.user_id = u.id
LEFT JOIN doctor_schedules ds ON d.doctor_id = ds.doctor_id
GROUP BY d.doctor_id, u.full_name
ORDER BY d.doctor_id
LIMIT 10;
```
- [ ] Most doctors have 6 days covered (Mon-Sat)
- [ ] Most doctors have 11 total schedules

### Query 3: Slot Generation Quality
```sql
SELECT 
    DATE(slot_date) as date,
    COUNT(*) as slot_count,
    COUNT(DISTINCT doctor_id) as doctor_count
FROM doctor_available_slots
WHERE slot_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
GROUP BY DATE(slot_date)
ORDER BY date;
```
- [ ] Each weekday has ~280 slots (20 doctors × 14 slots)
- [ ] Saturday has ~140 slots (20 doctors × 7 slots)
- [ ] Sunday has 0 slots

### Query 4: Leave Impact
```sql
SELECT 
    dl.doctor_id,
    u.full_name,
    dl.start_date,
    dl.end_date,
    COUNT(das.slot_id) as slots_in_leave_period
FROM doctor_leave dl
JOIN doctors d ON dl.doctor_id = d.doctor_id
JOIN users u ON d.user_id = u.id
LEFT JOIN doctor_available_slots das ON 
    das.doctor_id = dl.doctor_id 
    AND das.slot_date BETWEEN dl.start_date AND dl.end_date
WHERE dl.status = 'APPROVED'
GROUP BY dl.doctor_id, u.full_name, dl.start_date, dl.end_date;
```
- [ ] Doctors on leave have 0 slots during leave period

### Query 5: Appointment-Slot Link (After Integration)
```sql
SELECT 
    a.id as appointment_id,
    a.scheduled_date,
    a.scheduled_time,
    a.status as appointment_status,
    das.slot_id,
    das.status as slot_status,
    u.full_name as doctor_name
FROM appointments a
LEFT JOIN doctor_available_slots das ON a.slot_id = das.slot_id
LEFT JOIN doctors d ON das.doctor_id = d.doctor_id
LEFT JOIN users u ON d.user_id = u.id
WHERE a.slot_id IS NOT NULL
LIMIT 10;
```
- [ ] Appointments with slot_id have matching slot records
- [ ] Slot status is BOOKED when appointment is SCHEDULED

---

## 🔄 Frontend Integration

### Update Required Components
- [ ] `pending-appointment.jsx` - Use new slot-based APIs
  - [ ] Replace doctor dropdown with slot picker
  - [ ] Call `/doctors/{id}/slots/available?date=XXX`
  - [ ] Display available time slots
  - [ ] Include `slotId` in appointment assignment

- [ ] Create new component: `SlotPicker.jsx`
  - [ ] Date selector
  - [ ] Time slot grid
  - [ ] Status indicators (available/booked/blocked)

- [ ] Update appointment API calls
  - [ ] Add `slotId` to request payload
  - [ ] Handle slot booking response

### New Admin Pages (Optional)
- [ ] `doctor-schedule-management.jsx`
  - [ ] View/edit weekly schedules
  - [ ] Create special schedules
  - [ ] Generate slots in bulk

- [ ] `doctor-leave-management.jsx`
  - [ ] Submit leave requests
  - [ ] Approve/reject leave
  - [ ] View leave calendar

---

## ✅ Post-Migration Validation

### Data Integrity
- [ ] All old doctor_id references preserved in appointments
- [ ] No data loss during migration
- [ ] Foreign key constraints valid

### Performance Check
- [ ] Query response time < 200ms for slot queries
- [ ] Index performance validated:
  ```sql
  EXPLAIN ANALYZE 
  SELECT * FROM doctor_available_slots 
  WHERE doctor_id = 1 AND slot_date = CURRENT_DATE AND status = 'AVAILABLE';
  ```

### Business Logic Validation
- [ ] Cannot book same slot twice
- [ ] Slots auto-update to BOOKED when appointment assigned
- [ ] Slots return to AVAILABLE when appointment cancelled
- [ ] Leave periods block slot generation

---

## 📊 Migration Statistics

Fill in after migration:

| Metric | Before | After | Status |
|--------|--------|-------|--------|
| Total Doctors | _____ | _____ | ☐ Match |
| Doctor Schedules | 0 | _____ | ☐ OK |
| Available Slots | 0 | _____ | ☐ OK |
| Special Schedules | 0 | _____ | ☐ OK |
| Leave Records | 0 | _____ | ☐ OK |
| Total Database Size | _____ MB | _____ MB | ☐ OK |

---

## 🐛 Issues Encountered

| Issue | Description | Resolution | Status |
|-------|-------------|------------|--------|
| 1 | | | ☐ |
| 2 | | | ☐ |
| 3 | | | ☐ |

---

## 📝 Rollback Plan (If Needed)

In case of critical issues:

1. **Stop Application**
   ```bash
   ./mvnw spring-boot:stop
   ```

2. **Restore Database from Backup**
   ```bash
   psql -U your_user -d safevax_db < backup_before_migration.sql
   ```

3. **Revert Flyway Migrations**
   ```sql
   DELETE FROM flyway_schema_history WHERE version IN ('3', '4');
   DROP TABLE IF EXISTS doctor_available_slots CASCADE;
   DROP TABLE IF EXISTS doctor_leave CASCADE;
   DROP TABLE IF EXISTS doctor_special_schedules CASCADE;
   DROP TABLE IF EXISTS doctor_schedules CASCADE;
   DROP TABLE IF EXISTS doctors CASCADE;
   DROP FUNCTION IF EXISTS generate_doctor_slots CASCADE;
   ```

4. **Verify Old System Works**
   - [ ] Application starts successfully
   - [ ] Old appointment APIs work
   - [ ] Data restored completely

---

## ✍️ Sign-off

### Development Team
- [ ] Migration executed successfully
- [ ] All tests passed
- [ ] Documentation updated

**Developer:** _________________ **Date:** _________

### QA Team
- [ ] Functional testing completed
- [ ] Edge cases validated
- [ ] No critical bugs found

**QA Engineer:** _________________ **Date:** _________

### Product Owner
- [ ] Business requirements met
- [ ] User acceptance testing passed
- [ ] Approved for production

**Product Owner:** _________________ **Date:** _________

---

## 📚 References

- Full API Documentation: `DOCTOR_SCHEDULE_API_GUIDE.md`
- Testing Guide: `TESTING_DOCTOR_API.md`
- Database Design: `DATABASE_DESIGN.md`
- Postman Collection: `Doctor_Schedule_API.postman_collection.json`
- Migration Scripts: 
  - `db/migration/V3__create_doctor_schedule_system.sql`
  - `db/migration/V4__seed_doctor_data.sql`

---

**Notes:**
- Keep this checklist for audit purposes
- Update status in real-time during migration
- Document any deviations from expected results
- Share with team for visibility

**Last Updated:** [Current Date]
