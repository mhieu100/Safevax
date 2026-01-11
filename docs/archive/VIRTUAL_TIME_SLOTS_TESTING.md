# Hướng Dẫn Testing Virtual Time Slots

## Mục Đích
Document này hướng dẫn cách test và verify cơ chế Virtual Time Slots hoạt động đúng.

## Test Cases

### Test Case 1: Basic Virtual Slot Generation

**Setup:**
```sql
-- Tạo doctor với lịch cơ bản
INSERT INTO doctors (doctor_id, user_id, center_id, consultation_duration) 
VALUES (1, 100, 1, 30);

-- Không có slots trong DB
```

**Test:**
```bash
GET /api/v1/doctors/1/slots?startDate=2024-12-03&endDate=2024-12-03
```

**Expected Result:**
- Trả về 20 slots AVAILABLE (7:00-17:00, mỗi slot 30 phút)
- Tất cả đều có `slotId = null` (virtual)
- Status = AVAILABLE

### Test Case 2: Mixed Virtual + Real Slots

**Setup:**
```sql
-- Tạo 2 slots BOOKED trong DB
INSERT INTO doctor_available_slots 
(doctor_id, slot_date, start_time, end_time, status) 
VALUES 
(1, '2024-12-03', '08:00:00', '08:30:00', 'BOOKED'),
(1, '2024-12-03', '14:00:00', '14:30:00', 'BOOKED');
```

**Test:**
```bash
GET /api/v1/doctors/1/slots?startDate=2024-12-03&endDate=2024-12-03
```

**Expected Result:**
- Trả về 20 slots
- 18 slots AVAILABLE (virtual, slotId = null)
- 2 slots BOOKED (real, slotId != null)
- Slots được sort theo time

### Test Case 3: Custom Schedule

**Setup:**
```sql
-- Doctor có 2 shifts
INSERT INTO doctor_schedules 
(doctor_id, day_of_week, start_time, end_time, is_active) 
VALUES 
(1, 1, '07:00:00', '12:00:00', true),  -- Morning shift
(1, 1, '13:00:00', '17:00:00', true);  -- Afternoon shift
```

**Test:**
```bash
GET /api/v1/doctors/1/slots?startDate=2024-12-03&endDate=2024-12-03
```

**Expected Result:**
- Morning: 10 slots (7:00-12:00)
- Gap: Không có slot 12:00-13:00
- Afternoon: 8 slots (13:00-17:00)
- Total: 18 slots

### Test Case 4: Performance - Large Date Range

**Test:**
```bash
GET /api/v1/doctors/1/slots?startDate=2024-12-01&endDate=2025-02-28
```

**Expected Result:**
- Date range tự động limit về 90 ngày
- Warning log: "Date range too large"
- Response time < 500ms

### Test Case 5: Multiple Doctors (Batch Query)

**Setup:**
```sql
-- 10 doctors trong cùng center
INSERT INTO doctors (doctor_id, user_id, center_id) 
VALUES (1, 101, 1), (2, 102, 1), ..., (10, 110, 1);

-- Mỗi doctor có 2 slots BOOKED
```

**Test:**
```bash
GET /api/v1/doctors/center/1/slots/available?date=2024-12-03
```

**Metrics:**
- ✅ Chỉ 1 query để lấy tất cả real slots (không phải 10 queries)
- ✅ Response time < 1 second
- ✅ Memory usage < 50MB

**Verify:**
```sql
-- Check query count trong PostgreSQL log
-- Nên thấy 1 query với IN clause
SELECT ... WHERE doctor_id IN (1,2,3,...,10)
```

### Test Case 6: No Schedule Day

**Setup:**
```sql
-- Doctor không có schedule cho Chủ nhật (day_of_week = 0)
```

**Test:**
```bash
GET /api/v1/doctors/1/slots?startDate=2024-12-01&endDate=2024-12-01
-- 2024-12-01 là Chủ nhật
```

**Expected Result:**
- Trả về slots với default schedule (7:00-17:00)
- 20 slots AVAILABLE

### Test Case 7: Edge Cases

#### 7a. Slot Duration > Time Range
```sql
-- Doctor có consultation_duration = 120 phút
-- Schedule: 08:00 - 09:00 (chỉ 60 phút)
```

**Expected:** Không tạo slot nào (endTime > schedule.endTime)

#### 7b. Midnight Crossing
```sql
-- Schedule: 23:00 - 01:00 (cross midnight)
```

**Expected:** Chỉ generate slots đến 23:59

#### 7c. Same Time Slots (Conflict)
```sql
-- 2 slots cùng doctor, date, time
INSERT INTO doctor_available_slots VALUES 
(1, '2024-12-03', '08:00', 'BOOKED'),
(2, '2024-12-03', '08:00', 'BLOCKED');
```

**Expected:** 
- Log warning về duplicate
- Giữ slot đầu tiên (BOOKED)

## Performance Benchmarks

### Baseline Metrics

| Scenario | Doctors | Days | Expected Time | Max Memory |
|----------|---------|------|---------------|------------|
| Single doctor, 1 day | 1 | 1 | < 50ms | < 10MB |
| Single doctor, 7 days | 1 | 7 | < 100ms | < 20MB |
| Single doctor, 30 days | 1 | 30 | < 300ms | < 50MB |
| 10 doctors, 1 day | 10 | 1 | < 200ms | < 30MB |
| 50 doctors, 1 day | 50 | 1 | < 1s | < 100MB |

