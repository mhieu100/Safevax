# Doctor Schedule Enhancement Guide

## Tổng Quan

Hiện tại hệ thống sử dụng **default working hours (7:00 - 17:00)** cho tất cả bác sĩ và tất cả các ngày trong tuần. Document này hướng dẫn cách implement tính năng **custom doctor schedules** để mỗi bác sĩ có thể có lịch làm việc riêng.

## Database Schema (Đã Có Sẵn)

Bảng `doctor_schedules` đã được tạo với structure:

```sql
CREATE TABLE doctor_schedules (
    schedule_id BIGSERIAL PRIMARY KEY,
    doctor_id BIGINT NOT NULL REFERENCES doctors(doctor_id),
    day_of_week INT NOT NULL,  -- 0=Sunday, 1=Monday, ..., 6=Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(doctor_id, day_of_week, start_time)
);

-- Index đã có
CREATE INDEX idx_schedule_doctor_day 
ON doctor_schedules(doctor_id, day_of_week, is_active);
```

## Use Cases

### 1. **Lịch Làm Việc Linh Hoạt**
```
Bác sĩ A:
- Thứ 2-5: 8:00 - 17:00
- Thứ 6: 8:00 - 12:00
- Thứ 7, CN: Nghỉ

Bác sĩ B:
- Thứ 2-6: 9:00 - 18:00
- Thứ 7: 9:00 - 14:00
- CN: Nghỉ
```

### 2. **Multiple Shifts (Ca Làm Việc)**
```
Bác sĩ C:
- Thứ 2-6:
  + Ca sáng: 7:00 - 12:00
  + Ca chiều: 13:00 - 17:00
```

### 3. **Ngày Nghỉ Cố Định**
```
Không có schedule record = Không tạo slots = Ngày nghỉ
```

## Implementation Steps

### Phase 1: Backend API (CRUD Operations)

#### 1.1 Create Schedule
```java
// DoctorScheduleController.java
@PostMapping("/doctors/{doctorId}/schedules")
public ResponseEntity<DoctorScheduleResponse> createSchedule(
    @PathVariable Long doctorId,
    @RequestBody CreateScheduleRequest request
) {
    return ResponseEntity.ok(doctorScheduleService.createSchedule(doctorId, request));
}
```

#### 1.2 Update Schedule
```java
@PutMapping("/doctors/{doctorId}/schedules/{scheduleId}")
public ResponseEntity<DoctorScheduleResponse> updateSchedule(
    @PathVariable Long doctorId,
    @PathVariable Long scheduleId,
    @RequestBody UpdateScheduleRequest request
) {
    return ResponseEntity.ok(doctorScheduleService.updateSchedule(scheduleId, request));
}
```

#### 1.3 Delete Schedule
```java
@DeleteMapping("/doctors/{doctorId}/schedules/{scheduleId}")
public ResponseEntity<Void> deleteSchedule(
    @PathVariable Long doctorId,
    @PathVariable Long scheduleId
) {
    doctorScheduleService.deleteSchedule(scheduleId);
    return ResponseEntity.noContent().build();
}
```

#### 1.4 Get All Schedules
```java
@GetMapping("/doctors/{doctorId}/schedules")
public ResponseEntity<List<DoctorScheduleResponse>> getSchedules(
    @PathVariable Long doctorId
) {
    return ResponseEntity.ok(doctorScheduleService.getDoctorSchedules(doctorId));
}
```

### Phase 2: Service Layer Logic

#### 2.1 Enable Custom Schedules in Virtual Slot Generation

Thay đổi trong `DoctorScheduleService.getDoctorSlotsInRange()`:

```java
// Current code (simplified - default 7:00-17:00)
LocalTime defaultStartTime = LocalTime.of(7, 0);
LocalTime defaultEndTime = LocalTime.of(17, 0);

// Enhanced code (use custom schedules)
List<DoctorSchedule> schedules = doctorScheduleRepository
    .findByDoctor_DoctorIdAndIsActiveTrue(doctor.getDoctorId());

Map<Integer, List<DoctorSchedule>> schedulesByDay = schedules.stream()
    .collect(Collectors.groupingBy(DoctorSchedule::getDayOfWeek));

while (!currentDate.isAfter(endDate)) {
    int dayOfWeek = currentDate.getDayOfWeek().getValue() % 7;
    
    // Get schedules for this day
    List<DoctorSchedule> daySchedules = schedulesByDay.getOrDefault(dayOfWeek, 
        Collections.emptyList());
    
    if (daySchedules.isEmpty()) {
        // No schedule = day off (skip this day)
        currentDate = currentDate.plusDays(1);
        continue;
    }
    
    // Generate slots for each shift
    for (DoctorSchedule schedule : daySchedules) {
        generateSlotsForShift(schedule, currentDate, ...);
    }
    
    currentDate = currentDate.plusDays(1);
}
```

