# Phân tích kỹ thuật: AI Chatbot tư vấn sức khỏe (RAG)

## 1. Giới thiệu
Tính năng **AI Tư vấn sức khỏe** sử dụng kỹ thuật **RAG (Retrieval-Augmented Generation)** nhằm cung cấp câu trả lời chính xác, đáng tin cậy dựa trên nguồn dữ liệu y khoa được kiểm chứng. Khác với Chatbot thông thường (chỉ dựa vào dữ liệu đã học của mô hình), RAG cho phép hệ thống tra cứu thông tin từ "Kho tri thức" (Knowledge Base) của riêng SafeVax trước khi trả lời.

## 2. Tại sao chọn RAG?
- **Độ chính xác cao**: Giảm thiểu "ảo giác" (hallucination) của AI bằng cách buộc mô hình chỉ trả lời dựa trên ngữ cảnh được cung cấp.
- **Dữ liệu cập nhật**: Có thể cập nhật thông tin mới (ví dụ: quy định tiêm chủng mới, vaccine mới về) mà không cần huấn luyện lại mô hình AI.
- **Dẫn chứng nguồn**: Có thể trích dẫn nguồn tài liệu (ví dụ: "Theo hướng dẫn của Bộ Y Tế ngày 12/2024...").

## 3. Kiến trúc hệ thống

### 3.1. Luồng dữ liệu (Data Ingestion Pipeline)
Đây là quy trình xử lý dữ liệu đầu vào (offline hoặc định kỳ):
1.  **Nguồn dữ liệu**: Tài liệu PDF hướng dẫn tiêm chủng, thông tin chi tiết vaccine (tờ hướng dẫn sử dụng), Q&A từ bác sĩ chuyên khoa.
2.  **Chunking**: Chia nhỏ văn bản thành các đoạn (chunks) có ý nghĩa (khoảng 500-1000 tokens).
3.  **Embedding**: Chuyển đổi các đoạn văn bản thành vector số học (vector embeddings) sử dụng mô hình Embedding (ví dụ: OpenAI `text-embedding-3-small`).
4.  **Vector Database**: Lưu trữ các vector này vào cơ sở dữ liệu để phục vụ tìm kiếm.

### 3.2. Luồng truy vấn (Retrieval & Generation)
Đây là quy trình khi người dùng đặt câu hỏi:
1.  **User Query**: Người dùng hỏi "Sau khi tiêm AstraZeneca có được uống thuốc giảm đau không?".
2.  **Query Embedding**: Chuyển câu hỏi thành vector.
3.  **Semantic Search**: Tìm kiếm trong Vector Database các đoạn văn bản (chunks) có nội dung tương đồng nhất với câu hỏi.
4.  **Prompt Construction**: Tạo prompt gửi cho LLM:
    ```text
    Bạn là trợ lý y tế ảo của SafeVax. Hãy trả lời câu hỏi dựa trên thông tin sau:
    [Thông tin tìm được 1]
    [Thông tin tìm được 2]
    
    Câu hỏi: Sau khi tiêm AstraZeneca có được uống thuốc giảm đau không?
    ```
5.  **LLM Generation**: Gửi prompt đến LLM (GPT-4o, Gemini) để sinh câu trả lời.
6.  **Response**: Hiển thị câu trả lời cho người dùng.

## 4. Đề xuất công nghệ (Tech Stack)

### Backend
- **Framework**: Spring Boot.
- **AI Integration**: **Spring AI** (Project mới của Spring, hỗ trợ rất tốt RAG) hoặc **LangChain4j**.
- **Vector Database**: Tận dụng **PostgreSQL** hiện có và cài thêm extension **`pgvector`**. Điều này giúp không phải quản lý thêm một DB riêng biệt (như Pinecone hay Milvus), tiết kiệm chi phí và dễ bảo trì.

### AI Models
- **Embedding Model**: OpenAI `text-embedding-3-small` (Rẻ, nhanh, hiệu quả cao) hoặc Google Gecko.
- **LLM**: OpenAI `gpt-4o-mini` (Cân bằng tốt giữa chi phí và trí thông minh) hoặc Google Gemini Flash.

## 5. Kế hoạch triển khai

### Giai đoạn 1: Chuẩn bị dữ liệu & Hạ tầng
- Cài đặt `pgvector` cho PostgreSQL.
- Thu thập 10-20 tài liệu chuẩn về các loại vaccine phổ biến.
- Viết script (Java) để đọc PDF -> Chunking -> Embedding -> Lưu vào DB.

### Giai đoạn 2: Phát triển API Chat
- Xây dựng API `/api/chat/message`.
- Tích hợp Spring AI để thực hiện luồng RAG.
- Xử lý ngữ cảnh hội thoại (lưu lịch sử chat ngắn hạn để AI hiểu câu hỏi nối tiếp).

### Giai đoạn 3: Frontend Integration
- Xây dựng UI Chat Widget (Floating button ở góc màn hình).
- Hiển thị hiệu ứng "Đang suy nghĩ..." và stream câu trả lời (gõ chữ từng từ).
- Hiển thị nguồn trích dẫn (nếu có).

## 6. Thách thức & Giải pháp
- **Bảo mật thông tin y tế**: Chatbot chỉ tư vấn thông tin chung, không đưa ra chẩn đoán cá nhân. Cần có Disclaimer (miễn trừ trách nhiệm) rõ ràng trước khi chat.
- **Chi phí**: Sử dụng các model nhỏ (mini/flash) và tối ưu hóa việc gọi API để tiết kiệm chi phí token.
