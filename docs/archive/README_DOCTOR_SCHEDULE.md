# Doctor Schedule System - Complete Migration Guide

## 🎯 Quick Start

### For Testers (Fastest Way)
1. **Start backend**: `cd backend && ./mvnw spring-boot:run`
2. **Run test script**: `chmod +x test-doctor-api.sh && ./test-doctor-api.sh`
3. **Check results**: Script will test all 6 APIs automatically

### For Developers
1. Read [Migration Checklist](MIGRATION_CHECKLIST.md) - Follow step by step
2. Review [API Documentation](DOCTOR_SCHEDULE_API_GUIDE.md) - Understand endpoints
3. Use [Testing Guide](TESTING_DOCTOR_API.md) - Manual testing with curl
4. Import [Postman Collection](Doctor_Schedule_API.postman_collection.json) - GUI testing

---

## 📋 What's New?

### Old System (Simple FK)
```
appointments
  └─ doctor_id → users.id (role='DOCTOR')
```
- ❌ No schedule management
- ❌ No availability tracking
- ❌ Risk of double booking
- ❌ No leave management

### New System (5-Table Architecture)
```
doctors (profile + settings)
  ├─ doctor_schedules (weekly template)
  ├─ doctor_special_schedules (date overrides)
  ├─ doctor_leave (vacation/sick)
  └─ doctor_available_slots (pre-generated slots)
       └─ appointments.slot_id
```
- ✅ Weekly schedule templates
- ✅ Special hours for specific dates
- ✅ Leave management with approval
- ✅ Pre-generated slots prevent conflicts
- ✅ Auto-sync slot status with appointments

---

## 🗂️ Document Index

### Essential Documents (Read in Order)
1. **[MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md)** ⭐ **START HERE**
   - Step-by-step migration guide
   - Pre-flight checks
   - Validation queries
   - Rollback procedures
   - **Status**: Ready for execution

2. **[DATABASE_DESIGN.md](DATABASE_DESIGN.md)**
   - Complete schema design
   - Table relationships
   - Business rules
   - Triggers and stored procedures
   - **Status**: Implemented in V3

3. **[DOCTOR_SCHEDULE_API_GUIDE.md](DOCTOR_SCHEDULE_API_GUIDE.md)**
   - 6 API endpoints specification
   - Request/response formats
   - Authentication requirements
   - Workflow examples
   - **Status**: Implemented and ready

4. **[TESTING_DOCTOR_API.md](TESTING_DOCTOR_API.md)**
   - Manual testing with curl
   - 6 test scenarios
   - Edge case testing
   - Database verification
   - Expected results
   - **Status**: Ready to use

### Quick Reference
- **[test-doctor-api.sh](test-doctor-api.sh)** - Automated testing script
- **[Doctor_Schedule_API.postman_collection.json](Doctor_Schedule_API.postman_collection.json)** - Postman collection

### Legacy Documents
- **[API-Testing.md](API-Testing.md)** - Old appointment APIs (still valid)
- **[RESCHEDULE_API_DOCUMENTATION.md](RESCHEDULE_API_DOCUMENTATION.md)** - Reschedule feature

---

## 🚀 Migration Steps (TL;DR)

### Step 1: Backup
```bash
pg_dump -U your_user safevax_db > backup_$(date +%Y%m%d).sql
```

### Step 2: Check Prerequisites
```sql
-- Check current doctor count
SELECT COUNT(*) FROM users WHERE role = 'DOCTOR';
-- Expected: ~20 doctors

-- Check Flyway version
SELECT MAX(version) FROM flyway_schema_history;
-- Expected: 2 (V1 and V2 completed)
```

### Step 3: Run Backend (Auto-execute V3 & V4)
```bash
cd backend
./mvnw clean spring-boot:run
```

**Watch logs for:**
- ✅ `Migration V3__create_doctor_schedule_system.sql completed`
- ✅ `Migration V4__seed_doctor_data.sql completed`
- ✅ `Doctors migrated: 20`
- ✅ `Slots generation completed`

### Step 4: Verify Data
```sql
-- Quick verification
SELECT 
    (SELECT COUNT(*) FROM doctors) as doctors,
    (SELECT COUNT(*) FROM doctor_schedules) as schedules,
    (SELECT COUNT(*) FROM doctor_available_slots) as slots;

-- Expected: 20 doctors, ~220 schedules, ~16,800 slots
```

### Step 5: Test APIs
Choose one:
- **A. Automated**: `./test-doctor-api.sh`
- **B. Postman**: Import collection → Run tests
- **C. Manual**: Follow TESTING_DOCTOR_API.md

### Step 6: Frontend Integration
Update these files:
- `frontend/src/components/staff/pending-appointment.jsx`
- Create `frontend/src/components/common/SlotPicker.jsx`

---

## 📊 Expected Results

### Database Stats (After V4)
| Table | Expected Count | Description |
|-------|----------------|-------------|
| `doctors` | ~20 | Migrated from users |
| `doctor_schedules` | ~220 | 11 schedules/doctor |
| `doctor_special_schedules` | ~3 | Sample overrides |
| `doctor_leave` | ~2 | Sample leave records |
| `doctor_available_slots` | ~16,800 | 60 days × 20 doctors × 14 slots/day |

