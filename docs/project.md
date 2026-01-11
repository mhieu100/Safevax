# Dự án SafeVax - Hệ Sinh Thái Tiêm Chủng Số

## 1. Tổng quan
SafeVax là nền tảng quản lý tiêm chủng toàn diện, kết hợp công nghệ **Blockchain** để xác thực dữ liệu và **AI** để hỗ trợ tư vấn người dùng. Hệ thống kết nối người dân với các cơ sở y tế thông qua quy trình đặt lịch và quản lý hồ sơ sức khỏe thông minh.

## 2. Tính Năng Đã Triển Khai (Implemented Features)

### 🔗 Blockchain & Vaccine Passport
- **Công nghệ:** Ethereum/Polygon + IPFS.
- **Chức năng:**
    - Lưu trữ hồ sơ tiêm chủng bất biến (Immutable Vaccine Records).
    - Định danh phi tập trung (DID) cho người dùng.
    - Xác thực nguồn gốc vắc-xin và quy trình tiêm chủng minh bạch.

### 🤖 AI Chatbot
- **Công nghệ:** RAG (Retrieval-Augmented Generation).
- **Chức năng:**
    - Tư vấn thông tin vắc-xin, phác đồ, và phản ứng phụ.
    - Hỗ trợ trả lời câu hỏi dựa trên ngữ cảnh người dùng.

### 📅 Smart Scheduling (Đặt Lịch Thông Minh)
- **Dynamic Dose Scheduling:** Tự động tính toán mũi tiêm tiếp theo ("Max Dose + 1").
- **Nhắc lịch tự động:** Gửi thông báo khi đến hạn mũi 2, 3 dựa trên phác đồ vắc-xin.
- **Quản lý lịch bác sĩ:** Hệ thống slots linh hoạt cho bác sĩ và trung tâm.

### 🏥 Vitals & Observation (Theo Dõi Sức Khỏe)
- Ghi nhận chỉ số sinh tồn (Chiều cao, Cân nặng, Huyết áp...) gắn liền với mũi tiêm.
- Theo dõi phản ứng sau tiêm chi tiết.
- Đồng bộ dữ liệu sức khỏe vào hồ sơ bệnh nhân.

### 📱 Đa Nền Tảng
- **Web App:** Dành cho Admin, Bác sĩ và Khách hàng (ReactJS).
- **Mobile App:** Dành cho Khách hàng cá nhân (Flutter).

---

## 3. Quy Trình Hoạt Động (Workflows)

### User Flow (Khách hàng):
1.  **Khám phá & Tư vấn:** Chat với AI để tìm hiểu vắc-xin.
2.  **Đặt lịch:** Chọn vắc-xin -> Hệ thống tự gợi ý mũi tiêm phù hợp -> Chọn Bác sĩ/Giờ.
3.  **Tiêm chủng:** Check-in -> Khám sàng lọc -> Tiêm.
4.  **Lưu hồ sơ:** Nhận Vaccine Record (Blockchain Verified) kèm thông tin Vitals.

### Doctor Flow (Bác sĩ):
1.  **Quản lý lịch:** Đăng ký lịch làm việc -> Hệ thống sinh slots.
2.  **Khám & Tiêm:** Xem hồ sơ bệnh nhân -> Thực hiện tiêm.
3.  **Ghi nhận:** Nhập kết quả, chỉ số sinh tồn và phản ứng sau tiêm -> Ký số lên Blockchain.

---

## 4. Kiến trúc Kỹ thuật (Tech Stack)

*   **Frontend Web:** React (Vite), Ant Design, TailwindCSS.
*   **Mobile App:** Flutter.
*   **Backend:** Java Spring Boot, Hibernate.
*   **Database:** PostgreSQL (Primary), Redis (Cache), IPFS (Metadata Storage).
*   **Blockchain:** Solidity Smart Contracts (Identity & Record Management).
*   **DevOps:** Docker.

---

## 5. Tài Liệu Tham Khảo Chi Tiết
*   [Kiến trúc Blockchain & IPFS](./BLOCKCHAIN_INTEGRATION.md)
*   [Thiết kế Database](./DATABASE_DESIGN.md)
*   [Hệ thống Đặt lịch](./SCHEDULING_AND_APPOINTMENTS.md)
*   [Theo dõi Sức khỏe](./VITALS_AND_OBSERVATION.md)
*   [Chiến lược Frontend](./FRONTEND_GUIDE.md)