### Load Testing

**Tool:** JMeter hoặc Gatling

**Scenario 1: Concurrent Requests**
```
- Users: 100
- Ramp-up: 10s
- Loop: 10 times
- Request: GET /api/v1/doctors/1/slots?date=today
```

**Expected:**
- 95% requests < 500ms
- 0% errors
- No database connection pool exhaustion

**Scenario 2: Heavy Load**
```
- Users: 500
- Requests/second: 100
- Duration: 5 minutes
```

**Expected:**
- Average response time < 800ms
- Max response time < 2s
- Database CPU < 70%

## Manual Testing Checklist

### Functional Tests

- [ ] Virtual slots được tạo đúng theo working hours
- [ ] Real slots (BOOKED/BLOCKED) hiển thị đúng status
- [ ] Slots được sort đúng (date + time)
- [ ] Không có duplicate slots
- [ ] Filter theo timeSlot hoạt động đúng
- [ ] Multi-shift schedule generate đúng
- [ ] Consultation duration được áp dụng đúng

### Performance Tests

- [ ] Query chỉ lấy BOOKED/BLOCKED (không lấy AVAILABLE)
- [ ] Batch query cho multiple doctors (không N+1)
- [ ] Date range > 90 days được limit tự động
- [ ] Memory không leak khi query large range
- [ ] Response time đáp ứng yêu cầu

### Edge Cases

- [ ] Doctor không có schedule → dùng default
- [ ] Slot duration > available time → skip
- [ ] Empty result (no slots) → return []
- [ ] Invalid date range → validation error
- [ ] Doctor không tồn tại → 404 error

## Database Verification

### Query 1: Check Index Usage

```sql
EXPLAIN ANALYZE
SELECT * FROM doctor_available_slots 
WHERE doctor_id = 1 
  AND slot_date BETWEEN '2024-12-01' AND '2024-12-31'
  AND status IN ('BOOKED', 'BLOCKED')
ORDER BY slot_date, start_time;
```

**Expected:** 
- Index Scan on idx_slot_doctor_date_status
- Planning time < 1ms
- Execution time < 10ms

### Query 2: Verify No AVAILABLE Slots

```sql
SELECT status, COUNT(*) 
FROM doctor_available_slots 
GROUP BY status;
```

**Expected:**
```
status  | count
--------+-------
BOOKED  | 1234
BLOCKED | 56
```

Không có AVAILABLE!

### Query 3: Check Slot Overlaps

```sql
-- Tìm slots bị overlap (không nên có)
SELECT a.doctor_id, a.slot_date, 
       a.start_time as a_start, a.end_time as a_end,
       b.start_time as b_start, b.end_time as b_end
FROM doctor_available_slots a
JOIN doctor_available_slots b 
  ON a.doctor_id = b.doctor_id 
  AND a.slot_date = b.slot_date
  AND a.slot_id != b.slot_id
WHERE a.start_time < b.end_time 
  AND a.end_time > b.start_time;
```

**Expected:** 0 rows

## Monitoring in Production

### Key Metrics to Track

1. **API Response Time**
   ```
   - p50: < 100ms
   - p95: < 500ms
   - p99: < 1000ms
   ```

2. **Database Query Performance**
   ```
   - findDoctorSlotsInRange: < 10ms
   - findSlotsByDoctorIdsAndDateRange: < 50ms
   ```

3. **Error Rate**
   ```
   - < 0.1% errors
   - No timeout errors
   ```

4. **Memory Usage**
   ```
   - Heap usage < 70%
   - No memory leaks
   ```

### Alerts to Setup

- Response time > 2s for 5 minutes
- Error rate > 1% for 1 minute
- Database connection pool > 80% used
- Memory usage > 85%

## Debugging Tips

### Issue: Slots không hiển thị

**Debug steps:**
1. Check doctor schedule: `SELECT * FROM doctor_schedules WHERE doctor_id = ?`
2. Check doctor is_available: `SELECT is_available FROM doctors WHERE doctor_id = ?`
3. Check date range: Có nằm trong working days không?
4. Add logs:
   ```java
   log.debug("Schedules found: {}", schedules.size());
   log.debug("Virtual slots generated: {}", virtualCount);
   ```

### Issue: Performance chậm

**Debug steps:**
1. Check query execution plan: `EXPLAIN ANALYZE ...`
2. Verify index được sử dụng
3. Check date range: Có > 90 days không?
4. Profile code:
   ```java
   long start = System.currentTimeMillis();
   // ... code ...
   log.info("Execution time: {}ms", System.currentTimeMillis() - start);
   ```

### Issue: Duplicate slots

**Check:**
1. Có 2 schedules overlap không?
2. Có bug trong while loop không?
3. Verify slotMap key format

## Rollback Plan

Nếu có vấn đề với Virtual Slots:

**Step 1: Restore old data**
```sql
INSERT INTO doctor_available_slots 
SELECT * FROM doctor_available_slots_backup
WHERE status = 'AVAILABLE';
```

**Step 2: Deploy old code**
- Revert commit với Virtual Slots
- Deploy version cũ

**Step 3: Verify**
- Test endpoints
- Check slot availability

## Next Steps

Sau khi pass tất cả tests:

1. ✅ Deploy to staging
2. ✅ Monitor metrics for 24h
3. ✅ Get QA approval
4. ✅ Deploy to production
5. ✅ Monitor in production for 1 week
6. ✅ Clean up old AVAILABLE slots
7. ✅ Add check constraint
