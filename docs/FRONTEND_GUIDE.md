# 🎨 Frontend UX & Chiến Lược Giao Diện

Tài liệu này định hướng trải nghiệm người dùng (UX) cho ứng dụng SafeVax, chuyển đổi từ "Quản lý dữ liệu" sang "Quản lý hành trình sức khỏe".

## 1. Triết Lý Thiết Kế (Design Philosophy)
*   **User-Centric Journey:** Người dùng không quan tâm đến "Database record", họ quan tâm đến việc "Khi nào cần tiêm mũi tiếp theo?".
*   **Proactive (Chủ động):** Hệ thống phải nhắc người dùng, không đợi người dùng tự nhớ.
*   **Visual Trust:** Giao diện phải chuyên nghiệp, clean, tạo cảm giác an toàn y tế.

---

## 2. Các Tính Năng Frontend Chính

### 2.1. Dashboard & Smart Reminder
*   **Widget Nhắc Lịch:** Hiển thị nổi bật ngay trang chủ.
    *   *Logic:* Dựa trên `VaccineRecord` gần nhất + khoảng cách mũi (`days_between_doses`).
    *   *Ví dụ:* "Đã đến hạn tiêm Mũi 2 Viêm Gan B. Đặt lịch ngay!"
*   **Nút Fast Booking:** Từ thông báo nhắc lịch, bấm 1 nút sẽ dẫn đến trang Booking điền sẵn thông tin (Vắc-xin, Mũi số 2).

### 2.2. Hồ Sơ Sức Khỏe (My Records) (Refactored)

Được chia làm 2 Tabs chính:

#### A. Tab "Tiến Độ Tiêm Chủng" (Vaccination Progress) - **Mới**
Hiển thị dạng **Timeline/Steps** cho từng loại vắc-xin đang theo đuổi (`VaccinationCourse`).

*   **UI:**
    ```
    [ Vắc-xin COVID-19 ]
    (✓ Mũi 1: Completed) ---> (○ Mũi 2: Cần tiêm) ---> (🔒 Mũi 3)
    ```
*   **Mục đích:** Giúp người dùng hình dung lộ trình dài hạn.

#### B. Tab "Lịch Sử Chi Tiết" (History)
Hiển thị danh sách dạng bảng (Table) các giao dịch/mũi tiêm đã hoàn thành. Chứa thông tin chi tiết: Ngày giờ, Bác sĩ, Số lô, Phản ứng.

### 2.3. Booking Flow (Luồng Đặt Lịch)
*   Form đặt lịch thông minh tự động phát hiện mũi tiêm tiếp theo.
*   Hiển thị Badge: "Bạn đang đăng ký Mũi [X]".
*   Cảnh báo nếu người dùng cố tình chọn sai mũi hoặc khoảng cách giữa các mũi chưa đủ.

---

## 3. Công Nghệ & Thư Viện
*   **Framework:** React (Vite) / Flutter (Mobile).
*   **UI Library:** Ant Design (Web) / Material (Mobile).
*   **Charts:** Chart.js / Recharts (Cho biểu đồ sức khỏe).
*   **State Management:** Redux Toolkit / React Query.