#### 2.2 Validation Logic

```java
public void validateSchedule(CreateScheduleRequest request) {
    // 1. Check time range
    if (request.getEndTime().isBefore(request.getStartTime())) {
        throw new AppException("End time must be after start time");
    }
    
    // 2. Check overlap with existing schedules
    List<DoctorSchedule> existing = doctorScheduleRepository
        .findByDoctor_DoctorIdAndDayOfWeekAndIsActiveTrue(
            doctorId, request.getDayOfWeek());
    
    for (DoctorSchedule schedule : existing) {
        if (hasOverlap(schedule, request)) {
            throw new AppException("Schedule overlaps with existing schedule");
        }
    }
    
    // 3. Check reasonable working hours (7:00 - 22:00)
    if (request.getStartTime().isBefore(LocalTime.of(7, 0)) ||
        request.getEndTime().isAfter(LocalTime.of(22, 0))) {
        throw new AppException("Working hours must be between 7:00 and 22:00");
    }
}
```

### Phase 3: Frontend UI

#### 3.1 Schedule Management Page

**Route:** `/staff/doctor-schedule/manage`

**Features:**
- Weekly calendar view
- Drag-and-drop to create shifts
- Edit/Delete schedule entries
- Bulk operations (copy week, apply to multiple days)

**Component Structure:**
```jsx
<DoctorScheduleManager>
  <WeeklyCalendar />
  <ScheduleForm />
  <ScheduleList />
</DoctorScheduleManager>
```

#### 3.2 API Integration

```javascript
// services/doctor-schedule.service.js

export const createDoctorSchedule = (doctorId, schedule) => {
  return apiClient.post(`/api/doctors/${doctorId}/schedules`, schedule);
};

export const updateDoctorSchedule = (doctorId, scheduleId, schedule) => {
  return apiClient.put(`/api/doctors/${doctorId}/schedules/${scheduleId}`, schedule);
};

export const deleteDoctorSchedule = (doctorId, scheduleId) => {
  return apiClient.delete(`/api/doctors/${doctorId}/schedules/${scheduleId}`);
};

export const getDoctorSchedules = (doctorId) => {
  return apiClient.get(`/api/doctors/${doctorId}/schedules`);
};
```

#### 3.3 UI Components

**ScheduleForm.jsx:**
```jsx
const ScheduleForm = ({ doctorId, onSuccess }) => {
  const [form] = Form.useForm();
  
  const dayOptions = [
    { label: 'Monday', value: 1 },
    { label: 'Tuesday', value: 2 },
    { label: 'Wednesday', value: 3 },
    { label: 'Thursday', value: 4 },
    { label: 'Friday', value: 5 },
    { label: 'Saturday', value: 6 },
    { label: 'Sunday', value: 0 },
  ];
  
  return (
    <Form form={form} onFinish={handleSubmit}>
      <Form.Item name="dayOfWeek" label="Day" rules={[{ required: true }]}>
        <Select options={dayOptions} />
      </Form.Item>
      
      <Form.Item name="startTime" label="Start Time" rules={[{ required: true }]}>
        <TimePicker format="HH:mm" />
      </Form.Item>
      
      <Form.Item name="endTime" label="End Time" rules={[{ required: true }]}>
        <TimePicker format="HH:mm" />
      </Form.Item>
      
      <Button type="primary" htmlType="submit">
        Create Schedule
      </Button>
    </Form>
  );
};
```

**WeeklyCalendar.jsx:**
```jsx
const WeeklyCalendar = ({ schedules, onEdit, onDelete }) => {
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  return (
    <div className="weekly-calendar">
      {days.map((day, index) => (
        <div key={index} className="day-column">
          <h3>{day}</h3>
          {schedules
            .filter(s => s.dayOfWeek === index)
            .map(schedule => (
              <ScheduleCard
                key={schedule.id}
                schedule={schedule}
                onEdit={() => onEdit(schedule)}
                onDelete={() => onDelete(schedule.id)}
              />
            ))}
        </div>
      ))}
    </div>
  );
};
```