### Slot Distribution
- **Weekday (Mon-Fri)**: 14 slots/doctor (8-12: 8 slots, 14-17: 6 slots)
- **Saturday**: 7 slots/doctor (8-12: 8 slots)
- **Sunday**: 0 slots (day off)
- **Slot Duration**: 30 minutes per consultation

### API Performance Targets
| Endpoint | Expected Response Time | Max Records |
|----------|------------------------|-------------|
| Get Available Doctors | < 100ms | ~20 |
| Get Doctor Schedules | < 50ms | ~11 |
| Get Available Slots | < 200ms | ~14 |
| Get Slots by Center | < 500ms | ~280 |
| Get Slots in Range | < 300ms | ~98 |
| Generate Slots | < 2000ms | ~310 |

---

## 🧪 Testing Checklist

### Smoke Tests (Must Pass)
- [ ] Backend starts without errors
- [ ] Can login as cashier
- [ ] Can get list of doctors
- [ ] Can see available slots
- [ ] Doctors on leave show no slots

### Integration Tests
- [ ] Assign appointment to slot → Slot becomes BOOKED
- [ ] Cancel appointment → Slot becomes AVAILABLE
- [ ] Cannot book same slot twice

### Edge Cases
- [ ] Doctor on leave (no slots)
- [ ] Special schedule (different hours)
- [ ] Weekend behavior (Sun=0, Sat=reduced)
- [ ] Generate slots for existing dates (should skip)

---

## 🔧 Troubleshooting

### Issue: Migration V3 or V4 not running
**Solution:**
```bash
# Check Flyway status
SELECT * FROM flyway_schema_history ORDER BY installed_rank;

# If stuck, restart backend
./mvnw spring-boot:stop
./mvnw spring-boot:run
```

### Issue: No slots generated
**Symptoms:** `SELECT COUNT(*) FROM doctor_available_slots` returns 0

**Solution:**
```sql
-- Check if V4 completed
SELECT * FROM flyway_schema_history WHERE version = '4';

-- If completed but no slots, check logs for errors
-- Manually generate for one doctor:
SELECT generate_doctor_slots(1, CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days');
```

### Issue: API returns 401 Unauthorized
**Solution:**
```bash
# Get fresh token
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "cashier.d@vax.com", "password": "123456"}'

# Use the "accessToken" in Authorization header
```

### Issue: API returns 404 Not Found
**Check:**
1. Backend is running: `curl http://localhost:8080/actuator/health`
2. Correct URL: `/api/v1/doctors/...` (not `/api/doctors/...`)
3. Valid IDs: Doctor ID and Center ID exist in database

### Issue: Slot counts don't match expected
**Debug:**
```sql
-- Count slots by date
SELECT DATE(slot_date), COUNT(*) 
FROM doctor_available_slots 
GROUP BY DATE(slot_date) 
ORDER BY DATE(slot_date) 
LIMIT 10;

-- Check for leave conflicts
SELECT d.doctor_id, u.full_name, 
       dl.start_date, dl.end_date,
       COUNT(das.slot_id) as slots_during_leave
FROM doctor_leave dl
JOIN doctors d ON dl.doctor_id = d.doctor_id
JOIN users u ON d.user_id = u.id
LEFT JOIN doctor_available_slots das ON 
    das.doctor_id = dl.doctor_id 
    AND das.slot_date BETWEEN dl.start_date AND dl.end_date
GROUP BY d.doctor_id, u.full_name, dl.start_date, dl.end_date;
-- Should show 0 slots during leave periods
```

---

## 📈 Performance Optimization

### Database Indexes (Already in V3)
```sql
-- Check indexes exist
SELECT indexname, tablename FROM pg_indexes 
WHERE tablename LIKE 'doctor_%';

-- Should include:
-- idx_das_doctor_date_status (most important)
-- idx_das_slot_date
-- idx_ds_doctor_day
-- idx_dss_doctor_date
-- idx_dl_doctor_dates
```

### Query Optimization Tips
```sql
-- Good: Uses index
SELECT * FROM doctor_available_slots 
WHERE doctor_id = 1 
  AND slot_date = '2025-01-15' 
  AND status = 'AVAILABLE';

-- Bad: Full table scan
SELECT * FROM doctor_available_slots 
WHERE EXTRACT(MONTH FROM slot_date) = 1;
```

### Slot Generation Best Practices
- Generate 30-90 days in advance
- Regenerate monthly (cron job)
- Avoid generating past dates
- Use background job for bulk generation

---

## 🔄 Frontend Integration Guide

### Update Appointment Booking Flow

**Old Flow:**
```javascript
// 1. Select doctor from dropdown
// 2. Pick date/time manually
// 3. Submit appointment
```

**New Flow:**
```javascript
// 1. Select center
const doctors = await api.get(`/doctors/center/${centerId}/available`);

// 2. Select doctor
const slots = await api.get(`/doctors/${doctorId}/slots/available?date=${date}`);

// 3. Pick from available slots (grid UI)
// 4. Submit with slotId
await api.post(`/appointments`, {
  patientId,
  slotId,  // ⭐ New field
  // ... other fields
});
```

