-- ========================================
-- MOCK DATA: Appointments với các status khác nhau
-- KHÔNG mock: users, family_members, vaccine_records, patients (liên quan blockchain)
-- Chạy sau khi đã có users, vaccines, centers, doctors, patients
-- Giả sử patients đã tồn tại với user_id: 1, 2, 3, 5, 6
-- ========================================

-- ========================
-- Bảng: vaccination_courses (liệu trình tiêm chủng)
-- Status: ONGOING, COMPLETED, CANCELLED
-- ========================
INSERT INTO vaccination_courses (
    id, patient_id, family_member_id, vaccine_id, status,
    current_dose_index, start_date, end_date,
    created_at, updated_at, is_deleted
) VALUES
-- Course 1: Patient 1 - Vaccine Hexaxim (id=12)
(1, 1, NULL, 12, 'ONGOING', 2, '2024-06-15 08:00:00', NULL,
 NOW(), NOW(), false),

-- Course 2: Patient 2 - Vaccine Cúm (id=23)
(2, 2, NULL, 23, 'ONGOING', 1, '2024-10-01 10:00:00', NULL,
 NOW(), NOW(), false),

-- Course 3: Patient 3 - Vaccine Viêm gan B (id=30)
(3, 3, NULL, 30, 'ONGOING', 2, '2024-05-20 14:00:00', NULL,
 NOW(), NOW(), false),

-- Course 4: Patient 4 - Vaccine COVID (id=27)
(4, 4, NULL, 27, 'ONGOING', 1, '2024-11-15 08:00:00', NULL,
 NOW(), NOW(), false),

-- Course 5: Patient 5 - Vaccine Thương hàn (id=44)
(5, 5, NULL, 44, 'ONGOING', 1, '2024-12-01 10:00:00', NULL,
 NOW(), NOW(), false)
ON CONFLICT (id) DO NOTHING;

SELECT setval('vaccination_courses_id_seq', (SELECT COALESCE(MAX(id), 0) FROM vaccination_courses));

