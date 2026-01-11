# Giải Thích Cơ Chế Niềm Tin & Trách Nhiệm Kỹ Thuật (Verification Trust Model)

## 1. Vấn Đề (Problem Statement)
Trong hệ thống xác thực, người kiểm tra (End-User như Hải quan, Bảo vệ...) thường chỉ quan tâm đến kết quả cuối cùng: **"Màn hình hiện màu Xanh (Hợp lệ) hay Đỏ (Không hợp lệ)?"** để ra quyết định nhanh chóng.

Tuy nhiên, sự đơn giản về mặt giao diện này đặt ra một câu hỏi lớn về bảo mật:
> *"Làm sao đảm bảo cái 'Màu Xanh' đó là sự thật, không phải là kết quả của việc làm giả web, hack hệ thống, hay lỗi logic phần mềm?"*

Tài liệu này giải thích vai trò cốt lõi của **Developer** trong việc kiến tạo niềm tin đằng sau giao diện người dùng.

## 2. Các Tầng Bảo Vệ Của "Màu Xanh" (The Layers of Trust)

Để một kết quả **CHECKED / VALID** được hiện lên màn hình, hệ thống phải vượt qua 3 tầng bảo vệ nghiêm ngặt do Developer xây dựng:

### Tầng 1: Tính Toàn Vẹn Dữ Liệu (Data Integrity)
Đảm bảo dữ liệu không bị ai sửa đổi kể từ lúc bác sĩ ký tên.
*   **Logic:** Frontend không tự quyết định đúng sai. Nó gửi Hash về Backend.
*   **Check 1:** Backend tìm kiếm Hash trên **IPFS**. Nếu không thấy $\to$ **FAKE**.
*   **Check 2:** Backend đối chiếu Hash đó với **Smart Contract trên Blockchain**. Nếu Hash trên Blockchain khác với Hash hiện tại (tức là file đã bị sửa đổi dù chỉ 1 dấu chấm) $\to$ **INVALID**.
*   **Check 3:** Kiểm tra **Chữ ký số (Digital Signature)**. Có phải đúng là bác sĩ A ký không? Hay là ông B mạo danh?

### Tầng 2: Chống Giả Mạo Giao Diện (Anti-Spoofing)
Ngăn chặn kẻ xấu copy giao diện web để lừa đảo.
*   **Domain Security:** Hệ thống chỉ hoạt động trên domain chính chủ (`safevax.com`). QR Code được tạo ra chỉ trỏ về domain này.
*   **Dynamic UI Elements:** Giao diện chứa các phần tử động (như đồng hồ thời gian thực, animation `ping` nhấp nháy, hiệu ứng chuyển động). Những thứ này khó bị làm giả bằng một bức ảnh chụp màn hình (Screenshot) tĩnh.
*   **SSL/TLS:** Đảm bảo kết nối được mã hóa, không bị kẻ gian đứng giữa (Man-in-the-Middle) thay đổi nội dung trang web trước khi hiển thị.

### Tầng 3: Hiệu Năng & Độ Sẵn Sàng (Performance & Availability)
Đảm bảo hệ thống luôn trả lời ngay lập tức.
*   **Tốc độ:** Nếu API query chậm (> 5s), người kiểm tra sẽ mất kiên nhẫn và bỏ qua quy trình. Dev phải tối ưu Database Indexing và Cache để phản hồi dưới **500ms**.
*   **Độ ổn định:** Hệ thống phải chịu tải được hàng nghìn lượt quét cùng lúc tại sân bay mà không sập (Scalability).

## 3. Trách Nhiệm Của Developer

| Vai Trò | Góc Nhìn & Hành Động | Trách Nhiệm Kỹ Thuật (Dev) |
| :--- | :--- | :--- |
| **Hải Quan** | "Thấy Xanh là cho qua." | Không cần biết code. Chỉ cần tin tưởng hệ thống. |
| **Developer** | "Làm sao để cái màu Xanh đó không thể bị mua chuộc." | 1. Code logic xác thực Cryptography chính xác.<br>2. Ngăn chặn SQL Injection/XSS.<br>3. Tối ưu hạ tầng Server.<br>4. Bảo mật Private Key của hệ thống. |

## 4. Kết Luận
Cái "Màu Xanh" trên màn hình Verification Portal giống như **tờ tiền Polymer**.
*   Người dân chỉ cần nhìn thấy tờ tiền là tiêu.
*   Nhưng để tờ tiền đó có giá trị và không bị làm giả, **Người làm ra nó (Developer)** phải tích hợp hàng loạt công nghệ in ấn, bảo mật, hình chìm phức tạp bên trong.

> **Developer không chỉ "hiển thị dữ liệu", Developer là người "bảo chứng cho sự thật".**

---
*Tài liệu giải thích kỹ thuật - SafeVax Team*