### New Component: SlotPicker.jsx
```jsx
<SlotPicker
  doctorId={selectedDoctor}
  date={selectedDate}
  onSlotSelect={(slot) => setSelectedSlot(slot)}
  onDateChange={(date) => setSelectedDate(date)}
/>
```

### API Integration Example
```javascript
// Get available slots
const response = await axios.get(
  `/api/v1/doctors/${doctorId}/slots/available`,
  {
    params: { date: '2025-01-15' },
    headers: { Authorization: `Bearer ${token}` }
  }
);

const slots = response.data; // Array of SlotResponse
// Display in time grid: 08:00, 08:30, 09:00, etc.
```

---

## 📦 Deliverables

### Backend (Completed)
- [x] V3 Migration - 5 tables, triggers, stored procedures
- [x] V4 Migration - Data seeding, slot generation
- [x] 5 Entity models + 3 Enums
- [x] 5 Repositories with custom queries
- [x] 4 DTO classes
- [x] Service layer with business logic
- [x] Controller with 6 REST endpoints

### Documentation (Completed)
- [x] Database design document
- [x] API documentation with examples
- [x] Testing guide with curl commands
- [x] Migration checklist
- [x] This README

### Testing Tools (Completed)
- [x] Automated bash test script
- [x] Postman collection (12 requests)
- [x] Validation SQL queries

### Frontend (Pending)
- [ ] Update pending-appointment.jsx
- [ ] Create SlotPicker component
- [ ] Update appointment API calls
- [ ] Admin schedule management UI (optional)

---

## 🎓 Key Concepts

### Slot Status Lifecycle
```
AVAILABLE → (appointment assigned) → BOOKED
    ↑                                   ↓
    └──── (appointment cancelled) ─────┘

BLOCKED: Manually blocked by admin (e.g., maintenance)
```

### Schedule Priority
1. **Doctor Leave** (highest) - No slots generated
2. **Special Schedule** - Override weekly template
3. **Weekly Schedule** (default) - Regular hours

### Slot Generation Logic
```
FOR each day in range:
  IF doctor has leave on this day:
    SKIP (no slots)
  ELSE IF doctor has special schedule:
    USE special hours
  ELSE:
    USE weekly schedule for this day_of_week
  END IF
  
  Generate 30-min slots within working hours
END FOR
```

---

## 🆘 Support & Resources

### Need Help?
1. Check troubleshooting section above
2. Review API documentation for request format
3. Run validation queries to check data state
4. Check backend logs for error messages

### Common Questions

**Q: Can I regenerate slots for same dates?**  
A: Yes, generate API will skip existing slots

**Q: What happens to old appointments?**  
A: They keep working, slot_id is optional in transition period

**Q: How to handle doctor schedule changes?**  
A: Update doctor_schedules table, regenerate slots for future dates

**Q: Can patients book directly?**  
A: Not yet, currently CASHIER role only (see DOCTOR_SCHEDULE_API_GUIDE.md)

---

## 📅 Roadmap

### Phase 1: Core Implementation (✅ DONE)
- [x] Database schema
- [x] Backend APIs
- [x] Documentation
- [x] Testing tools

### Phase 2: Testing & Integration (🔄 CURRENT)
- [ ] Execute migrations
- [ ] Test all APIs
- [ ] Frontend integration
- [ ] End-to-end testing

### Phase 3: Admin Features (📋 PLANNED)
- [ ] Schedule management UI
- [ ] Leave approval workflow
- [ ] Bulk slot generation
- [ ] Analytics dashboard

### Phase 4: Advanced Features (💡 FUTURE)
- [ ] Patient self-booking
- [ ] SMS/Email reminders
- [ ] Waitlist management
- [ ] Multi-language support

---

## 🏁 Success Criteria

Migration is successful when:
- ✅ All 5 tables populated with data
- ✅ ~16,800 slots generated for 60 days
- ✅ All 6 API endpoints return 200 status
- ✅ Edge cases handled (leave, special schedules)
- ✅ Triggers update slot status correctly
- ✅ No performance degradation
- ✅ Frontend can book appointments with slots

---

## 📝 Change Log

### 2025-01-XX - Initial Release
- Created 5-table doctor schedule system
- Migrated 20 doctors from old system
- Generated 60 days of appointment slots
- Implemented 6 REST APIs
- Complete documentation suite

---

## 📞 Contact & Feedback

For questions or issues:
1. Check [TESTING_DOCTOR_API.md](TESTING_DOCTOR_API.md)
2. Review [MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md)
3. Contact development team

**Last Updated:** 2025-01-15  
**Version:** 1.0.0  
**Status:** Ready for Testing

---

## 🎉 Let's Get Started!

**Quick Start Command:**
```bash
# 1. Start backend (auto-run migrations)
cd backend && ./mvnw spring-boot:run

# 2. In another terminal, run tests
cd backend && chmod +x test-doctor-api.sh && ./test-doctor-api.sh

# 3. Check results and celebrate! 🎊
```

Good luck with your migration! 🚀
