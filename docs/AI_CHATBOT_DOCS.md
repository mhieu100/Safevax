# Tài liệu triển khai AI Chatbot cho SafeVax

## 1. Tổng quan
Tích hợp AI Chatbot sử dụng mô hình RAG (Retrieval-Augmented Generation) để trả lời các câu hỏi về tiêm chủng dựa trên dữ liệu đã được cung cấp. Hệ thống sử dụng Google Gemini (thông qua giao thức tương thích OpenAI) cho cả Embedding và Chat generation.

## 2. Backend (Spring Boot)

### 2.1. Cấu hình & Dependencies
- **Dependencies**: Sử dụng `spring-ai-openai-spring-boot-starter` và `spring-ai-pgvector-store-spring-boot-starter` để kết nối với AI và lưu trữ vector.
- **Cấu hình (`application.properties`)**:
  - Thiết lập `spring.ai.openai.base-url` trỏ về Google Gemini API (`https://generativelanguage.googleapis.com/v1beta/openai/`).
  - Cấu hình API Key và Model (`gemini-2.5-flash` cho chat, `gemini-embedding-001` cho embedding).
  - Cấu hình Vector Store (PGVector) để lưu trữ dữ liệu search.

### 2.2. Các thành phần chính
- **`RagController.java`**: Cung cấp các API RESTful:
  - `POST /api/rag/ingest`: Nạp dữ liệu văn bản vào hệ thống (tạo embedding và lưu vào vector DB).
  - `GET /api/rag/search`: Tìm kiếm các đoạn văn bản tương đồng.
  - `POST /api/rag/chat`: Chat với AI (kết hợp tìm kiếm context và sinh câu trả lời).
- **`RagService.java`**: Xử lý logic nghiệp vụ:
  - `addDocuments`: Chuyển đổi văn bản thành vector và lưu trữ.
  - `chat`: Thực hiện luồng RAG (Tìm kiếm context liên quan -> Tạo prompt -> Gửi cho AI -> Trả về kết quả).

### 2.3. Xử lý lỗi tương thích (Quan trọng)
- **Vấn đề**: Thư viện Spring AI mặc định mong đợi trường `usage` (thống kê token) trong phản hồi từ OpenAI API. Tuy nhiên, Google Gemini API (khi dùng qua OpenAI compatibility layer) đôi khi không trả về trường này, gây ra lỗi `NullPointerException` tại `OpenAiEmbeddingModel`.
- **Giải pháp**: Tạo class **`GeminiEmbeddingModel.java`** (đánh dấu `@Primary`) để thay thế implementation mặc định.
  - Class này sử dụng `RestClient` để gọi trực tiếp API embedding.
  - Xử lý phản hồi JSON thủ công và an toàn, bỏ qua việc đọc trường `usage` nếu nó không tồn tại, giúp tránh lỗi NPE.

## 3. Frontend (ReactJS)

### 3.1. Giao diện (`ChatBot.jsx`)
- Xây dựng component ChatBot nổi (floating button) ở góc dưới bên phải màn hình.
- Giao diện bao gồm:
  - Header với trạng thái online và nút đóng/mở.
  - Khu vực hiển thị tin nhắn (tự động cuộn xuống tin nhắn mới nhất).
  - Input nhập liệu và nút gửi.
  - Hiệu ứng loading (spinner) khi chờ AI trả lời.

### 3.2. Tích hợp API (`rag.service.js`)
- Service gọi API `/api/rag/chat` từ backend.
- **Lưu ý**: Đã sửa lỗi xử lý response trong service. Do `apiClient` đã tự động lấy `response.data`, nên service chỉ cần trả về kết quả trực tiếp thay vì truy cập lại vào `.data` (gây lỗi `undefined`).

## 4. Luồng hoạt động (RAG Workflow)
1. **Ingest (Nạp dữ liệu)**: Admin nạp tài liệu kiến thức (về vaccine, lịch tiêm, tác dụng phụ...) vào hệ thống. Hệ thống tạo vector embedding cho các đoạn văn bản này và lưu vào PostgreSQL (PGVector).
2. **User Query (Người dùng hỏi)**: Người dùng đặt câu hỏi qua giao diện ChatBot trên Frontend.
3. **Retrieval (Truy vấn)**: Backend nhận câu hỏi, tạo embedding cho câu hỏi đó, và tìm kiếm các đoạn văn bản có vector tương đồng nhất (cosine distance) trong database.
4. **Generation (Sinh câu trả lời)**: Backend ghép câu hỏi của người dùng + các đoạn văn bản tìm được (context) vào một System Prompt. Prompt này được gửi tới Google Gemini AI.
5. **Response (Phản hồi)**: Gemini AI tổng hợp thông tin từ context để trả lời câu hỏi. Kết quả được trả về cho Frontend hiển thị.

---
*Tài liệu được cập nhật ngày 04/12/2025*