-- ========================
-- Bảng: doctor_available_slots
-- Doctor user_ids từ doctors: 1, 2, 3, 5, 6, 7, 8, 10, 11, 12
-- ========================
INSERT INTO doctor_available_slots (
    slot_id, doctor_id, slot_date, start_time, end_time, status, notes, appointment_id,
    created_at, updated_at, is_deleted
) VALUES
-- Slots cho Doctor 1 (user_id=1) - Hôm nay
(1, 1, CURRENT_DATE, '08:00:00', '08:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(2, 1, CURRENT_DATE, '08:30:00', '09:00:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(3, 1, CURRENT_DATE, '09:00:00', '09:30:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(4, 1, CURRENT_DATE, '09:30:00', '10:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(5, 1, CURRENT_DATE, '10:00:00', '10:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(6, 1, CURRENT_DATE, '14:00:00', '14:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(7, 1, CURRENT_DATE, '14:30:00', '15:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(8, 1, CURRENT_DATE, '15:00:00', '15:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),

-- Slots cho Doctor 2 (user_id=2)
(9, 2, CURRENT_DATE, '08:00:00', '08:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(10, 2, CURRENT_DATE, '08:30:00', '09:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(11, 2, CURRENT_DATE, '09:00:00', '09:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(12, 2, CURRENT_DATE, '09:30:00', '10:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(13, 2, CURRENT_DATE, '14:00:00', '14:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(14, 2, CURRENT_DATE, '14:30:00', '15:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),

-- Slots cho Doctor 3 (user_id=3)
(15, 3, CURRENT_DATE, '08:00:00', '08:30:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(16, 3, CURRENT_DATE, '08:30:00', '09:00:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(17, 3, CURRENT_DATE, '09:00:00', '09:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(18, 3, CURRENT_DATE, '14:00:00', '14:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(19, 3, CURRENT_DATE, '14:30:00', '15:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),

-- Slots cho ngày mai
(20, 1, CURRENT_DATE + INTERVAL '1 day', '08:00:00', '08:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(21, 1, CURRENT_DATE + INTERVAL '1 day', '08:30:00', '09:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(22, 1, CURRENT_DATE + INTERVAL '1 day', '09:00:00', '09:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(23, 2, CURRENT_DATE + INTERVAL '1 day', '08:00:00', '08:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),
(24, 2, CURRENT_DATE + INTERVAL '1 day', '08:30:00', '09:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(25, 3, CURRENT_DATE + INTERVAL '1 day', '09:00:00', '09:30:00', 'BOOKED', 'Slot đã đặt', NULL, NOW(), NOW(), false),

-- Slots cho tuần sau
(26, 1, CURRENT_DATE + INTERVAL '7 days', '08:00:00', '08:30:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(27, 1, CURRENT_DATE + INTERVAL '7 days', '08:30:00', '09:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(28, 2, CURRENT_DATE + INTERVAL '7 days', '14:00:00', '14:30:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(29, 3, CURRENT_DATE + INTERVAL '7 days', '09:00:00', '09:30:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false),
(30, 3, CURRENT_DATE + INTERVAL '7 days', '09:30:00', '10:00:00', 'AVAILABLE', NULL, NULL, NOW(), NOW(), false)
ON CONFLICT (slot_id) DO NOTHING;

SELECT setval('doctor_available_slots_slot_id_seq', (SELECT COALESCE(MAX(slot_id), 0) FROM doctor_available_slots));

-- ========================
-- Bảng: appointments
-- Status: INITIAL, PENDING, RESCHEDULE, SCHEDULED, CANCELLED (KHÔNG CÓ COMPLETED)
-- TimeSlotEnum: SLOT_07_00, SLOT_09_00, SLOT_11_00, SLOT_13_00, SLOT_15_00
-- Cashier user_ids: 4, 9, 15, 19, 24
-- Doctor user_ids: 1, 2, 3, 5, 6, 7, 8
-- Center IDs: 1-5
-- ========================
INSERT INTO appointments (
    id, patient_id, family_member_id, vaccine_id, course_id, total_amount,
    cashier_id, doctor_id, slot_id, center_id, dose_number,
    scheduled_date, scheduled_time_slot, actual_scheduled_time,
    desired_date, desired_time_slot, rescheduled_at, status, vaccination_date,
    created_at, updated_at, is_deleted
) VALUES

-- ======= STATUS: INITIAL (Mới tạo, chưa có thông tin đầy đủ) =======
(1, 1, NULL, 12, 1, 750000.0,
 NULL, NULL, NULL, 1, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '3 days', 'SLOT_07_00', NULL, 'INITIAL', NULL,
 NOW() - INTERVAL '1 hour', NOW(), false),

(2, 2, NULL, 23, 2, 350000.0,
 NULL, NULL, NULL, 2, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '5 days', 'SLOT_13_00', NULL, 'INITIAL', NULL,
 NOW() - INTERVAL '30 minutes', NOW(), false),

(3, 3, NULL, 30, 3, 280000.0,
 NULL, NULL, NULL, 3, 2,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '2 days', 'SLOT_09_00', NULL, 'INITIAL', NULL,
 NOW() - INTERVAL '2 hours', NOW(), false),

-- ======= STATUS: PENDING (Chờ xác nhận từ staff) =======
(4, 1, NULL, 27, NULL, 500000.0,
 4, NULL, NULL, 1, 1,
 NULL, 'SLOT_07_00', NULL,
 CURRENT_DATE + INTERVAL '4 days', 'SLOT_07_00', NULL, 'PENDING', NULL,
 NOW() - INTERVAL '1 day', NOW(), false),

(5, 2, NULL, 44, NULL, 420000.0,
 9, NULL, NULL, 2, 1,
 NULL, 'SLOT_13_00', NULL,
 CURRENT_DATE + INTERVAL '6 days', 'SLOT_13_00', NULL, 'PENDING', NULL,
 NOW() - INTERVAL '12 hours', NOW(), false),

(6, 3, NULL, 12, 3, 750000.0,
 15, NULL, NULL, 3, 3,
 NULL, 'SLOT_09_00', NULL,
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_09_00', NULL, 'PENDING', NULL,
 NOW() - INTERVAL '6 hours', NOW(), false),

(7, 4, NULL, 23, 4, 350000.0,
 19, NULL, NULL, 4, 1,
 NULL, 'SLOT_15_00', NULL,
 CURRENT_DATE + INTERVAL '7 days', 'SLOT_15_00', NULL, 'PENDING', NULL,
 NOW() - INTERVAL '3 hours', NOW(), false),

(8, 5, NULL, 30, 5, 280000.0,
 24, NULL, NULL, 5, 1,
 NULL, 'SLOT_11_00', NULL,
 CURRENT_DATE + INTERVAL '8 days', 'SLOT_11_00', NULL, 'PENDING', NULL,
 NOW() - INTERVAL '4 hours', NOW(), false),

-- ======= STATUS: SCHEDULED (Đã xếp lịch, có slot và bác sĩ) =======
(9, 1, NULL, 12, 1, 750000.0,
 4, 1, 1, 1, 2,
 CURRENT_DATE, 'SLOT_07_00', '07:00:00',
 CURRENT_DATE, 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '2 days', NOW(), false),

(10, 2, NULL, 23, 2, 350000.0,
 9, 2, 9, 2, 1,
 CURRENT_DATE, 'SLOT_07_00', '07:00:00',
 CURRENT_DATE, 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '3 days', NOW(), false),

(11, 3, NULL, 30, 3, 280000.0,
 15, 3, 16, 3, 2,
 CURRENT_DATE, 'SLOT_07_00', '07:30:00',
 CURRENT_DATE, 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '4 days', NOW(), false),

(12, 4, NULL, 27, 4, 500000.0,
 19, 1, 2, 4, 1,
 CURRENT_DATE, 'SLOT_07_00', '07:30:00',
 CURRENT_DATE, 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '2 days', NOW(), false),

(13, 5, NULL, 44, 5, 420000.0,
 24, 2, 11, 5, 1,
 CURRENT_DATE, 'SLOT_09_00', '09:00:00',
 CURRENT_DATE, 'SLOT_09_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '1 day', NOW(), false),

-- SCHEDULED cho ngày mai
(14, 1, NULL, 23, NULL, 350000.0,
 4, 1, 20, 1, 1,
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_07_00', '07:00:00',
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '1 day', NOW(), false),

(15, 2, NULL, 27, NULL, 500000.0,
 9, 2, 23, 2, 1,
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_07_00', '07:00:00',
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_07_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '1 day', NOW(), false),

(16, 3, NULL, 44, NULL, 420000.0,
 15, 3, 25, 3, 1,
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_09_00', '09:00:00',
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_09_00', NULL, 'SCHEDULED', NULL,
 NOW() - INTERVAL '12 hours', NOW(), false),

-- ======= STATUS: RESCHEDULE (Yêu cầu đổi lịch) =======
(17, 1, NULL, 30, NULL, 280000.0,
 4, 1, 5, 1, 1,
 CURRENT_DATE, 'SLOT_09_00', '09:00:00',
 CURRENT_DATE + INTERVAL '3 days', 'SLOT_13_00', NOW() - INTERVAL '2 hours', 'RESCHEDULE', NULL,
 NOW() - INTERVAL '5 days', NOW(), false),

(18, 2, NULL, 12, NULL, 750000.0,
 9, 2, 13, 2, 1,
 CURRENT_DATE, 'SLOT_13_00', '13:00:00',
 CURRENT_DATE + INTERVAL '5 days', 'SLOT_09_00', NOW() - INTERVAL '1 hour', 'RESCHEDULE', NULL,
 NOW() - INTERVAL '4 days', NOW(), false),

(19, 3, NULL, 23, NULL, 350000.0,
 15, 3, 17, 3, 1,
 CURRENT_DATE, 'SLOT_09_00', '09:00:00',
 CURRENT_DATE + INTERVAL '2 days', 'SLOT_15_00', NOW() - INTERVAL '30 minutes', 'RESCHEDULE', NULL,
 NOW() - INTERVAL '3 days', NOW(), false),

(20, 4, NULL, 27, NULL, 500000.0,
 19, 1, 6, 4, 1,
 CURRENT_DATE, 'SLOT_13_00', '13:00:00',
 CURRENT_DATE + INTERVAL '4 days', 'SLOT_07_00', NOW() - INTERVAL '3 hours', 'RESCHEDULE', NULL,
 NOW() - INTERVAL '6 days', NOW(), false),

(21, 5, NULL, 44, NULL, 420000.0,
 24, 3, 18, 5, 1,
 CURRENT_DATE, 'SLOT_13_00', '13:00:00',
 CURRENT_DATE + INTERVAL '7 days', 'SLOT_15_00', NOW() - INTERVAL '4 hours', 'RESCHEDULE', NULL,
 NOW() - INTERVAL '7 days', NOW(), false),

-- ======= STATUS: CANCELLED (Đã hủy) =======
(22, 1, NULL, 44, NULL, 420000.0,
 4, 1, NULL, 1, 1,
 CURRENT_DATE - INTERVAL '5 days', 'SLOT_09_00', '09:00:00',
 CURRENT_DATE - INTERVAL '5 days', 'SLOT_09_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '10 days', NOW(), false),

(23, 2, NULL, 30, NULL, 280000.0,
 9, 2, NULL, 2, 1,
 CURRENT_DATE - INTERVAL '3 days', 'SLOT_13_00', '13:30:00',
 CURRENT_DATE - INTERVAL '3 days', 'SLOT_13_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '8 days', NOW(), false),

(24, 3, NULL, 12, NULL, 750000.0,
 15, 3, NULL, 3, 1,
 CURRENT_DATE - INTERVAL '7 days', 'SLOT_07_00', '07:00:00',
 CURRENT_DATE - INTERVAL '7 days', 'SLOT_07_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '12 days', NOW(), false),

(25, 4, NULL, 23, NULL, 350000.0,
 19, 1, NULL, 4, 1,
 CURRENT_DATE - INTERVAL '2 days', 'SLOT_15_00', '15:00:00',
 CURRENT_DATE - INTERVAL '2 days', 'SLOT_15_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '6 days', NOW(), false),

(26, 5, NULL, 27, NULL, 500000.0,
 24, 2, NULL, 5, 1,
 CURRENT_DATE - INTERVAL '4 days', 'SLOT_09_00', '09:00:00',
 CURRENT_DATE - INTERVAL '4 days', 'SLOT_09_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '9 days', NOW(), false),

-- Thêm các CANCELLED gần đây
(27, 1, NULL, 27, NULL, 500000.0,
 4, NULL, NULL, 1, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '1 day', 'SLOT_07_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '1 day', NOW(), false),

(28, 2, NULL, 44, NULL, 420000.0,
 9, NULL, NULL, 2, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '2 days', 'SLOT_13_00', NULL, 'CANCELLED', NULL,
 NOW() - INTERVAL '12 hours', NOW(), false),

-- Thêm INITIAL mới tạo
(29, 4, NULL, 30, NULL, 280000.0,
 NULL, NULL, NULL, 4, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '10 days', 'SLOT_11_00', NULL, 'INITIAL', NULL,
 NOW() - INTERVAL '15 minutes', NOW(), false),

(30, 5, NULL, 12, NULL, 750000.0,
 NULL, NULL, NULL, 5, 1,
 NULL, NULL, NULL,
 CURRENT_DATE + INTERVAL '14 days', 'SLOT_15_00', NULL, 'INITIAL', NULL,
 NOW() - INTERVAL '5 minutes', NOW(), false)

ON CONFLICT (id) DO NOTHING;

-- Reset sequence
SELECT setval('appointments_id_seq', (SELECT COALESCE(MAX(id), 0) FROM appointments));

-- ========================
-- Bảng: orders (đơn hàng vaccine)
-- ========================
INSERT INTO orders (
    order_id, user_id, total_amount, item_count, status, order_date,
    created_at, updated_at, is_deleted
) VALUES
-- Đơn hàng PENDING
(1, 1, 750000.0, 1, 'PENDING', NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour', NOW(), false),
(2, 2, 350000.0, 1, 'PENDING', NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours', NOW(), false),

-- Đơn hàng DELIVERED
(3, 3, 280000.0, 1, 'DELIVERED', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day', NOW(), false),
(4, 5, 500000.0, 1, 'DELIVERED', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days', NOW(), false),
(5, 6, 420000.0, 1, 'DELIVERED', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days', NOW(), false),

-- Đơn hàng CANCELLED
(6, 1, 350000.0, 1, 'CANCELLED', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days', NOW(), false),
(7, 2, 750000.0, 1, 'CANCELLED', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days', NOW(), false)
ON CONFLICT (order_id) DO NOTHING;

SELECT setval('orders_order_id_seq', (SELECT COALESCE(MAX(order_id), 0) FROM orders));

-- ========================
-- Bảng: order_items (chi tiết đơn hàng)
-- ========================
INSERT INTO order_items (
    id, order_id, vaccine_id, quantity,
    created_at, updated_at, is_deleted
) VALUES
(1, 1, 12, 1, NOW(), NOW(), false),
(2, 2, 23, 1, NOW(), NOW(), false),
(3, 3, 30, 1, NOW(), NOW(), false),
(4, 4, 27, 1, NOW(), NOW(), false),
(5, 5, 44, 1, NOW(), NOW(), false),
(6, 6, 23, 1, NOW(), NOW(), false),
(7, 7, 12, 1, NOW(), NOW(), false)
ON CONFLICT (id) DO NOTHING;

SELECT setval('order_items_id_seq', (SELECT COALESCE(MAX(id), 0) FROM order_items));

-- ========================
-- Bảng: payments (thanh toán)
-- ========================
INSERT INTO payments (
    id, reference_id, reference_type, method, amount, currency, status,
    created_at, updated_at, is_deleted
) VALUES
-- Payments cho appointments - INITIATED
(1, 4, 0, 2, 500000.0, 'VND', 0, NOW(), NOW(), false),
(2, 5, 0, 2, 420000.0, 'VND', 0, NOW(), NOW(), false),
(3, 6, 0, 3, 750000.0, 'VND', 0, NOW(), NOW(), false),

-- Payments cho appointments - SUCCESS
(4, 9, 0, 2, 750000.0, 'VND', 2, NOW() - INTERVAL '2 days', NOW(), false),
(5, 10, 0, 2, 350000.0, 'VND', 2, NOW() - INTERVAL '3 days', NOW(), false),
(6, 11, 0, 3, 280000.0, 'VND', 2, NOW() - INTERVAL '4 days', NOW(), false),
(7, 12, 0, 2, 500000.0, 'VND', 2, NOW() - INTERVAL '2 days', NOW(), false),
(8, 13, 0, 3, 420000.0, 'VND', 2, NOW() - INTERVAL '1 day', NOW(), false),

-- Payments cho appointments ngày mai - SUCCESS
(9, 14, 0, 2, 350000.0, 'VND', 2, NOW() - INTERVAL '1 day', NOW(), false),
(10, 15, 0, 2, 500000.0, 'VND', 2, NOW() - INTERVAL '1 day', NOW(), false),
(11, 16, 0, 3, 420000.0, 'VND', 2, NOW() - INTERVAL '12 hours', NOW(), false),

-- Payments FAILED
(12, 22, 0, 2, 420000.0, 'VND', 3, NOW() - INTERVAL '10 days', NOW(), false),
(13, 23, 0, 2, 280000.0, 'VND', 3, NOW() - INTERVAL '8 days', NOW(), false)
ON CONFLICT (id) DO NOTHING;

SELECT setval('payments_id_seq', (SELECT COALESCE(MAX(id), 0) FROM payments));

-- ========================
-- Bảng: carts (giỏ hàng)
-- ========================
INSERT INTO carts (
    id, user_id
) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 5),
(5, 6)
ON CONFLICT (id) DO NOTHING;

SELECT setval('carts_id_seq', (SELECT COALESCE(MAX(id), 0) FROM carts));

-- ========================
-- Bảng: cart_items (sản phẩm trong giỏ)
-- ========================
INSERT INTO cart_items (
    id, cart_id, vaccine_id, quantity
) VALUES
(1, 1, 27, 1),
(2, 1, 44, 2),
(3, 2, 12, 1),
(4, 3, 23, 1),
(5, 3, 30, 1),
(6, 4, 27, 1),
(7, 5, 44, 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('cart_items_id_seq', (SELECT COALESCE(MAX(id), 0) FROM cart_items));

-- ========================================
-- SUMMARY:
-- - vaccination_courses: 5 records
-- - doctor_available_slots: 30 records
-- - appointments: 30 records
--     + INITIAL: 5 (ID: 1, 2, 3, 29, 30)
--     + PENDING: 5 (ID: 4, 5, 6, 7, 8)
--     + SCHEDULED: 8 (ID: 9-16)
--     + RESCHEDULE: 5 (ID: 17-21)
--     + CANCELLED: 7 (ID: 22-28)
--     + COMPLETED: 0 (theo yêu cầu)
-- - orders: 7 records
-- - order_items: 7 records  
-- - payments: 13 records
-- - carts: 5 records
-- - cart_items: 7 records
-- 
-- KHÔNG MOCK: users, family_members, vaccine_records, patients
-- ========================================
