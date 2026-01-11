# 🏥 Theo Dõi Sức Khỏe & Chỉ Số Sinh Tồn (Vitals & Observation)

Tài liệu này mô tả tính năng ghi nhận và theo dõi sức khỏe bệnh nhân gắn liền với quy trình tiêm chủng.

## 1. Tổng Quan
Thay vì chỉ ghi nhận "Đã tiêm", hệ thống SafeVax yêu cầu bác sĩ ghi nhận chi tiết tình trạng sức khỏe của bệnh nhân tại thời điểm tiêm (Vitals) và phản ứng sau tiêm (Observation). Dữ liệu này được nhúng trực tiếp vào Hồ sơ tiêm chủng (`VaccineRecord`).

---

## 2. Quy Trình Ghi Nhận (Doctor Workflow)

Khi bác sĩ bấm "Hoàn thành" (Complete) một lịch hẹn, hệ thống sẽ kích hoạt một Wizard 3 bước:

### Bước 1: Chỉ Số Sinh Tồn (Vitals)
Bác sĩ nhập các chỉ số đo được tại chỗ:
*   **Cân nặng (Weight):** kg.
*   **Chiều cao (Height):** cm.
*   **Nhiệt độ (Temperature):** °C (Bắt buộc để check sốt).
*   **Nhịp tim (Pulse):** bpm.
*   **Huyết áp (Blood Pressure):** mmHg (Optional).

> **Lưu ý:** Cân nặng và Chiều cao sau khi nhập sẽ tự động đồng bộ ngược lại vào `Patient Profile` để cập nhật hồ sơ chung.

### Bước 2: Theo Dõi Phản Ứng (Observation)
Sau khi tiêm, bệnh nhân cần ngồi lại theo dõi 30 phút. Bác sĩ ghi nhận:
*   **Phản ứng:** Không có / Sưng đau nhẹ / Sốt / Dị ứng...
*   **Mức độ:** Nhẹ - Vừa - Nặng.
*   **Ghi chú:** Chi tiết xử lý (nếu có).

### Bước 3: Xác Nhận & Ký Số
*   Review lại toàn bộ thông tin.
*   Hệ thống tạo `VaccineRecord`.
*   Dữ liệu được băm (hash) và gửi lên Blockchain/IPFS ngay lập tức.

---

## 3. Cấu Trúc Dữ Liệu
Các trường dữ liệu được lưu trong bảng `vaccine_records`:

```java
// Vitals
Double weight;       // Cân nặng
Double height;       // Chiều cao
Double temperature;  // Nhiệt độ
Integer pulse;       // Nhịp tim

// Observation
String adverseReactions; // JSON hoặc Text mô tả phản ứng
String notes;            // Ghi chú y khoa
```

## 4. Hiển Thị Trên Frontend
*   **Biểu đồ sức khỏe:** Tại Dashboard của bệnh nhân, hệ thống vẽ biểu đồ biến thiên Cân nặng/Chiều cao theo thời gian dựa trên các điểm dữ liệu từ lịch sử tiêm chủng.
*   **Cảnh báo:** Nếu Nhiệt độ > 37.5°C hoặc Nhịp tim bất thường, hệ thống highlight trong hồ sơ để bác sĩ lần sau chú ý.