### Phase 4: Migration & Data Setup

#### 4.1 Sample Data Migration (Optional)

```sql
-- V1000__insert_default_schedules.sql

-- Default schedule for all doctors (Mon-Fri: 8:00-17:00)
INSERT INTO doctor_schedules (doctor_id, day_of_week, start_time, end_time, is_active)
SELECT 
    d.doctor_id,
    dow.day_num,
    '08:00:00'::TIME,
    '17:00:00'::TIME,
    true
FROM doctors d
CROSS JOIN (
    SELECT 1 AS day_num  -- Monday
    UNION ALL SELECT 2   -- Tuesday
    UNION ALL SELECT 3   -- Wednesday
    UNION ALL SELECT 4   -- Thursday
    UNION ALL SELECT 5   -- Friday
) dow
WHERE NOT EXISTS (
    SELECT 1 FROM doctor_schedules ds 
    WHERE ds.doctor_id = d.doctor_id
);
```

#### 4.2 Bulk Import Tool

```java
@PostMapping("/admin/schedules/bulk-import")
public ResponseEntity<BulkImportResult> bulkImportSchedules(
    @RequestBody List<ScheduleImportDto> schedules
) {
    return ResponseEntity.ok(adminService.bulkImportSchedules(schedules));
}
```

## Testing Strategy

### Unit Tests

```java
@Test
void testVirtualSlotGenerationWithCustomSchedule() {
    // Setup
    Doctor doctor = createTestDoctor();
    
    // Monday: 8:00-12:00, 13:00-17:00 (2 shifts)
    DoctorSchedule morningShift = DoctorSchedule.builder()
        .doctorId(doctor.getId())
        .dayOfWeek(1)
        .startTime(LocalTime.of(8, 0))
        .endTime(LocalTime.of(12, 0))
        .build();
    
    DoctorSchedule afternoonShift = DoctorSchedule.builder()
        .doctorId(doctor.getId())
        .dayOfWeek(1)
        .startTime(LocalTime.of(13, 0))
        .endTime(LocalTime.of(17, 0))
        .build();
    
    when(scheduleRepository.findByDoctor_DoctorIdAndIsActiveTrue(doctor.getId()))
        .thenReturn(List.of(morningShift, afternoonShift));
    
    // Execute
    LocalDate monday = LocalDate.of(2025, 12, 8); // A Monday
    List<DoctorAvailableSlotResponse> slots = 
        service.getDoctorSlotsInRange(doctor, monday, monday);
    
    // Verify
    // Morning: 8:00-12:00 = 8 slots (30 min each)
    // Afternoon: 13:00-17:00 = 8 slots (30 min each)
    // Total: 16 slots
    assertEquals(16, slots.size());
    
    // Verify no slots between 12:00-13:00 (lunch break)
    assertTrue(slots.stream().noneMatch(s -> 
        s.getStartTime().equals(LocalTime.of(12, 0))));
}

@Test
void testDayOffWhenNoSchedule() {
    Doctor doctor = createTestDoctor();
    
    // Only Monday schedule
    DoctorSchedule mondayOnly = DoctorSchedule.builder()
        .dayOfWeek(1)
        .startTime(LocalTime.of(8, 0))
        .endTime(LocalTime.of(17, 0))
        .build();
    
    when(scheduleRepository.findByDoctor_DoctorIdAndIsActiveTrue(doctor.getId()))
        .thenReturn(List.of(mondayOnly));
    
    // Execute for Tuesday (day off)
    LocalDate tuesday = LocalDate.of(2025, 12, 9);
    List<DoctorAvailableSlotResponse> slots = 
        service.getDoctorSlotsInRange(doctor, tuesday, tuesday);
    
    // Verify: Should return empty (day off)
    assertTrue(slots.isEmpty());
}
```

### Integration Tests

