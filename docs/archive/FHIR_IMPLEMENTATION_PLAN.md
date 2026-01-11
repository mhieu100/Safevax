# Kế hoạch Triển khai FHIR (Fast Healthcare Interoperability Resources)

Tài liệu này tóm tắt lộ trình tích hợp chuẩn FHIR vào hệ thống SafeVax Blockchain hiện tại. Mục tiêu là nâng cao khả năng tương tác dữ liệu y tế mà không làm phá vỡ cấu trúc hiện có.

## 1. Chiến lược tiếp cận: FHIR Facade
Chúng ta sẽ không thay đổi cấu trúc Database hiện tại. Thay vào đó, chúng ta xây dựng một lớp "Mặt nạ" (Facade) để chuyển đổi dữ liệu từ Database nội bộ sang định dạng chuẩn FHIR khi có yêu cầu.

### Lợi ích:
*   **An toàn:** Không ảnh hưởng đến logic nghiệp vụ đang chạy.
*   **Tương thích:** Hệ thống có thể giao tiếp với các hệ thống y tế khác (Bệnh viện, CDC, WHO).
*   **Điểm nhấn đồ án:** Kết hợp **Blockchain + FHIR** (Lưu trữ bản ghi tiêm chủng chuẩn FHIR lên IPFS/Blockchain) tạo nên một hồ sơ y tế số vĩnh viễn, chuẩn hóa và phi tập trung.

## 2. Các bước triển khai

### Bước 1: Cài đặt thư viện (Dependencies)
Thêm thư viện **HAPI FHIR** (Java) vào dự án. Đây là thư viện phổ biến nhất để làm việc với FHIR trong môi trường Java.
*   **Artifact:** `hapi-fhir-structures-r4`
*   **Version:** `6.10.0` (Tương thích tốt với Java 17 & Spring Boot 3)

### Bước 2: Xây dựng lớp Mapping (Data Transformation)
Tạo các Mapper để chuyển đổi Entity của hệ thống sang FHIR Resource.
*   `User` + `Patient` (Entity) -> `Patient` (FHIR Resource)
*   `VaccineRecord` (Entity) -> `Immunization` (FHIR Resource)
*   `Appointment` (Entity) -> `Appointment` (FHIR Resource)

### Bước 3: Xây dựng API Endpoint (FHIR Gateway)
Tạo các Controller chuyên biệt để phục vụ dữ liệu chuẩn FHIR.
*   Endpoint: `/api/fhir/v1/Patient/{id}`
*   Endpoint: `/api/fhir/v1/Immunization?patient={id}`

### Bước 4: Tích hợp Blockchain (Nâng cao)
Khi lưu bản ghi tiêm chủng (`VaccineRecord`), hệ thống sẽ:
1.  Tạo đối tượng `Immunization` chuẩn FHIR.
2.  Chuyển đối tượng này thành chuỗi JSON.
3.  Lưu chuỗi JSON chuẩn này lên IPFS thay vì JSON tùy chỉnh.
4.  Lưu hash IPFS lên Smart Contract.

---

## 3. Thực hiện chi tiết

### 3.1. Cập nhật `pom.xml`
Đã thêm dependency `hapi-fhir-structures-r4`.

### 3.2. Tạo Mapper mẫu cho Patient
Đã tạo class `FhirPatientMapper` tại `com.dapp.backend.dto.mapper.fhir`.
Mapper này thực hiện:
*   Map `id` -> `Patient.id`
*   Map `fullName` -> `Patient.name`
*   Map `gender` -> `Patient.gender`
*   Map `birthday` -> `Patient.birthDate`
*   Map `phone`, `email` -> `Patient.telecom`
*   Map `address` -> `Patient.address`