```java
@Test
@Sql("/test-data/doctor-schedules.sql")
void testGetAvailableSlotsWithCustomSchedule() {
    // Given: Doctor has custom schedule in DB
    Long doctorId = 1L;
    LocalDate date = LocalDate.of(2025, 12, 8);
    
    // When
    ResponseEntity<List<DoctorAvailableSlotResponse>> response = 
        restTemplate.exchange(
            "/api/doctors/" + doctorId + "/slots?date=" + date,
            HttpMethod.GET,
            null,
            new ParameterizedTypeReference<>() {}
        );
    
    // Then
    assertEquals(HttpStatus.OK, response.getStatusCode());
    List<DoctorAvailableSlotResponse> slots = response.getBody();
    assertNotNull(slots);
    assertTrue(slots.size() > 0);
}
```

## Performance Considerations

### 1. Caching Strategy

```java
@Cacheable(value = "doctorSchedules", key = "#doctorId")
public List<DoctorSchedule> getCachedSchedules(Long doctorId) {
    return doctorScheduleRepository.findByDoctor_DoctorIdAndIsActiveTrue(doctorId);
}

// Clear cache when schedule updated
@CacheEvict(value = "doctorSchedules", key = "#doctorId")
public void updateSchedule(Long doctorId, ...) {
    // Update logic
}
```

### 2. Database Indexes (Already Created)

```sql
-- Already exists in V999__optimize_virtual_slots.sql
CREATE INDEX idx_schedule_doctor_day 
ON doctor_schedules(doctor_id, day_of_week, is_active);
```

### 3. Bulk Operations

Khi query schedules cho nhiều doctors (dashboard, center view):

```java
@Query("SELECT ds FROM DoctorSchedule ds " +
       "WHERE ds.doctor.doctorId IN :doctorIds " +
       "AND ds.isActive = true")
List<DoctorSchedule> findSchedulesByDoctorIds(@Param("doctorIds") List<Long> doctorIds);
```

## Migration Path

### Current State → Enhanced State

**Step 1: Enable Feature Flag**
```properties
# application.properties
feature.custom-schedules.enabled=false  # Default off
```

**Step 2: Gradual Rollout**
1. Deploy backend with feature flag OFF
2. Add UI for schedule management (hidden behind flag)
3. Test with selected doctors
4. Enable feature flag
5. Bulk import default schedules for all doctors
6. Announce feature to users

**Step 3: Monitoring**
- Track schedule creation/update events
- Monitor slot generation performance
- Alert on schedule conflicts

## Future Enhancements

### 1. Holiday Management
```sql
CREATE TABLE doctor_holidays (
    holiday_id BIGSERIAL PRIMARY KEY,
    doctor_id BIGINT REFERENCES doctors(doctor_id),
    holiday_date DATE NOT NULL,
    reason VARCHAR(255),
    UNIQUE(doctor_id, holiday_date)
);
```

### 2. Temporary Schedule Overrides
```sql
CREATE TABLE schedule_overrides (
    override_id BIGSERIAL PRIMARY KEY,
    doctor_id BIGINT REFERENCES doctors(doctor_id),
    override_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    is_available BOOLEAN DEFAULT false,  -- false = day off
    reason VARCHAR(255)
);
```

### 3. Schedule Templates
```sql
CREATE TABLE schedule_templates (
    template_id BIGSERIAL PRIMARY KEY,
    template_name VARCHAR(100),
    description TEXT
);

CREATE TABLE schedule_template_items (
    item_id BIGSERIAL PRIMARY KEY,
    template_id BIGINT REFERENCES schedule_templates(template_id),
    day_of_week INT,
    start_time TIME,
    end_time TIME
);
```

## References

- Current implementation: `DoctorScheduleService.java` line 289-350
- Virtual Time Slots docs: `VIRTUAL_TIME_SLOTS.md`
- Database optimization: `V999__optimize_virtual_slots.sql`

## Decision Log

### Why Default 7:00-17:00 Now?

**Reasons:**
1. **Simplicity**: Không cần maintain schedule data ban đầu
2. **Flexibility**: Có thể enable custom schedules sau khi business stabilized
3. **Performance**: Ít queries hơn (không query `doctor_schedules`)
4. **MVP Focus**: Focus vào core booking flow trước

### When to Enable Custom Schedules?

**Triggers:**
1. Users request flexible working hours
2. Need to support part-time doctors
3. Multi-center doctors with different schedules
4. Business requirement for shift management

---

**Last Updated:** December 3, 2025
**Status:** Not Implemented (Default 7:00-17:00 in use)
**Priority:** Medium (Future Enhancement)
