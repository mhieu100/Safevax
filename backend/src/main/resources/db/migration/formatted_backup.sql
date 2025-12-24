-- ========================
-- Bảng: roles
-- ========================
INSERT INTO
    roles (id, name)
VALUES (1, 'ADMIN'),
    (2, 'PATIENT'),
    (3, 'DOCTOR'),
    (4, 'CASHIER');

-- ========================
-- Bảng: centers
-- ========================
INSERT INTO
    centers (
        center_id,
        address,
        capacity,
        image,
        name,
        phone_number,
        working_hours,
        updated_at,
        slug,
        created_at,
        is_deleted
    )
VALUES (
        1,
        '28-30 Mê Linh, P. Hải Vân, TP. Đà Nẵng',
        100,
        'https://vnvc.vn/wp-content/uploads/2023/08/vnvc-nam-o.jpg',
        'VNVC Nam Ô',
        '02871026595',
        '07:30 - 17:00',
        '2025-12-09 16:30:00.000000',
        'vnvc-nam-o',
        '2025-12-09 16:30:00.000000',
        false
    ),
    (
        2,
        '369 Điện Biên Phủ, P. Thanh Khê, TP. Đà Nẵng',
        150,
        'https://vnvc.vn/wp-content/uploads/2019/07/vnvc-da-nang.jpg',
        'VNVC Thanh Khê',
        '02871026595',
        '07:30 - 17:00',
        '2025-12-09 16:30:00.000000',
        'vnvc-thanh-khe',
        '2025-12-09 16:30:00.000000',
        false
    ),
    (
        3,
        '432-434-436 Cách Mạng Tháng 8, P. Hòa Thọ Đông, Q. Cẩm Lệ, TP. Đà Nẵng',
        120,
        'https://vnvc.vn/wp-content/uploads/2022/10/vnvc-cam-le-da-nang.jpg',
        'VNVC Cẩm Lệ',
        '02871026595',
        '07:30 - 17:00',
        '2025-12-09 16:30:00.000000',
        'vnvc-cam-le',
        '2025-12-09 16:30:00.000000',
        false
    ),
    (
        4,
        '161 Âu Cơ, P. Hòa Khánh Bắc, Q. Liên Chiểu, TP. Đà Nẵng',
        130,
        'https://vnvc.vn/wp-content/uploads/2021/11/vnvc-lien-chieu.jpg',
        'VNVC Liên Chiểu',
        '02871026595',
        '07:30 - 17:00',
        '2025-12-09 16:30:00.000000',
        'vnvc-lien-chieu',
        '2025-12-09 16:30:00.000000',
        false
    ),
    (
        5,
        '367 Lê Văn Hiến, P. Ngũ Hành Sơn, TP. Đà Nẵng',
        110,
        'https://vnvc.vn/wp-content/uploads/2022/05/vnvc-le-van-hien-da-nang.jpg',
        'VNVC Ngũ Hành Sơn',
        '02871026595',
        '07:30 - 17:00',
        '2025-12-09 16:30:00.000000',
        'vnvc-ngu-hanh-son',
        '2025-12-09 16:30:00.000000',
        false
    );

-- ========================
-- Bảng: news
-- ========================
INSERT INTO
    news (
        id,
        created_at,
        is_deleted,
        updated_at,
        author,
        category,
        content,
        cover_image,
        is_featured,
        is_published,
        published_at,
        short_description,
        slug,
        source,
        tags,
        thumbnail_image,
        title,
        view_count
    )
VALUES (
        1,
        '2025-11-16 16:40:24.953524',
        false,
        '2025-11-23 21:02:42.043207',
        'BS. Nguyễn Văn An',
        'HEALTH_GENERAL',
        '<h2>Giới thiệu</h2><p>Sức khỏe là tài sản quý giá nhất của con người. Dưới đây là 10 thói quen đơn giản bạn nên thực hiện hàng ngày.</p><h3>1. Uống đủ nước</h3><p>Uống ít nhất 2 lít nước mỗi ngày giúp cơ thể hoạt động tốt hơn.</p><h3>2. Tập thể dục đều đặn</h3><p>Ít nhất 30 phút mỗi ngày giúp cơ thể khỏe mạnh.</p><h3>3. Ngủ đủ giấc</h3><p>7-8 tiếng ngủ mỗi đêm rất quan trọng.</p><h3>4. Ăn nhiều rau xanh</h3><p>Bổ sung vitamin và chất xơ từ rau củ.</p><h3>5. Hạn chế đường và muối</h3><p>Giảm nguy cơ bệnh tim mạch và tiểu đường.</p>',
        '',
        false,
        true,
        NULL,
        'Khám phá 10 thói quen đơn giản nhưng hiệu quả giúp bạn duy trì sức khỏe tốt mỗi ngày',
        '10-thoi-quen-tot-cho-suc-khoe-moi-ngay',
        'Bộ Y tế',
        'sức khỏe,thói quen,phòng bệnh',
        'https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174669.jpg?semt=ais_hybrid&w=740&q=80',
        '10 Thói quen tốt cho sức khỏe mỗi ngày',
        150
    ),
    (
        2,
        '2025-11-17 16:40:26.686587',
        false,
        '2025-11-26 02:57:01.475661',
        'PGS.TS Trần Thị Hoa',
        'VACCINE_INFO',
        '<h2>Vaccine COVID-19 - Vũ khí chống đại dịch</h2><p>Vaccine COVID-19 đã được chứng minh là an toàn và hiệu quả trong việc phòng ngừa bệnh nặng và tử vong do COVID-19.</p><h3>Lợi ích cá nhân</h3><ul><li>Giảm nguy cơ mắc bệnh nặng</li><li>Giảm tỷ lệ tử vong</li><li>Giảm nguy cơ biến chứng sau COVID-19</li></ul><h3>Lợi ích cộng đồng</h3><ul><li>Giảm tốc độ lây lan</li><li>Bảo vệ người yếu thế</li><li>Phục hồi kinh tế xã hội</li></ul>',
        NULL,
        true,
        false,
        '2025-11-18 16:40:26.686587',
        'Vaccine COVID-19 không chỉ bảo vệ bản thân mà còn góp phần bảo vệ cộng đồng khỏi đại dịch',
        'loi-ich-cua-vaccine-covid-19',
        'Viện Vệ sinh Dịch tễ Trung ương',
        'covid-19,vaccine,phòng bệnh,cộng đồng',
        NULL,
        'Lợi ích của Vaccine COVID-19 đối với sức khỏe cộng đồng',
        320
    ),
    (
        3,
        '2025-11-15 16:40:28.52991',
        false,
        '2025-11-16 16:40:28.52991',
        'BS. Lê Văn Minh',
        'VACCINATION_SCHEDULE',
        '<h2>Lịch tiêm chủng mở rộng</h2><p>Chương trình tiêm chủng mở rộng là chương trình quốc gia nhằm bảo vệ trẻ em khỏi các bệnh truyền nhiễm nguy hiểm.</p><h3>Các mũi tiêm quan trọng</h3><table><tr><th>Tuổi</th><th>Loại vaccine</th></tr><tr><td>Sơ sinh</td><td>BCG, Viêm gan B</td></tr><tr><td>2 tháng</td><td>5 trong 1, Rotavirus</td></tr><tr><td>4 tháng</td><td>5 trong 1 (nhắc lại)</td></tr><tr><td>6 tháng</td><td>5 trong 1 (nhắc lại)</td></tr><tr><td>9 tháng</td><td>Sởi</td></tr><tr><td>18 tháng</td><td>Sởi, Viêm não Nhật Bản</td></tr></table>',
        NULL,
        true,
        true,
        '2025-11-16 16:40:28.52991',
        'Hướng dẫn chi tiết về lịch tiêm chủng đầy đủ cho trẻ từ 0-18 tháng tuổi',
        'lich-tiem-chung-cho-tre-em',
        'Bộ Y tế',
        'tiêm chủng,trẻ em,vaccine,lịch tiêm',
        NULL,
        'Lịch tiêm chủng mở rộng cho trẻ em theo khuyến cáo của Bộ Y tế',
        280
    ),
    (
        4,
        '2025-11-13 16:40:30.02153',
        false,
        '2025-11-14 16:40:30.02153',
        'BS. Phạm Thị Lan',
        'DISEASE_PREVENTION',
        '<h2>Bệnh cúm mùa và cách phòng ngừa</h2><p>Cúm mùa là bệnh truyền nhiễm đường hô hấp thường xuất hiện vào mùa đông.</p><h3>Triệu chứng</h3><ul><li>Sốt cao đột ngột</li><li>Ho, đau họng</li><li>Nhức đầu, mệt mỏi</li><li>Đau cơ</li></ul><h3>Cách phòng ngừa</h3><ol><li>Tiêm vaccine cúm hàng năm</li><li>Rửa tay thường xuyên</li><li>Đeo khẩu trang nơi đông người</li><li>Tăng cường sức đề kháng</li><li>Tránh tiếp xúc người bệnh</li></ol>',
        NULL,
        false,
        true,
        '2025-11-14 16:40:30.02153',
        'Những biện pháp đơn giản nhưng hiệu quả để phòng tránh bệnh cúm mùa',
        'phong-ngua-cum-mua-dong',
        'Bệnh viện Bạch Mai',
        'cúm,mùa đông,phòng bệnh,vaccine cúm',
        NULL,
        'Cách phòng ngừa bệnh cúm mùa hiệu quả trong mùa đông',
        195
    ),
    (
        5,
        '2025-11-14 16:40:32.264894',
        false,
        '2025-11-19 17:35:49.730289',
        'BS. CKI Hoàng Văn Tuấn',
        'CHILDREN_HEALTH',
        '<h2>Dinh dưỡng cho trẻ nhỏ</h2><p>Giai đoạn dưới 5 tuổi là thời kỳ vàng cho sự phát triển thể chất và trí tuệ của trẻ.</p><h3>Nguyên tắc dinh dưỡng</h3><ul><li>Đa dạng thực phẩm</li><li>Đủ 4 nhóm chất: Protein, Tinh bột, Chất béo, Vitamin</li><li>Ưu tiên thực phẩm tươi, sạch</li><li>Hạn chế đồ ngọt, đồ ăn nhanh</li></ul><h3>Thực đơn mẫu</h3><p>Sáng: Cháo thịt + rau xanh<br>Trưa: Cơm + cá/thịt + rau + trái cây<br>Chiều: Sữa + bánh quy<br>Tối: Cơm + canh + rau</p>',
        NULL,
        true,
        false,
        '2025-11-15 16:40:32.264894',
        'Hướng dẫn xây dựng chế độ dinh dưỡng phù hợp giúp trẻ phát triển toàn diện',
        'dinh-duong-cho-tre-duoi-5-tuoi',
        'Viện Dinh dưỡng Quốc gia',
        'trẻ em,dinh dưỡng,sức khỏe,phát triển',
        NULL,
        'Dinh dưỡng cân đối cho trẻ dưới 5 tuổi',
        420
    ),
    (
        6,
        '2025-11-12 16:40:33.626805',
        false,
        '2025-11-13 16:40:33.626805',
        'Ths. Đỗ Thị Mai',
        'NUTRITION',
        '<h2>Thực phẩm cho hệ miễn dịch</h2><p>Một số thực phẩm có khả năng tăng cường hệ miễn dịch tự nhiên của cơ thể.</p><h3>15 Siêu thực phẩm</h3><ol><li>Cam, quýt (Vitamin C)</li><li>Ớt chuông đỏ</li><li>Tỏi</li><li>Gừng</li><li>Rau bina</li><li>Sữa chua</li><li>Hạnh nhân</li><li>Nghệ</li><li>Trà xanh</li><li>Đu đủ</li><li>Kiwi</li><li>Cá hồi</li><li>Nấm</li><li>Bông cải xanh</li><li>Mật ong</li></ol>',
        NULL,
        true,
        true,
        '2025-11-13 16:40:33.626805',
        'Danh sách các siêu thực phẩm giúp tăng cường sức đề kháng cho cơ thể',
        'thuc-pham-tang-cuong-mien-dich',
        'Viện Dinh dưỡng',
        'dinh dưỡng,miễn dịch,thực phẩm,sức khỏe',
        NULL,
        'Top 15 thực phẩm tăng cường hệ miễn dịch tự nhiên',
        510
    ),
    (
        7,
        '2025-11-11 16:40:35.392178',
        false,
        '2025-11-12 16:40:35.392178',
        'BS. CKII Nguyễn Thị Hương',
        'WOMEN_HEALTH',
        '<h2>Chăm sóc thai kỳ</h2><p>Thai kỳ là giai đoạn quan trọng cần được chăm sóc đặc biệt.</p><h3>Các xét nghiệm quan trọng</h3><ul><li>Siêu âm thai định kỳ</li><li>Xét nghiệm máu, nước tiểu</li><li>Sàng lọc dị tật thai nhi</li><li>Test tiểu đường thai kỳ</li></ul><h3>Chế độ dinh dưỡng</h3><ul><li>Bổ sung acid folic</li><li>Uống đủ nước</li><li>Ăn nhiều rau xanh</li><li>Bổ sung canxi</li></ul><h3>Lưu ý</h3><ul><li>Tập thể dục nhẹ nhàng</li><li>Tránh stress</li><li>Ngủ đủ giấc</li></ul>',
        NULL,
        false,
        true,
        '2025-11-12 16:40:35.392178',
        'Hướng dẫn toàn diện về chăm sóc sức khỏe trong suốt thai kỳ',
        'cham-soc-suc-khoe-phu-nu-mang-thai',
        'Bệnh viện Phụ sản Hà Nội',
        'phụ nữ,thai kỳ,mang thai,sức khỏe bà mẹ',
        NULL,
        'Chăm sóc sức khỏe cho phụ nữ mang thai',
        340
    ),
    (
        8,
        '2025-11-10 16:40:37.270622',
        false,
        '2025-11-11 16:40:37.270622',
        'GS.TS Võ Văn Thành',
        'MEDICAL_RESEARCH',
        '<h2>Công nghệ vaccine mRNA</h2><p>Vaccine mRNA là bước đột phá trong y học hiện đại, mở ra kỷ nguyên mới trong phòng chống dịch bệnh.</p><h3>Cơ chế hoạt động</h3><p>Vaccine mRNA chứa mRNA tổng hợp mã hóa cho protein gai của virus. Khi tiêm vào cơ thể, tế bào sẽ sản xuất protein này và kích thích phản ứng miễn dịch.</p><h3>Ưu điểm</h3><ul><li>Sản xuất nhanh chóng</li><li>An toàn, không chứa virus sống</li><li>Dễ điều chỉnh khi virus đột biến</li><li>Hiệu quả cao</li></ul><h3>Ứng dụng tương lai</h3><ul><li>Vaccine phòng ung thư</li><li>Điều trị bệnh hiếm</li><li>Vaccine cá nhân hóa</li></ul>',
        NULL,
        false,
        true,
        '2025-11-11 16:40:37.270622',
        'Tìm hiểu về công nghệ vaccine mRNA đột phá đã thay đổi ngành y học',
        'vaccine-mrna-cong-nghe-tuong-lai',
        'Đại học Y Hà Nội',
        'nghiên cứu,mRNA,vaccine,công nghệ',
        NULL,
        'Vaccine mRNA - Công nghệ y học của tương lai',
        180
    ),
    (
        9,
        '2025-11-09 16:40:39.150603',
        false,
        '2025-11-10 16:40:39.150603',
        'HLV Yoga Trần Minh Châu',
        'HEALTH_TIPS',
        '<h2>Yoga - Phương pháp giảm stress tự nhiên</h2><p>Yoga không chỉ giúp rèn luyện cơ thể mà còn mang lại sự thư thái cho tâm hồn.</p><h3>5 Tư thế cơ bản</h3><h4>1. Tư thế con mèo (Cat-Cow)</h4><p>Giúp giãn cơ lưng, giảm căng thẳng.</p><h4>2. Tư thế trẻ em (Child Pose)</h4><p>Thư giãn toàn thân, giảm mệt mỏi.</p><h4>3. Tư thế cây cầu (Bridge Pose)</h4><p>Tăng cường lưu thông máu não.</p><h4>4. Tư thế xoắn nằm (Supine Twist)</h4><p>Giải phóng căng thẳng cột sống.</p><h4>5. Tư thế xác chết (Savasana)</h4><p>Thư giãn sâu, thiền định.</p>',
        NULL,
        true,
        true,
        '2025-11-10 16:40:39.150603',
        'Những bài tập yoga dễ thực hiện tại nhà giúp thư giãn tinh thần',
        '5-bai-tap-yoga-giam-stress',
        'Trung tâm Yoga & Wellness',
        'yoga,stress,thư giãn,sức khỏe tinh thần',
        NULL,
        '5 Bài tập yoga đơn giản giúp giảm stress hiệu quả',
        625
    ),
    (
        10,
        '2025-11-08 16:40:41.020013',
        false,
        '2025-11-09 16:40:41.020013',
        'BS. CKI Lê Thị Hồng',
        'SEASONAL_DISEASES',
        '<h2>Sốt xuất huyết - Căn bệnh nguy hiểm mùa mưa</h2><p>Sốt xuất huyết dengue là bệnh truyền nhiễm cấp tính do virus dengue gây ra, lây truyền qua muỗi Aedes.</p><h3>Triệu chứng</h3><ul><li>Sốt cao đột ngột 39-40°C</li><li>Đau đầu, đau mắt</li><li>Đau cơ, đau khớp</li><li>Xuất huyết dưới da</li><li>Chảy máu cam, nướu</li></ul><h3>Phòng ngừa</h3><ol><li>Diệt lăng quăng, bọ gậy</li><li>Sử dụng màn, mùng</li><li>Xịt thuốc diệt muỗi</li><li>Mặc quần áo dài tay</li><li>Vệ sinh môi trường</li></ol><h3>Khi nào cần đi khám?</h3><ul><li>Sốt trên 3 ngày</li><li>Xuất hiện vết xuất huyết</li><li>Chảy máu bất thường</li><li>Đau bụng, nôn nhiều</li></ul>',
        NULL,
        false,
        true,
        '2025-11-09 16:40:41.020013',
        'Những biện pháp quan trọng để phòng tránh dịch sốt xuất huyết',
        'sot-xuat-huyet-mua-mua',
        'Viện Pasteur TP.HCM',
        'sốt xuất huyết,mùa mưa,phòng bệnh,muỗi',
        NULL,
        'Phòng chúng sốt xuất huyết trong mùa mưa',
        290
    ),
    (
        11,
        '2025-11-07 16:40:42.854168',
        false,
        '2025-11-08 16:40:42.854168',
        'BS. Geriatrics Phạm Văn Bình',
        'ELDERLY_CARE',
        '<h2>Chăm sóc người cao tuổi</h2><p>Người cao tuổi cần được chăm sóc đặc biệt về sức khỏe và tinh thần.</p><h3>Chế độ dinh dưỡng</h3><ul><li>Ăn nhiều bữa, mỗi bữa ít</li><li>Thực phẩm mềm, dễ tiêu</li><li>Bổ sung canxi, vitamin D</li><li>Hạn chế muối, đường</li></ul><h3>Hoạt động thể chất</h3><ul><li>Đi bộ nhẹ nhàng</li><li>Tập thể dục buổi sáng</li><li>Yoga, khí công</li></ul><h3>Sức khỏe tinh thần</h3><ul><li>Giao lưu với bạn bè</li><li>Tham gia hoạt động cộng đồng</li><li>Làm việc nhà nhẹ nhàng</li></ul>',
        NULL,
        false,
        true,
        '2025-11-08 16:40:42.854168',
        'Hướng dẫn chăm sóc người cao tuổi về thể chất và tinh thần',
        'cham-soc-nguoi-cao-tuoi',
        'Bệnh viện Lão khoa Trung ương',
        'người cao tuổi,chăm sóc,sức khỏe,dinh dưỡng',
        NULL,
        'Chăm sóc sức khỏe toàn diện cho người cao tuổi',
        155
    ),
    (
        12,
        '2025-11-17 16:40:45.223938',
        false,
        '2025-11-19 17:35:40.634659',
        'PGS.TS Mai Văn Khiêm',
        'COVID_19',
        '<h2>Hội chứng hậu COVID-19 (Long COVID)</h2><p>Một số người sau khi khỏi COVID-19 vẫn có triệu chứng kéo dài nhiều tuần hoặc tháng.</p><h3>Triệu chứng thường gặp</h3><ul><li>Mệt mỏi kéo dài</li><li>Khó thở, đau ngực</li><li>Giảm khả năng tập trung</li><li>Mất ngủ</li><li>Đau đầu</li><li>Mất vị giác, khứu giác</li><li>Đau cơ, khớp</li></ul><h3>Cách phục hồi</h3><ol><li>Nghỉ ngơi hợp lý</li><li>Tập thở, tập phổi</li><li>Dinh dưỡng đầy đủ</li><li>Tập thể dục từ từ</li><li>Tái khám định kỳ</li></ol><h3>Khi nào cần gặp bác sĩ?</h3><p>Nếu triệu chứng kéo dài quá 4 tuần hoặc nặng lên, bạn nên đi khám để được theo dõi và điều trị kịp thời.</p>',
        NULL,
        true,
        true,
        '2025-11-18 16:40:45.223938',
        'Tìm hiểu về các biến chứng kéo dài sau COVID-19 và phương pháp phục hồi',
        'bien-chung-sau-covid-19',
        'Bệnh viện Nhiệt đới TW',
        'covid-19,long covid,biến chứng,phục hồi',
        NULL,
        'Hội chứng hậu COVID-19 và cách điều trị',
        445
    ),
    (
        13,
        '2025-11-19 16:40:46.796821',
        false,
        '2025-11-19 17:35:51.871516',
        'Admin',
        'HEALTH_GENERAL',
        '<p>Nội dung đang được cập nhật...</p>',
        '',
        false,
        false,
        '2025-11-19 17:35:44.378052',
        'Đây là bài viết đang trong quá trình soạn thảo',
        'bai-viet-nhap-chua-xuat-ban-1',
        '',
        'nháp',
        '',
        'Bài viết nháp - Chưa xuất bản 1',
        0
    );

-- ========================
-- Bảng: permissions
-- ========================
INSERT INTO
    permissions (
        id,
        api_path,
        method,
        module,
        name
    )
VALUES (
        1,
        '/auth/login/password',
        'POST',
        'AUTH',
        'Login patient'
    ),
    (
        2,
        '/auth/update-password',
        'POST',
        'AUTH',
        'Update password'
    ),
    (
        3,
        '/auth/register',
        'POST',
        'AUTH',
        'Register new patient'
    ),
    (
        4,
        '/auth/refresh',
        'GET',
        'AUTH',
        'Refresh token'
    ),
    (
        5,
        '/auth/update-account',
        'POST',
        'AUTH',
        'Update account'
    ),
    (
        6,
        '/auth/account',
        'GET',
        'AUTH',
        'Get profile'
    ),
    (
        7,
        '/auth/booking',
        'GET',
        'AUTH',
        'Get booking of user'
    ),
    (
        8,
        '/auth/history-booking',
        'GET',
        'AUTH',
        'Get history booking of user'
    ),
    (
        9,
        '/auth/logout',
        'POST',
        'AUTH',
        'Logout user'
    ),
    (
        10,
        '/auth/avatar',
        'POST',
        'AUTH',
        'Update avatar'
    ),
    (
        11,
        '/auth/complete-google-profile',
        'POST',
        'AUTH',
        'Complete Google profile'
    ),
    (
        12,
        '/auth/complete-profile',
        'POST',
        'AUTH',
        'Complete patient profile'
    ),
    (
        13,
        '/users',
        'GET',
        'USER',
        'Get all users'
    ),
    (
        14,
        '/users/doctors',
        'GET',
        'USER',
        'Get all doctors of center'
    ),
    (
        15,
        '/users',
        'PUT',
        'USER',
        'Update a user'
    ),
    (
        16,
        '/users/{id}',
        'DELETE',
        'USER',
        'Delete a user'
    ),
    (
        17,
        '/appointments/center',
        'GET',
        'APPOINTMENT',
        'Get all appointments of center'
    ),
    (
        18,
        '/appointments',
        'PUT',
        'APPOINTMENT',
        'Update a appointment of cashier'
    ),
    (
        19,
        '/appointments/my-schedules',
        'GET',
        'APPOINTMENT',
        'Get all appointments of doctor'
    ),
    (
        20,
        '/appointments/{id}/complete',
        'PUT',
        'APPOINTMENT',
        'Complete a appointment'
    ),
    (
        21,
        '/appointments/reschedule',
        'PUT',
        'APPOINTMENT',
        'Reschedule an appointment'
    ),
    (
        22,
        '/appointments/{id}/cancel',
        'PUT',
        'APPOINTMENT',
        'Cancel a appointment'
    ),
    (
        23,
        '/appointments/urgent',
        'GET',
        'APPOINTMENT',
        'Get urgent appointments for cashier'
    ),
    (
        24,
        '/appointments/today',
        'GET',
        'APPOINTMENT',
        'Get today appointments for doctor'
    ),
    (
        25,
        '/vaccines',
        'GET',
        'VACCINE',
        'Get all vaccines'
    ),
    (
        26,
        '/vaccines/countries',
        'GET',
        'VACCINE',
        'Get all countries'
    ),
    (
        27,
        '/vaccines/{slug}',
        'GET',
        'VACCINE',
        'Get vaccine by slug'
    ),
    (
        28,
        '/vaccines',
        'POST',
        'VACCINE',
        'Create a new vaccine'
    ),
    (
        29,
        '/vaccines/{id}',
        'PUT',
        'VACCINE',
        'Update a vaccine'
    ),
    (
        30,
        '/vaccines/{id}',
        'DELETE',
        'VACCINE',
        'Delete a vaccine'
    ),
    (
        31,
        '/roles',
        'GET',
        'ROLE',
        'Get all roles'
    ),
    (
        32,
        '/roles/{id}',
        'GET',
        'ROLE',
        'Get a role by id'
    ),
    (
        33,
        '/roles/{id}',
        'PUT',
        'ROLE',
        'Update a role'
    ),
    (
        34,
        '/permissions',
        'POST',
        'PERMISSION',
        'Create a permission'
    ),
    (
        35,
        '/permissions',
        'GET',
        'PERMISSION',
        'Get all permissions'
    ),
    (
        36,
        '/permissions',
        'PUT',
        'PERMISSION',
        'Update a permission'
    ),
    (
        37,
        '/permissions/{id}',
        'DELETE',
        'PERMISSION',
        'Delete a permission'
    ),
    (
        38,
        '/files',
        'POST',
        'FILE',
        'Upload single file'
    ),
    (
        39,
        '/news',
        'GET',
        'NEWS',
        'Get all news with filtering'
    ),
    (
        40,
        '/news/published',
        'GET',
        'NEWS',
        'Get all published news'
    ),
    (
        41,
        '/news/featured',
        'GET',
        'NEWS',
        'Get featured news'
    ),
    (
        42,
        '/news/slug/{slug}',
        'GET',
        'NEWS',
        'Get news by slug'
    ),
    (
        43,
        '/news/{id}',
        'GET',
        'NEWS',
        'Get news by ID'
    ),
    (
        44,
        '/news/category/{category}',
        'GET',
        'NEWS',
        'Get news by category'
    ),
    (
        45,
        '/news/categories',
        'GET',
        'NEWS',
        'Get all news categories'
    ),
    (
        46,
        '/news',
        'POST',
        'NEWS',
        'Create new news article'
    ),
    (
        47,
        '/news/{id}',
        'PUT',
        'NEWS',
        'Update news article'
    ),
    (
        48,
        '/news/{id}',
        'DELETE',
        'NEWS',
        'Delete news article'
    ),
    (
        49,
        '/news/{id}/publish',
        'PATCH',
        'NEWS',
        'Publish news article'
    ),
    (
        50,
        '/news/{id}/unpublish',
        'PATCH',
        'NEWS',
        'Unpublish news article'
    ),
    (
        51,
        '/centers/{slug}',
        'GET',
        'CENTER',
        'Get center by slug'
    ),
    (
        52,
        '/centers',
        'GET',
        'CENTER',
        'Get all centers'
    ),
    (
        53,
        '/centers',
        'POST',
        'CENTER',
        'Create a new center'
    ),
    (
        54,
        '/centers/{id}',
        'PUT',
        'CENTER',
        'Update a center'
    ),
    (
        55,
        '/centers/{id}',
        'DELETE',
        'CENTER',
        'Delete a center'
    ),
    (
        56,
        '/bookings',
        'POST',
        'BOOKING',
        'Create a booking'
    ),
    (
        57,
        '/bookings',
        'GET',
        'BOOKING',
        'Get all bookings'
    ),
    (
        58,
        '/api/v1/doctors/my-center/with-schedule',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get doctors with schedule in my center'
    ),
    (
        59,
        '/api/v1/doctors/center/{centerId}/available',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get available doctors by center'
    ),
    (
        60,
        '/api/v1/doctors/{doctorId}/schedules',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get doctor weekly schedule template'
    ),
    (
        61,
        '/api/v1/doctors/{doctorId}/slots/available',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get available slots for doctor'
    ),
    (
        62,
        '/api/v1/doctors/center/{centerId}/slots/available',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get available slots for center'
    ),
    (
        63,
        '/api/v1/doctors/center/{centerId}/slots/available-by-timeslot',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get available slots by center and timeslot'
    ),
    (
        64,
        '/api/v1/doctors/{doctorId}/slots',
        'GET',
        'DOCTOR_SCHEDULE',
        'Get doctor slots in date range'
    ),
    (
        65,
        '/api/v1/doctors/{doctorId}/slots/generate',
        'POST',
        'DOCTOR_SCHEDULE',
        'Generate slots for doctor'
    ),
    (
        66,
        '/api/family-members',
        'POST',
        'FAMILY_MEMBER',
        'Add a new family member'
    ),
    (
        67,
        '/api/family-members',
        'PUT',
        'FAMILY_MEMBER',
        'Update a family member'
    ),
    (
        68,
        '/api/family-members/{id}',
        'DELETE',
        'FAMILY_MEMBER',
        'Delete a family member'
    ),
    (
        69,
        '/api/family-members',
        'GET',
        'FAMILY_MEMBER',
        'Get all family members'
    ),
    (
        70,
        '/api/family-members/{id}',
        'GET',
        'FAMILY_MEMBER',
        'Get family member by id'
    ),
    (
        71,
        '/api/vaccine-records/patient/{userId}',
        'GET',
        'VACCINE_RECORD',
        'Get all vaccine records for patient'
    ),
    (
        72,
        '/api/profile/patient',
        'GET',
        'PROFILE',
        'Get patient profile'
    ),
    (
        73,
        '/api/profile/patient',
        'PUT',
        'PROFILE',
        'Update patient profile'
    ),
    (
        74,
        '/api/profile/doctor',
        'GET',
        'PROFILE',
        'Get doctor profile'
    ),
    (
        75,
        '/api/profile/doctor',
        'PUT',
        'PROFILE',
        'Update doctor profile'
    ),
    (
        76,
        '/api/profile/cashier',
        'GET',
        'PROFILE',
        'Get cashier profile'
    ),
    (
        77,
        '/api/profile/cashier',
        'PUT',
        'PROFILE',
        'Update cashier profile'
    ),
    (
        78,
        '/api/profile/admin',
        'GET',
        'PROFILE',
        'Get admin profile'
    ),
    (
        79,
        '/api/profile/admin',
        'PUT',
        'PROFILE',
        'Update admin profile'
    ),
    (
        80,
        '/payments/paypal/success',
        'GET',
        'PAYMENT',
        'Handle PayPal payment success'
    ),
    (
        81,
        '/payments/paypal/cancel',
        'GET',
        'PAYMENT',
        'Handle PayPal payment cancel'
    ),
    (
        82,
        '/payments/vnpay/return',
        'GET',
        'PAYMENT',
        'Handle VNPay payment return'
    ),
    (
        83,
        '/payments/meta-mask',
        'POST',
        'PAYMENT',
        'Update payment with MetaMask'
    ),
    (
        84,
        '/orders',
        'POST',
        'ORDER',
        'Create a new order'
    ),
    (
        85,
        '/orders',
        'GET',
        'ORDER',
        'Get all orders of user'
    ),
    (
        86,
        '/api/v1/hello',
        'GET',
        'HEALTH',
        'Health check endpoint'
    ),
    (
        87,
        '/api/v1/hello-secure',
        'GET',
        'HEALTH',
        'Secure health check endpoint'
    ),
    (
        88,
        '/api/notification-settings',
        'GET',
        'NOTIFICATION_SETTING',
        'Get notification settings'
    ),
    (
        89,
        '/api/notification-settings',
        'PUT',
        'NOTIFICATION_SETTING',
        'Update notification settings'
    ),
    (
        90,
        '/api/reminders/my-reminders',
        'GET',
        'REMINDER',
        'Get user reminders'
    ),
    (
        91,
        '/api/reminders/appointment/{appointmentId}',
        'GET',
        'REMINDER',
        'Get appointment reminders'
    ),
    (
        92,
        '/api/reminders/send-pending',
        'POST',
        'REMINDER',
        'Send pending reminders'
    ),
    (
        93,
        '/api/reminders/retry-failed',
        'POST',
        'REMINDER',
        'Retry failed reminders'
    ),
    (
        94,
        '/api/reminders/appointment/{appointmentId}',
        'DELETE',
        'REMINDER',
        'Cancel appointment reminders'
    ),
    (
        95,
        '/api/reminders/statistics',
        'GET',
        'REMINDER',
        'Get reminder statistics'
    ),
    (
        96,
        '/api/test/create-test-appointment',
        'POST',
        'TEST',
        'Create test appointment'
    ),
    (
        97,
        '/api/test/send-test-reminder',
        'POST',
        'TEST',
        'Send test reminder'
    ),
    (
        98,
        '/api/test/complete-appointment/{appointmentId}',
        'POST',
        'TEST',
        'Complete test appointment'
    );

-- ========================
-- Bảng: vaccines
-- ========================

INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (39, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Trẻ bị dị ứng với một trong các thành phần của vắc xin.","Nếu trẻ bị bệnh não tiến triển (thương tổn ở não).","Nếu trẻ từng bị bệnh não (tổn thương ở não) trong vòng 7 ngày sau khi tiêm liều vắc xin ho gà (ho gà vô bào hay toàn tế bào).","Nếu trẻ bị sốt hay bị bệnh cấp tính (phải hoãn việc tiêm ngừa lại)."}', 'Pháp', NULL, 'Vắc xin 4 trong 1 Tetraxim (Pháp) được chỉ định để phòng ngừa các bệnh ho gà, bạch hầu, uốn ván, bại liệt cho trẻ từ 2 tháng tuổi trở lên đến 13 tuổi tùy theo mỗi quốc gia.', 'Bạch hầu, Ho gà, Uốn ván, Bại liệt là những căn bệnh truyền nhiễm rất nguy hiểm. Mọi đối tượng từ trẻ em đến người...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-tetraxim.jpg', '{"Tiêm bắp ở trẻ nhũ nhi và tiêm vùng cơ delta ở trẻ 2 tháng tuổi đến 13 tuổi."}', 'Vắc xin Tetraxim do tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh họ c Sanofi Pasteur (Pháp) sản xuất.', 'Tetraxim', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C. Không được để đông băng."}', 1336873, 'vac-xin-tetraxim', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (1, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn cảm với các thành phần hoạt chất hoặc bất kỳ tá dược nào có trong vắc xin.","Người có tiền sử phản vệ độ III với vắc xin cùng loại trước đây hoặc vắc xin có thành phần uốn ván, vắc xin có cùng thành phần."}', 'Bỉ', NULL, 'Vắc xin Nimenrix là vắc xin não mô cầu công nghệ tiên tiến, giúp tạo miễn dịch chủ động phòng bệnh não mô cầu xâm lấn do vi khuẩn Neisseria meningitidis thuộc 4 nhóm huyết thanh A, C, Y, W-135.', 'Alo', 3, 20, 'https://vnvc.vn/wp-content/uploads/2025/08/hop-vac-xin-nimenrix.jpg', '{"Nimenrix được sử dụng theo đường tiêm bắp.","Không được tiêm Nimenrix qua đường tĩnh mạch, trong da hoặc dưới da."}', 'Vắc xin Nimenrix được phát triển và sản xuất bởi Tập đoàn dược phẩm sinh học Pfizer (Mỹ), sản xuất tại Bỉ.', 'Nimenrix', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng.","Bảo quản trong bao bì gốc để tránh ánh sáng.","Sau khi pha hồi chỉnh, vắc xin phải được sử dụng ngay trong vòng 8 giờ."}', 577069, 'vac-xin-nimenrix', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (38, '2025-11-17 02:43:15.408049', false, '2025-12-24 01:55:50.971069', '{"Người dị ứng với bất kỳ thành phần nào trong vắc xin, kể cả gelatin .","Người đang mang thai, phải tránh mang thai 1 tháng sau khi tiêm vắc xin cho phụ nữ.","Có tiền sử dị ứng với neomycin.","Đang có bệnh lý sốt hoặc viêm đường hô hấp.","Bệnh lao đang tiến triển mà chưa được điều trị hoặc người đang điều trị bằng thuốc ức chế miễn dịch.","Người có rối loạn về máu, bệnh bạch cầu hay u hạch bạch huyết; hoặc ở người có những khối u tân sinh ác tính ảnh hưởng tới tủy xương hoặc hệ bạch huyết.","Người bị bệnh suy giảm miễn dịch tiên phát hoặc thứ phát, bao gồm cả người mắc bệnh AIDS và người có biểu hiện lâm sàng về nhiễm virus gây suy giảm miễn dịch; các bệnh gây giảm hoặc bất thường gammaglobulin máu.","Người có tiền sử trong gia đình suy giảm miễn dịch bẩm sinh hoặc di truyền cho đến khi chứng minh được họ có khả năng đáp ứng miễn dịch với vắc xin."}', 'Mỹ', NULL, 'Vắc xin phối hợp MMR-II của Mỹ là vắc xin sống giảm độc lực tạo miễn dịch chủ động dùng để ngăn ngừa nhiễm virus bệnh sởi, quai bị và rubella. Thuốc hoạt động bằng cách giúp cơ thể tạo kháng thể chống lại virus.', 'Sởi, quai bị, rubella đều là dẫn căn bệnh rất dễ lây qua đường hô hấp nếu chưa có kháng thể phòng bệnh. Bệnh lây...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-MMR-II.jpg', '{"Tiêm dưới da, không được tiêm tĩnh mạch."}', 'Vắc xin MMR-II được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới Merck Sharp and Dohm (Mỹ).', 'MMR II', '{"Trước khi hoàn nguyên, vắc xin cần được bảo quản ở nhiệt độ 2-8 độ C và tránh ánh sáng.","Sau khi hoàn nguyên nên sử dụng ngay vắc xin,có thể sử dụng được vắc xin đã hoàn nguyên nếu được bảo quản ở chỗ tối nhiệt độ từ 2-8 độ C, tránh ánh sáng. Sau 8 giờ phải hủy bỏ vắc xin theo quy định."}', 1674344, 'mmr-ii-vac-xin-phong-3-benh-soi-quai-bi-rubella', 19);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (23, '2025-11-17 02:43:15.408049', false, '2025-12-24 01:57:29.356818', '{"Quá mẫn cảm với các hoạt chất, với bất kỳ tá dược liệt kê trong mục “thành phần” hoặc bất kỳ chất nào có thể có trong thành phần dù với một lượng rất nhỏ còn sót lại (vết) như trứng ( ovalbumin , protein của gà), neomycin, formaldehyde và octoxynol-9.","Hoãn tiêm vắc xin với những người bị sốt vừa hay sốt cao hay bị bệnh cấp tính."}', 'Pháp', NULL, 'Vắc xin cúm Tứ giá Vaxigrip Tetra phòng được 4 chủng tuýp virus cúm gồm: 2 chủng cúm A (H1N1, H3N2) và 2 chủng cúm B (Yamagata, Victoria).', 'Vắc xin Vaxigrip Tetra là loại vắc xin cúm thế hệ mới phòng được 4 chủng virus cúm, còn gọi là vắc xin Tứ giá,...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/07/vaccine-vaxigrip-tetra.jpg', '{"Tiêm bắp hoặc tiêm dưới da."}', 'Vắc xin Vaxigrip Tetra được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp).', 'Vaxigrip Tetra', '{"Vắc xin Vaxigrip Tetra được bảo quản ở nhiệt độ 2-8 độ C. Không để đông băng và tránh ánh sáng."}', 1510751, 'vaxigrip-tetra', 19);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (40, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người có tiền sử phản ứng dị ứng với bất kỳ thành phần nào của Imojev.","Người suy giảm miễn dịch bẩm sinh hoặc mắc phải làm suy yếu miễn dịch tế bào.","Người nhiễm HIV có triệu chứng hoặc bằng chứng suy giảm chức năng miễn dịch.","Phụ nữ có thai hoặc cho con bú sữa mẹ."}', 'Thái Lan', NULL, 'Imojev là vắc xin phòng viêm não Nhật Bản được chỉ định cho trẻ em từ 9 tháng tuổi trở lên và người lớn.', 'Viêm não Nhật Bản là căn bệnh nguy hiểm, rất khó phát hiện do triệu chứng ban đầu rất giống với các bệnh viêm nhiễm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2019/07/vac-xin-imojev.jpg', '{"Trẻ từ 9 tháng tuổi đến 24 tháng tuổi: Tiêm tại mặt trước – bên của đùi hoặc vùng cơ Delta ở cánh tay.","Trẻ từ 2 tuổi trở lên và người lớn: Tiêm tại vùng cơ Delta ở cánh tay.","Liều tiêm: 0,5ml/liều Imojev hoàn nguyên."}', 'Vắc xin Imojev được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp). Sản xuất tại Thái Lan.', 'Imojev', '{"Vắc xin Imojev cần bảo quản ở nhiệt độ từ 2 đến 8 độ C, không được để đông băng.","Giữ vắc xin trong hộp để tránh ánh sáng."}', 1255187, 'imojev-vac-xin-phong-viem-nao-nhat-ban-moi', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (41, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Hoãn việc tiêm chủng nếu có sốt hay nhiễm trùng cấp tính. Bệnh mãn tính trong giai đoạn tiến triển.","Không tiêm cho người bị dị ứng với hoạt chất, với bất kỳ thành phần tá dược nào có trong vắc xin, với neomycin, với polysorbate hoặc nếu trước đây đã từng bị mẩn mãn sau khi tiêm vắc xin này."}', 'Pháp', NULL, 'Vắc xin Avaxim 80U tạo miễn dịch chủ động phòng ngừa virus gây bệnh viêm gan siêu vi A.', 'Năm 1973, các nhà khoa học đã quan sát được một loại siêu vi gây bệnh tên là siêu vi viêm gan A. Siêu vi...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-avaxim-80U.jpg', '{"Tiêm bắp vào cơ delta trên cánh tay."}', 'Vắc xin Avaxim 80U được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp).', 'Avaxim', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C. Tránh ánh sáng. Không được đông băng."}', 1486294, 'avaxim-vac-xin-phong-viem-gan', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (42, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm Havax cho những người quá nhạy cảm với bất cứ thành phần nào của vắc xin.","Bệnh tim, bệnh thận hoặc bệnh gan.","Bệnh tiểu đường.","Bệnh ung thư máu và các bệnh ác tính nói chung.","Bệnh quá mẫn.","Không được tiêm tĩnh mạch trong bất cứ trường hợp nào.","Không tiêm cho trẻ em dưới 2 tuổi (24 tháng tuổi).","Không tiêm cho các đối tượng mắc bệnh bẩm sinh.","Hoãn tiêm ở người đang mệt mỏi, sốt cao hoặc phản ứng toàn thân hoặc bệnh nhiễm trùng đang tiến triển."}', 'Việt Nam', NULL, 'Vắc xin Havax được dùng để phòng ngừa bệnh viêm gan A cho mọi đối tượng người lớn và trẻ em từ 24 tháng tuổi trở lên, đặc biệt cho những người có nguy cơ phơi nhiễm với virus viêm gan A.', 'Viêm gan siêu vi A (Hepatitis A) là một bệnh truyền nhiễm có mặt hầu hết khắp nơi trên thế giới. Bệnh thường lây qua...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-havax.jpg', '{"Tiêm bắp. Không được tiêm vào đường tĩnh mạch hoặc trong da.","Ở người lớn thì tiêm vắc-xin vào vùng cơ Delta song ở trẻ em nên tiêm vào vùng đùi ngoài thì tốt hơn vì cơ Delta còn nhỏ."}', 'Vắc xin Havax được nghiên cứu và sản xuất bởi Vabiotech – Việt Nam.', 'Havax', '{"Vắc xin được bảo quản ở nhiệt độ từ +2 đến +8 độ C. Không để đông đá. Tránh ánh sáng."}', 794431, 'vac-xin-havax', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (45, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không dùng vắc xin mORCVAX cho trẻ đã quá mẫn cảm ở lần uống đầu tiên hoặc với bất kỳ thành phần nào của vắc xin.","Không dùng cho người mắc các bệnh nhiễm trùng đường ruột cấp tính, các bệnh cấp tính và mãn tính đang thời kỳ tiến triển.","Không dùng cho bệnh nhân đang sử dụng thuốc ức chế miễn dịch , thuốc chống ung thư."}', 'Việt Nam', NULL, 'Vắc xin mORCVAX phòng bệnh bệnh truyền nhiễm cấp tính do vi khuẩn tả Vibrio cholerae gây nên.', 'Bệnh tả là bệnh truyền nhiễm cấp tính do vi khuẩn tả Vibrio cholerae gây nên. Trên thế giới mỗi năm có từ 1,3 -...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2019/06/vac-xin-mORCVAX.jpg', '{"Chỉ dùng đường uống. Liều dùng: 1,5ml/liều."}', 'Vắc xin mORCVAX được nghiên cứu và sản xuất bởi Vabiotech – Việt Nam.', 'mOrcvax', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 2805717, 'morcvax-vac-xin-phong-benh-ta', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (46, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm QuimiHib cho đối tượng dị ứng, mẫn cảm với bất kỳ thành phần nào của vắc xin.","Không tiêm cho đối tượng đang sốt cao hoặc bệnh cấp tính.","Không tiêm vào mạch máu, tĩnh mạch trong bất cứ trường hợp nào."}', 'Cu ba', NULL, 'Vắc xin Quimihib phòng ngừa bệnh viêm phổi, viêm màng não mủ do tác nhân Haemophilus Influenzae type b gây ra ở trẻ nhỏ.', 'Vi khuẩn Hib (Haemophilus Influenzae type b) là thủ phạm chính gây ra bệnh viêm phổi, viêm màng não mủ thường gặp ở trẻ nhỏ...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-quimi-hib.jpg', '{"Tiêm bắp.","Tiêm vào vùng trước bên đùi của trẻ dưới 2 tuổi.","Tiêm vào vùng cơ delta đối với trẻ trên 2 tuổi."}', '{"Vắc xin QuimiHib được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học C.I.G.B – Cuba."}', 'Quimihib', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C. Không được để đông đá vắc xin. Loại bỏ vắc xin nếu bị đông đá. Vắc xin cần được tiêm ngay sau khi mở lọ."}', 1936172, 'vac-xin-quimi-hib', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (35, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với các thành phần của vắc xin.","Người đang sốt, nhiễm khuẩn cấp tính, dị ứng đang tiến triển.","Hiếm khi có phản ứng dị ứng nhưng cần ngưng liều thứ 2 nếu liều 1 có dấu hiệu dị ứng."}', 'Cu ba', NULL, 'Vắc xin VA-Mengoc-BC phòng bệnh viêm màng não do não mô cầu khuẩn Meningococcal tuýp B và C gây ra.', 'Triệu chứng bệnh viêm não mô cầu Trẻ tật nguyền, tử vong vì viêm não mô cầu Viêm màng não do não mô cầu là...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-va-mengoc-bc.jpg', '{"Tiêm bắp sâu, tốt nhất là vào vùng cơ delta cánh tay. Tuy nhiên ở trẻ nhỏ có thể tiêm bắp đùi, ở mặt trước ngoài của đùi.","Không được tiêm tĩnh mạch."}', 'Vắc xin VA-Mengoc-BC được nghiên cứu và sản xuất bởi Finlay Institute (Cu Ba).', 'Mengoc BC', '{"Vắc xin cần được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C và không được đông băng."}', 1233792, 'va-mengoc-bc-vac-xin-phong-viem-mang-nao-nao-mo-cau-b-c', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (48, '2025-11-17 02:43:15.408049', false, '2025-11-23 23:22:09.249012', '{"Bệnh nhân sốt hoặc người bị suy dinh dưỡng.","Bệnh nhân bị rối loạn tim mạch, rối loạn thận hoặc bệnh gan trong khi bệnh đang trong giai đoạn cấp tính, hoặc hoạt động.","Bệnh nhân mắc bệnh hô hấp cấp tính hoặc bệnh truyền nhiễm tích cực khác.","Bệnh nhân mắc bệnh thể ẩn và trong giai đoạn dưỡng bệnh.","Người quá mẫn với các thành phần của vắc xin.","Người bị dị ứng với trứng, thịt gà, mọi sản phẩm từ thịt gà.","Người bị sốt trong vòng 2 ngày hoặc có triệu chứng dị ứng như phát ban toàn thân sau tiêm tại lần tiêm phòng trước.","Người có triệu chứng co giật trong vòng 1 năm trước khi tiêm chủng.","Người có hội chứng Guillain-Barre hoặc người bị rối loạn thần kinh trong vòng 6 tuần kể từ lần chủng ngừa cúm trước.","Người được chẩn đoán mắc bệnh suy giảm miễn dịch."}', 'Nga', NULL, 'Vắc xin GCFlu Quadrivalent được chỉ định để phòng ngừa bệnh cúm mùa do virus cúm thuộc 2 chủng cúm A (H1N1, H3N2) và 2 chủng cúm B (Victoria và Yamagata).', 'Vắc xin GCFlu Quadrivalent là vắc xin thế hệ mới phòng được 4 chủng cúm cho hiệu quả cao, giảm tỷ lệ biến chứng và...', 1, 20, 'https://vnvc.vn/wp-content/uploads/2021/12/GCFlu-Quadrivalent.jpg', '{"Đường dùng: Tiêm bắp."}', 'Vắc xin GC Flu Quadrivalent được nghiên cứu và sản xuất bởi Green Cross (Hàn Quốc).', 'GCFLU Quadrivalent phòng Cúm mùa', '{"Vắc xin cúm GC Flu Quadrivalent phải được bảo quản tại 2°C đến 8°C (trong tủ lạnh).","Không được đông băng.","Bảo quản trong bao bì gốc. Tránh tiếp xúc ánh sáng."}', 2079918, 'gcflu-quadrivalent-phong-cum-mua', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (3, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm vắc xin Prevenar 20 với người quá mẫn cảm với thành phần trong vắc xin hoặc với độc tố bạch hầu."}', 'Bỉ', NULL, 'Vắc xin Prevenar 20 còn gọi là vắc xin phế cầu 20 tuýp giúp tạo miễn dịch chủ động để phòng ngừa các bệnh lý  phế cầu xâm lấn (viêm phổi kèm nhiễm khuẩn huyết, viêm màng não, nhiễm khuẩn huyết…) và các bệnh phế cầu không xâm lấn (viêm phổi, viêm tai giữa, viêm xoang…) do 20 tuýp vi khuẩn phế cầu (Streptococcus pneumoniae) có trong vắc xin gây ra ở người từ 18 tuổi trở lên.', 'Vắc xin Prevenar 20 còn gọi là vắc xin phế cầu 20 tuýp giúp tạo miễn dịch chủ động để phòng ngừa các bệnh lý ...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2025/05/vac-xin-prevenar-20-2.jpg', '{"Vắc xin Prevenar 20 được chỉ định tiêm bắp (ưu tiên tại vị trí vùng cơ delta) với liều 0,5ml."}', 'Vắc xin Prevenar 20 được nghiên cứu và phát triển bởi Pfizer (Mỹ), sản xuất tại Bỉ.', 'Prevenar 20', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng. Loại bỏ vắc xin nếu bị đông băng.","Bảo quản trong bao bì gốc để tránh ánh sáng."}', 895930, 'vac-xin-prevenar-20', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (27, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người mẫn cảm với các thành phần hoạt tính, với bất kỳ tá dược hoặc bất cứ thành phần nào có thể chỉ có mặt với một lượng rất nhỏ như trứng (ovalbumin, protein gà), formaldehyde, cetyltrimethylammonium bromide, polysorbat 80, hoặc gentamicin.","Các bệnh nhân/trẻ em có triệu chứng sốt hoặc nhiễm trùng cấp tính sẽ phải hoãn tiêm chủng."}', 'Hà Lan', NULL, 'Vắc xin Cúm Tứ giá Influvac Tetra được chỉ định để phòng ngừa bệnh cúm mùa do virus cúm thuộc hai chủng cúm A (H1N1, H3N2) và hai chủng cúm B (Yamagata, Victoria).', 'Vắc xin Influvac Tetra là vắc xin Tứ giá thế hệ mới phòng được 4 chủng cúm cho hiệu quả cao, giảm tỷ lệ biến...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/11/vac-xin-influvac-tetra.jpg', '{"Tiêm bắp hoặc tiêm sâu dưới da."}', 'Vắc xin Influvac Tetra được nghiên cứu và sản xuất bởi hãng Abbott – Hà Lan.', 'Influvac Tetra', '{"Vắc xin cúm Influvac Tetra phải được bảo quản tại 2°C đến 8°C (trong tủ lạnh).","Không được đông băng.","Bảo quản trong bao bì gốc. Tránh ánh sáng."}', 2626107, 'influvac-tetra', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (30, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với bất kỳ thành phần nào của vắc xin.","Người đang sốt cao hoặc mắc bệnh cấp tính nặng.","Người có tiền sử phản ứng dị ứng nặng sau tiêm liều vắc xin viêm gan B trước đó."}', 'Cu ba', NULL, 'Vắc xin Heberbiovac HB là vắc xin viêm gan B tái tổ hợp phòng bệnh do virus viêm gan B – loại virus có thể lây truyền dễ dàng qua đường máu, quan hệ tình dục và từ mẹ truyền sang con.', 'Vắc xin Heberbiovac HB là vắc xin viêm gan B tạo miễn dịch chủ động chống nhiễm virus HBV - virus gây viêm gan B...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2022/08/vac-xin-Heberbiovac-HB.jpg', '{"Vắc xin Heberbiovac HB được chỉ định tiêm bắp.","Liều tiêm 0,5ml cho trẻ em dưới 15 tuổi và 1ml cho người từ 15 tuổi trở lên.","Vị trí tiêm: vùng cơ delta ở người lớn và mặt trước ngoài đùi ở trẻ nhỏ."}', 'Vắc xin Heberbiovac HB được nghiên cứu và sản xuất bởi Trung tâm Kỹ thuật Di truyền và Công nghệ sinh học Cuba (CIGB).', 'Heberbiovac', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng.","Tránh ánh sáng trực tiếp."}', 2355172, 'heberbiovac-hb', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (12, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Tiền sử trước đây bị phản ứng phản vệ sau khi tiêm Hexaxim.","Quá mẫn với các hoạt chất hay bất cứ tá dược nào được liệt kê trong thành phần của vắc xin, với các dư lượng vết (glutaraldehyde ( 1 ), formaldehyde ( 2 ), neomycin, streptomycin, polymyxin B), với vắc xin ho gà bất kỳ, hoặc trước đây từng bị phản ứng quá mẫn sau khi tiêm Hexaxim hoặc sau khi tiêm vắc xin chứa các thành phần tương tự .","Đối tượng có bệnh lý não (tổn thương ở não) không rõ nguyên nhân, xảy ra trong vòng 7 ngày sau khi tiêm 1 vắc xin chứa thành phần ho gà (vắc xin ho gà vô bào hay nguyên bào). Trong trường hợp này, nên ngừng tiêm vắc xin ho gà và có thể tiếp tục với quá trình tiêm chủng với các vắc xin Bạch hầu, Uốn ván, Viêm gan B, Bại liệt và Hib.","Không nên tiêm vắc xin ho gà cho người có rối loạn thần kinh không kiểm soát hoặc động kinh không kiểm soát cho đến khi bệnh được điều trị, bệnh ổn định và lợi ích rõ ràng vượt trội nguy cơ.","Trẻ bị dị ứng với một trong các thành phần của vắc xin hay với vắc xin ho gà (vô bào hoặc nguyên bào), hay trước đây trẻ đã có phản ứng dị ứng sau khi tiêm vắc xin có chứa các chất tương tự.","Trẻ có bệnh não tiến triển hoặc tổn thương ở não."}', 'Pháp', NULL, 'Vắc xin Hexaxim là vắc xin kết hợp phòng được 6 loại bệnh trong 1 mũi tiêm, bao gồm: Ho gà, bạch hầu, uốn ván, bại liệt, viêm gan B và các bệnh viêm phổi, viêm màng não mủ do H.Influenzae týp B (Hib). Tích hợp trong duy nhất trong 1 vắc xin, 6 trong 1 Hexaxim giúp giảm số mũi tiêm, đồng nghĩa với việc hạn chế đau đớn cho bé khi phải tiêm quá nhiều.', 'Bạch hầu, ho gà, uốn ván, viêm gan B, bại liệt và Các bệnh viêm phổi, viêm màng não do H.influenzae týp B là 6...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2018/06/vacxin-hexaxim.jpg', '{"Hexaxim được chỉ định tiêm bắp. Vị trí tiêm là mặt trước – ngoài của phần trên đùi và vùng cơ delta ở trẻ 15 tháng tuổi trở lên."}', 'Vắc xin Hexaxim được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp).', 'Hexaxim', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 2082859, 'hexaxim-vac-xin-6-trong-1', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (32, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không dùng vắc xin Rotarix cho trẻ đã quá mẫn cảm ở lần uống đầu tiên hoặc với bất kỳ thành phần nào của vắc xin.","Không dùng cho trẻ có dị tật bẩm sinh về đường tiêu hóa vì có thể dẫn đến lồng ruột (như túi thừa Meckel )."}', 'Bỉ', NULL, 'Rotarix là vắc xin sống, giảm độc lực được chỉ định cho trẻ từ 6 tuần tuổi phòng viêm dạ dày – ruột do Rotavirus tuýp huyết thanh G1 và không phải G1. Mặc dù trong thành phần chỉ có 1 tuýp G1P tuy nhiên vắc xin có khả năng bảo vệ chéo tất cả các tuýp G1 và không phải G1 (G2, G3, G4, G9).', 'Virus Rota là một trong những nguyên nhân hàng đầu gây tiêu chảy nặng, nhập viện, thậm chí tử vong ở trẻ nhỏ trên toàn...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-rotarix.jpg', '{"Vắc xin Rotarix được sử dụng theo đường uống.","Liều dùng: 1,5ml cho mỗi liều.","Lịch uống: 2 liều, liều 1 khi trẻ từ 6 tuần tuổi, liều 2 cách liều 1 ít nhất 4 tuần.","Phải hoàn thành 2 liều trước khi trẻ 24 tuần tuổi."}', 'Vắc xin Rotarix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học – GlaxoSmithKline (Bỉ).', 'Rotarix', '{"Vắc xin đông khô được bảo quản ở nhiệt độ 2-8 độ C, tránh ánh sáng.","Dung môi hoàn nguyên có thể bảo quản ở 2-8 độ C hoặc ở nhiệt độ phòng (<37 độ C).","Sau khi hoàn nguyên, vắc xin được sử dụng ngay hoặc bảo quản trong tủ lạnh từ 2-8 độ C trong vòng 24 giờ. Sau 24 giờ phải loại bỏ vắc xin đã hoàn nguyên."}', 2996530, 'vac-xin-rotarix', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (10, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người đã bị phản ứng quá mẫn toàn thân với bất cứ thành phần của vắc xin, hoặc sau một lần tiêm vắc xin này hoặc một vắc xin chứa cùng một thành phần trước đây.","Sốt hay bệnh cấp tính: thông thường, trong trường hợp sốt vừa hoặc nặng và/hoặc bệnh cấp tính nên trì hoãn tiêm chủng."}', 'Mỹ', NULL, 'Vắc xin Menactra được chỉ định để tạo miễn dịch chủ động cơ bản và nhắc lại phòng bệnh xâm lấn do N.meningitidis (vi khuẩn não mô cầu) các nhóm huyết thanh A, C, Y, W-135 gây ra, như: viêm màng não, nhiễm trùng huyết, viêm phổi…', 'Bệnh viêm màng não, nhiễm khuẩn huyết và viêm phổi do não mô cầu khuẩn (Neisseria meningitidis) là bệnh truyền nhiễm cấp tính, lây truyền...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2020/02/vacxin-menactra-1.jpg', '{"Menactra được chỉ định tiêm bắp, tốt nhất là ở mặt trước – ngoài của đùi hoặc vùng cơ delta tùy theo tuổi và khối cơ của đối tượng. Không được tiêm tĩnh mạch hoặc tiêm trong da & dưới da đối với vắc xin Menactra."}', 'Vắc xin Menactra được sản xuất bởi hãng vắc xin hàng đầu thế giới – Sanofi Pasteur (Pháp). Được sản xuất tại Mỹ.', 'Menactra', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Không được đông băng."}', 1811492, 'menactra-vac-xin-nao-mo-cau-nhom-acy-va-w-135-polysaccharide-cong-hop-giai-doc-bach-hau', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (11, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với các hoạt chất hoặc với bất kỳ tá dược nào của vắc xin được liệt kê trong phần “Thành phần”.","Những người bị quá mẫn sau khi tiêm Gardasil 9 hoặc Gardasil trước đây không nên tiêm Gardasil 9."}', 'Mỹ', NULL, 'Vắc xin thế hệ mới Gardasil 9 được xem là vắc xin bình đẳng giới vì mở rộng cả đối tượng và phạm vi phòng bệnh rộng hơn ở nam và nữ giới, bảo vệ khỏi 9 tuýp virus HPV phổ biến 6, 11, 16, 18, 31, 33, 45, 52 và 58 gây bệnh ung thư cổ tử cung, ung thư âm hộ, ung thư âm đạo, ung thư hậu môn, ung thư hầu họng, mụn cóc sinh dục, các tổn thương tiền ung thư hoặc loạn sản…, với hiệu quả bảo vệ lên đến trên 90%.', 'Vắc xin Gardasil 9 là vắc xin thế hệ mới đầu tiên phòng ngừa hiệu quả 9 chủng virus HPV gây hàng loạt bệnh nguy...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2022/05/vacxin-gardasil-9.jpg', '{"Vắc xin Gardasil 9 được chỉ định tiêm bắp. Vị trí phù hợp là vùng cơ delta của phần trên cánh tay hoặc ở vùng trước phía trên đùi.","Không được tiêm Gardasil 9 vào mạch máu, tiêm dưới da hoặc tiêm trong da.","Không được trộn lẫn vắc xin trong cùng một ống tiêm với bất kỳ loại vắc xin và dung dịch nào khác."}', 'Vắc xin Gardasil 9 được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học – Merck Sharp & Dohme (MSD – Mỹ) .', 'Gardasil 9', '{"Vắc xin Gardasil 9 được bảo quản trong tủ lạnh (2°C – 8°C). Không để đông lạnh."}', 1817663, 'vac-xin-gardasil-9', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (24, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Hoãn tiêm vắc xin Varilrix với những người đang sốt cao cấp tính.","Chống chỉ định tiêm cho những người suy giảm miễn dịch dịch thể hoặc tế nào nghiêm trọng như:"}', 'Bỉ', NULL, 'Vắc xin Varilrix (Bỉ) là vắc xin sống giảm độc lực phòng bệnh thủy đậu do virus Varicella Zoster cho trẻ từ 9 tháng tuổi và người lớn chưa có miễn dịch.', 'Thủy đậu là bệnh truyền nhiễm cấp tính, có thể gây ra nhiều biến chứng nguy hiểm: Có đến 20% tỷ lệ trẻ tử vong...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/01/vac-xin-varilrix.jpg', '{"Vắc xin Varilrix được chỉ định tiêm dưới da ở vùng cơ delta hoặc vùng má ngoài đùi với liều 0.5ml."}', 'Vắc xin Varilrix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ.', 'Varilrix', '{"Vắc xin Varilrix được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 2030450, 'varilrix-vac-xin-phong-benh-thuy-dau', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (25, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với bất kỳ thành phần nào của vắc xin.","Người đang sốt cao hoặc mắc bệnh cấp tính.","Phụ nữ đang mang thai hoặc cho con bú (cần tham khảo ý kiến bác sĩ).","Người có tiền sử phản ứng dị ứng nặng sau tiêm vắc xin viêm não Nhật Bản trước đó."}', 'Ấn Độ', NULL, 'Vắc xin JEEV là loại vắc xin tinh khiết, bất hoạt qua nuôi cấy từ tế bào Vero, giúp cơ thể tạo ra miễn dịch chủ động nhằm dự phòng bệnh viêm não Nhật Bản .', 'Vắc xin JEEV là loại vắc xin tinh khiết, bất hoạt qua nuôi cấy từ tế bào Vero, giúp cơ thể tạo ra miễn dịch...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2023/03/vac-xin-jeev.jpg', '{"Vắc xin JEEV được chỉ định tiêm bắp.","Liều tiêm: 0,5ml cho mỗi mũi.","Trẻ từ 3-12 tháng tuổi: Tiêm 2 mũi cách nhau 28 ngày, tiêm nhắc lại sau 1-2 năm.","Trẻ từ 1-15 tuổi: Tiêm 2 mũi cách nhau 28 ngày, tiêm nhắc lại mỗi 3 năm.","Người lớn: Tiêm 2 mũi cách nhau 28 ngày."}', 'Vắc xin JEEV được nghiên cứu và sản xuất bởi Biological E. Limited (Ấn Độ).', 'Jeev', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng.","Tránh ánh sáng trực tiếp."}', 2455768, 'vac-xin-jeev', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (52, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Trẻ quá mẫn cảm với bất kỳ thành phần nào của vắc xin Infanrix IPV+Hib.","Trẻ đã từng có phản ứng quá mẫn sau mũi tiêm vắc xin bạch hầu, ho gà, uốn ván, bại liệt bất hoạt hoặc Hib trước đó.","Trẻ mắc các bệnh về não nhưng không rõ nguyên nhân, xảy ra trong vòng 7 ngày sau khi tiêm vắc xin ho gà trước đó.","Không khuyến cáo sử dụng cho người lớn, trẻ vị thành niên và trẻ em từ 5 tuổi trở lên."}', 'Bỉ', NULL, 'Vắc xin Infanrix IPV+Hib l à vắc xin kết hợp phòng được 5 loại bệnh trong 1 mũi tiêm, bao gồm: Ho gà, bạch hầu, uốn ván, bại liệt và các bệnh viêm phổi, viêm màng não mủ do H. Influenzae týp B (Hib). Tích hợp trong một loại vắc xin, Infanrix IPV+Hib giúp giảm số mũi tiêm, đồng nghĩa với việc hạn chế đau đớn cho bé khi phải tiêm quá nhiều.', 'Tổ chức Y tế Thế giới (WHO) khuyến cáo, Bạch hầu, Ho gà, Uốn ván, Bại liệt và các bệnh viêm phổi, viêm màng não...', 1, 20, 'https://vnvc.vn/wp-content/uploads/2021/06/vac-xin-Infanrix-IPV-Hib.jpg', '{"Vắc xin Infanrix IPV+Hib được chỉ định tiêm bắp sâu (ở mặt trước-bên đùi)."}', 'Vắc xin Infanrix IPV+Hib được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline ( GSK ) – Bỉ.', 'Infranrix IPV + Hib', '{"Vắc xin Infanrix IPV+Hib được bảo quản ở nhiệt độ 2-8 độ C. Không được để thành phần Infanrix IPV đông băng. Tránh ánh sáng."}', 1169499, 'vac-xin-5-trong-1-infanrix-ipv-hib', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (57, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với bất kỳ thành phần nào của vắc xin, bao gồm protein trứng gà.","Trẻ em dưới 6 tháng tuổi.","Người bị suy giảm miễn dịch bẩm sinh hoặc mắc phải.","Phụ nữ đang mang thai hoặc cho con bú (trừ trường hợp đặc biệt cần thiết).","Người trên 60 tuổi cần cân nhắc kỹ lợi ích và nguy cơ.","Người có bệnh lý tuyến ức."}', 'Pháp', NULL, 'Vắc xin Stamaril là vắc xin duy nhất cung cấp miễn dịch bảo vệ hiệu quả cao và tạo miễn dịch chủ động suốt đời khỏi virus thuộc họ Flaviviridae gây bệnh Sốt vàng nguy hiểm.', 'Bệnh Sốt vàng thuộc nhóm bệnh truyền nhiễm đặc biệt nguy hiểm do virus thuộc họ Flaviviridae gây ra. Bệnh lây truyền từ người sang...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2019/07/STAMARIL-vacxin-phong-benh-sot-vang.jpg', '{"Vắc xin Stamaril được chỉ định tiêm dưới da hoặc tiêm bắp.","Liều tiêm: 0,5ml cho mỗi mũi.","Chỉ cần tiêm 1 liều duy nhất để tạo miễn dịch suốt đời.","Tiêm cho người từ 9 tháng tuổi trở lên."}', 'Vắc xin Stamaril được nghiên cứu và sản xuất bởi Sanofi Pasteur (Pháp) - tập đoàn hàng đầu thế giới về dược phẩm và vắc xin.', 'STAMARIL phòng bệnh sốt vàng', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Tránh ánh sáng trực tiếp.","Không được đông băng.","Sau khi pha hồi chỉnh, vắc xin phải được sử dụng ngay."}', 2773024, 'stamaril-vac-xin-phong-benh-sot-vang', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (7, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Những người có tiền sử dị ứng nặng, quá mẫn với bất kỳ thành phần, tá dược nào của vắc xin.","Người đang bị sốt cao hoặc có tình trạng nhiễm trùng cấp tính nên hoãn tiêm phòng cho tới khi hồi phục."}', 'Mỹ', NULL, 'Pneumovax 23 , hay còn được biết đến với tên gọi vắc xin Polysaccharide phế cầu 23-valent, là vắc xin được chỉ định để ngăn ngừa các bệnh nhiễm trùng do vi khuẩn phế cầu (Streptococcus pneumoniae) gây ra như viêm phổi, viêm màng não, nhiễm khuẩn huyết (nhiễm trùng máu)…', 'Pneumovax 23 là vắc xin được chỉ định để ngăn ngừa các bệnh nhiễm trùng do vi khuẩn phế cầu (Streptococcus pneumoniae) gây ra như viêm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2024/08/vaccine-pneumovax-23.jpg', '{"Pneumovax 23 được tiêm dưới dạng dung dịch trong lọ đơn liều 0,5ml, qua đường tiêm bắp hoặc tiêm dưới da, thường là vào bắp tay (cơ delta) ở người lớn.","Không được tiêm vào mạch máu và phải thận trọng để đảm bảo kim không đi vào mạch máu.","Không được tiêm vắc xin trong da vì có liên quan đến tăng các phản ứng tại chỗ."}', 'Vắc xin Pneumovax 23 là sản phẩm do công ty dược phẩm đa quốc gia hàng đầu tại Mỹ – Merck Sharp & Dohme (MSD) nghiên cứu, phát triển và sản xuất. Đây là một trong những vắc xin phổ biến được sử dụng rộng rãi trên khắp thế giới để phòng ngừa các bệnh do vi khuẩn Streptococcus pneumoniae gây ra.', 'Pneumovax 23', '{"Pneumovax 23 cần được bảo quản ở nhiệt độ từ 2°C đến 8°C (36°F đến 46°F), tránh đông lạnh. Phải đảm bảo rằng vắc xin được bảo quản đúng quy định trước khi sử dụng để đảm bảo hiệu quả tối đa."}', 2133441, 'vac-xin-pneumovax-23', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (8, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Quá mẫn với các hoạt chất hoặc bất kỳ tá dược nào được liệt kê trong bảng thành phần của vắc xin."}', 'Ý', NULL, 'Vắc xin Bexsero được chỉ định để chủng ngừa cho trẻ và người lớn từ 2 tháng tuổi đến 50 tuổi (chưa đến sinh nhật 51 tuổi) chống lại bệnh não mô cầu xâm lấn do Neisseria meningitidis nhóm B gây ra với hiệu quả lên đến 95%.', 'Vắc xin Bexsero được chỉ định để chủng ngừa cho trẻ và người lớn từ 2 tháng tuổi đến 50 tuổi (chưa đến sinh nhật...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2024/02/bexsero.jpg', '{"Vắc xin Bexsero được dùng dưới dạng tiêm bắp sâu, nên ưu tiên tiêm ở mặt trước bên cơ đùi của nhũ nhi hoặc vùng cơ delta cánh tay trên ở những đối tượng lớn hơn.","Nếu phải tiêm đồng thời nhiều loại vắc xin khác thì phải tiêm ở nhiều vị trí riêng biệt."}', 'Vắc xin Bexsero là loại vắc xin đa thành phần (tái tổ hợp, hấp phụ) do hãng dược phẩm Glaxosmithkline – GSK sản xuất.', 'Bexsero', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 960542, 'vac-xin-bexsero', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (9, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không dùng vắc xin Prevenar-13 trong thai kỳ.","Không tiêm vắc xin Prevenar-13 với người quá mẫn cảm với thành phần trong vắc xin hoặc với độc tố bạch hầu."}', 'Bỉ', NULL, 'Vắc xin Prevenar 13 là vắc xin phế cầu , phòng các bệnh phế cầu khuẩn xâm lấn gây nguy hiểm cho trẻ em và người lớn như viêm phổi, viêm màng não, nhiễm khuẩn huyết (nhiễm trùng máu), viêm tai giữa cấp tính,… do 13 chủng phế cầu khuẩn Streptococcus Pneumoniae gây ra (type 1, 3, 4, 5, 6A, 6B, 7F, 9V, 14, 18C, 19A, 19F và 23F).', 'Mỗi năm, các bệnh gây ra do khuẩn phế cầu đang đe dọa tính mạng hàng tỷ người trên thế giới: Gần 1 triệu ca...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2019/11/prevenar-13.jpg', '{"Vắc xin Prevenar-13 được chỉ định tiêm bắp (vùng cơ delta ) với liều 0.5ml"}', 'Vắc xin Prevenar-13 được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học – Pfizer (Mỹ). Prevenar-13 được sản xuất tại Bỉ.', 'Prevenar 13', '{"Bảo quản ở nhiệt độ lạnh (từ 2 – 8 độ C). Không được đóng băng."}', 653565, 'prevenar-13-vac-xin-phong-benh-viem-phoi-viem-mang-nao-viem-tai-giua-nhiem-khuan-huyet-phe-cau-khuan', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (50, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Quá mẫn với bất kỳ thành phần nào của vắc xin.","Không dùng vắc xin cho đối tượng đang sốt hoặc suy dinh dưỡng.","Bệnh tim mạch, rối loạn chức năng gan, thận.","Có tiền sử quá mẫn với kanamycin và Erythromycin.","Có tiền sử co giật trong vòng 1 năm trước khi tiêm vắc xin.","Suy giảm miễn dịch tế bào.","Có thai hoặc 2 tháng trước khi định có thai.","Đã tiêm phòng vắc xin sống khác trong vòng 1 tháng gần đây (Sởi, quai bị, rubella, lao, bại liệt).","Suy giảm miễn dịch tiên phát hoặc mắc phải như AIDS hoặc các biểu hiện lâm sàng của nhiễm virus gây suy giảm miễn dịch ở người.","Trẻ em dưới 12 tháng tuổi.","Bệnh nhân mắc bệnh bạch cầu tủy cấp, bệnh bạch cầu tế bào lympho T hoặc u lympho ác tính.","Bệnh nhân bị ức chế mạnh hệ thống miễn dịch do xạ trị hoặc giai đoạn tấn công trong điều trị bệnh bạch cầu."}', 'Hàn Quốc', NULL, 'Vắc xin Varicella tạo miễn dịch dịch chủ động phòng bệnh thủy đậu do virus Varicella Zoster gây ra.', 'Thủy đậu là bệnh truyền nhiễm cấp tính, có thể gây ra nhiều biến chứng nguy hiểm: Có đến 20% tỷ lệ trẻ tử vong...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-varicella-1.jpg', '{"Vắc xin phải được sử dụng ngay không quá 30 phút sau khi hoàn nguyên với nước hồi chỉnh cung cấp.","Tiêm dưới da. Liều đơn 0.5ml"}', 'Vắc xin Varicella được nghiên cứu và sản xuất bởi Green Cross – Hàn Quốc.', 'Varicella', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Tránh ánh sáng trực tiếp."}', 1076221, 'vac-xin-varicella', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (51, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với bất kỳ thành phần nào của vắc xin, bao gồm neomycin và gelatin.","Người bị suy giảm miễn dịch bẩm sinh hoặc mắc phải.","Phụ nữ đang mang thai hoặc dự định mang thai trong vòng 1 tháng.","Người đang sốt cao hoặc mắc bệnh cấp tính nặng.","Người đã tiêm immunoglobulin hoặc truyền máu trong vòng 3 tháng.","Người có tiền sử giảm tiểu cầu hoặc ban xuất huyết giảm tiểu cầu."}', 'Ấn Độ', NULL, 'Sởi là bệnh truyền nhiễm cấp tính do virus Paramyxoviridae gây ra, có thể gây viêm tai giữa , viêm thanh quản, viêm phế quản – phổi, viêm màng não,…', 'Vắc xin MMR là vắc xin sống, giảm độc lực, được đông khô và có nước hồi chỉnh kèm theo. MMR tạo miễn dịch chủ...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2022/06/MMR.jpg', '{"Vắc xin được tiêm theo đường tiêm dưới da sâu ở vị trí mặt trước bên đùi đối với trẻ nhỏ và vị trí bắp tay đối với trẻ lớn hơn."}', 'Vắc xin MMR được nghiên cứu và phát triển bởi công ty Serum Institute of India Ltd.', 'Measles – Mumps – Rubella', '{"Cả vắc xin và nước hồi chỉnh đều phải tránh ánh sáng. Cần bảo quản vắc xin ở chỗ tối, nhiệt độ từ 2-8 độ C. Nước hồi chỉnh phải bảo quản nơi mát, không để đông băng."}', 1665149, 'vac-xin-mmr', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (53, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không nên dùng Engerix B cho những đối tượng được biết là quá mẫn cảm với một trong các thành phần của vắc xin, hoặc những đối tượng có biểu hiện mẫn cảm với vắc xin ở lần tiêm trước.","Nhiễm HIV không được xem là chống chỉ định đối với việc chủng ngừa viêm gan B."}', 'Bỉ', NULL, 'Vắc xin Engerix B phòng bệnh do virus viêm gan B – loại virus này có thể lây truyền qua đường máu, qua quan hệ tình dục và từ mẹ truyền sang con .', 'Vắc xin phòng viêm gan B cần tiêm mấy mũi? Lịch tiêm viêm gan B cho trẻ Tiêm vắc xin rồi có bị lây bệnh...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-engerix-b.jpg', '{"Engerix B được chỉ định tiêm bắp (vùng cơ delta). Ngoại lệ với những bệnh nhân bị rối loạn chảy máu hay giảm tiểu cầu có thể tiêm dưới da."}', 'Vắc xin Engerix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ.', 'Engerix B', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Không để đông băng."}', 2277481, 'engerix-b-vac-xin-phong-viem-gan-b', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (54, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người mẫn cảm với bất kỳ thành phần nào của Euvax B."}', 'Hàn Quốc', NULL, 'Vắc xin Euvax B phòng bệnh do virus viêm gan B – loại virus này có thể lây truyền qua đường máu, qua quan hệ tình dục và từ mẹ truyền sang con .', 'Viêm gan B là bệnh truyền nhiễm gây ra bởi virus viêm gan B (Hepatitis virus B), được mệnh danh là “kẻ giết người thầm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/EUVAX.jpg', '{"Euvax B chỉ dùng đường tiêm bắp, không nên tiêm ở vùng mông, và không được tiêm tĩnh mạch.","Phải lắc kỹ trước khi dùng, bởi vì trong quá trình bảo quản vắc xin có thể trở thành dạng chất lắng trắng mịn với dịch nổi bên trên trong suốt không màu."}', 'Vắc xin Euvax được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học – Sanofi Pasteur (Pháp). Vắc xin Euvax sản xuất tại Hàn Quốc.', 'Euvax B', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Không được để đông băng."}', 2369385, 'vac-xin-euvax-b', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (56, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không sử dụng Typhoid Vi cho trường hợp có tiền sử dị ứng với một trong các thành phần của vắc xin.","Phụ nữ đang mang thai, trường hợp bắt buộc phải tiêm, cần hỏi ý kiến của bác sĩ.","Trong trường hợp bị sốt hoặc mắc bệnh cấp tính, nên hoãn tiêm vắc xin."}', 'Việt Nam', NULL, 'Vắc xin Typhoid VI phòng ngừa bệnh Thương hàn (bệnh về đường tiêu hóa) gây ra bởi vi khuẩn thương hàn (Salmonella typhi) cho trẻ từ trên 2 tuổi và người lớn.', 'Thương hàn là bệnh truyền nhiễm cấp tính do vi khuẩn Salmonella typhi gây ra. Bệnh dễ dàng lây nhiễm qua đường tiêu hóa và...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2019/12/vac-xin-Typhoid-Vi.jpg', '{"Vắc xin phòng bệnh thương hàn Typhoid Vi được chỉ định tiêm dưới da hoặc tiêm bắp với liều 0.5ml."}', '{"Vắc xin thương hàn Typhoid Vi được sản xuất bởi nhà sản xuất vắc xin và sinh phẩm uy tín tại Việt Nam – Viện Pasteur Đà Lạt ( DAVAC )."}', 'Typhoid VI', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Không được đóng băng."}', 2158560, 'typhoid-vi-polysaccharide-vi-vac-xin-phong-benh-thuong-han', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (34, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không dùng Rotavin cho trẻ quá mẫn sau khi uống liều vắc xin đầu tiên, hoặc quá mẫn với bất cứ thành phần nào của thuốc.","Không sử dụng vắc xin Rotavin nếu trẻ có bệnh lý nặng, cấp tính, sốt cao, trẻ đang bị tiêu chảy hoặc nôn.","Không sử dụng Rotavin cho trẻ bị dị tật bẩm sinh đường tiêu hóa, bị lồng ruột hay đang bị suy giảm miễn dịch nặng.","Vắc xin không dự kiến sử dụng ở người lớn. Không có chỉ định sử dụng vắc xin ở phụ nữ có thai và cho con bú.","Việc cho con bú không làm giảm hiệu quả của vắc xin, nên vẫn có thể cho con bú sau khi trẻ đã sử dụng vắc xin."}', 'Việt Nam', NULL, 'Vắc xin Rotavin là vắc xin sống giảm độc lực có tác dụng phòng nguy cơ nhiễm virus Rota – nguyên nhân gây tình trạng tiêu chảy cấp ở trẻ nhỏ. Vắc xin có dung dịch màu hồng, được sản xuất trên dây chuyền công nghệ hiện đại, đạt các tiêu chuẩn của Tổ chức Y tế Thế giới (WHO) về vắc xin uống.', 'Tiêu chảy cấp do virus Rota là bệnh cấp tính do virus gây nên. Bệnh thường gặp ở trẻ nhỏ với biểu hiện: nôn ói,...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2020/05/vac-xin-rotavin-1.jpg', '{"Vắc xin Rotavin được sử dụng theo đường uống.","Liều dùng: 2ml cho mỗi liều.","Lịch uống: 3 liều, liều 1 khi trẻ 6-12 tuần tuổi, các liều tiếp theo cách nhau tối thiểu 4 tuần.","Phải hoàn thành 3 liều trước khi trẻ 32 tuần tuổi."}', 'Vắc xin Rotavin được nghiên cứu và sản xuất bởi Polyvac – Việt Nam.', 'Rotavin', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 2164975, 'rotavin-m1-vac-xin-phong-benh-tieu-chay-cap-rotavirus', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (2, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn cảm với bất cứ thành phần nào có trong vắc xin hoặc hoặc sau một lần tiêm MenQuadfi trước đó hoặc với vắc xin có chứa cùng thành phần đã tiêm trước đây."}', 'Mỹ', NULL, 'Vắc xin MenQuadfi là vắc xin polysaccharide cộng hợp giải độc tố uốn ván (TT), được chỉ định sử dụng để phòng ngừa các bệnh do vi khuẩn não mô cầu Neisseria Meningitidis nhóm A, C, Y, W-135 gây ra, bao gồm: các bệnh não mô cầu xâm lấn (viêm màng não, nhiễm khuẩn huyết, viêm phổi du khuẩn huyết) và các bệnh não mô cầu không xâm lấn (viêm phổi, viêm khớp, viêm màng niệu đạo, viêm kết mạc…).', 'Vắc xin MenQuadfi là vắc xin polysaccharide cộng hợp giải độc tố uốn ván (TT), được chỉ định sử dụng để phòng ngừa các bệnh...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2025/06/vac-xin-menquadfi.jpg', '{"Vắc xin MenQuadfi được chỉ định tiêm bắp, tốt nhất là ở vùng cơ delta hoặc mặt trước – ngoài đùi tùy thuộc vào độ tuổi và khối lượng cơ của người tiêm chủng."}', 'Vắc xin MenQuadfi được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp), sản xuất tại Mỹ.', 'MenQuadfi', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng. Loại bỏ vắc xin nếu bị đông băng.","Bảo quản trong bao bì gốc để tránh ánh sáng."}', 1976336, 'vac-xin-menquadfi', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (4, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn cảm với các thành phần hoạt chất hoặc bất kỳ tá dược nào có trong vắc xin, hoặc với bất kỳ vắc xin nào có chứa giải độc tố bạch hầu."}', 'Ireland', NULL, 'Vắc xin Vaxneuvance – vắc xin cộng hợp polysaccharide phế cầu khuẩn (15 giá, hấp phụ) là vắc xin được chỉ định sử dụng để phòng ngừa các bệnh do vi khuẩn phế cầu (Streptococcus pneumoniae) gây ra bao gồm: Các bệnh phế cầu xâm lấn như viêm phổi nhiễm khuẩn huyết, viêm màng não, nhiễm khuẩn huyết (nhiễm trùng máu)… và các bệnh phế cầu không xâm lấn như viêm phổi, viêm tai giữa và viêm xoang…', 'Vắc xin Vaxneuvance 15 - vắc xin cộng hợp polysaccharide phế cầu khuẩn (15 giá, hấp phụ) là vắc xin được chỉ định sử dụng...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2025/05/vac-xin-phe-cau-vaxneuvance-15-1.jpg', '{"Vaxneuvance được sản xuất dưới dạng dung dịch trong lọ đơn liều 0,5ml.","Tiêm bắp, tại ⅓ giữa mặt trước bên ngoài của đùi ở trẻ nhỏ hoặc cơ delta của phần trên cánh tay ở trẻ em, người lớn.","Không được tiêm vào mạch máu và tiêm trong da."}', 'Vắc xin Vaxneuvacne được nghiên cứu, sản xuất và phân phối bởi Công ty MSD (Mỹ), sản xuất tại Ireland.', 'Vaxneuvance', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Không được đông băng. Loại bỏ vắc xin nếu bị đông băng.","Bảo quản trong bao bì gốc để tránh ánh sáng."}', 1854593, 'vac-xin-vaxneuvance-15', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (49, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Mẫn cảm với bất kỳ thành phần nào của vắc xin, bao gồm cả: gelatin, neomycin.","Người đang mắc các bệnh bạch, loạn sản máu, các bệnh u lympho, hoặc các khối u ác tính ảnh hưởng đến hệ bạch huyết, tủy xương.","Người đang điều trị bằng các thuốc ức chế miễn dịch (bao gồm corticoid liều cao). Hoặc đang mắc bệnh suy giảm miễn dịch mắc phải (AIDS).","Người đã có miễn dịch do mắc phải.","Người đang mắc các bệnh lý tiến triển, sốt cao trên 38 độ C. Tuy nhiên không có chống chỉ định cho trường hợp sốt nhẹ.","Người mắc bệnh lao thể hoạt động chưa được điều trị."}', 'Mỹ', NULL, 'Vắc xin Varivax tạo miễn dịch chủ động phòng bệnh Thủy đậu do virus Varicella Zoster gây ra.', 'Thủy đậu là bệnh truyền nhiễm cấp tính, có thể gây ra nhiều biến chứng nguy hiểm: Có đến 20% tỷ lệ trẻ tử vong...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-varivax.jpg', '{"Vắc xin Varivax được chỉ định tiêm dưới da. Liều đơn 0.5ml"}', 'Vắc xin Varivax được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới Merck Sharp and Dohm (Mỹ).', 'Varivax', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 1790643, 'varivax-vac-xin-phong-thuy-dau', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (55, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người nhạy cảm với bất kỳ thành phần nào trong vắc xin.","Người bị bệnh tim, gan, thận.","Mệt mỏi, sốt cao hoặc nhiễm trùng tiến triển.","Người đang mắc bệnh tiểu đường hoặc suy dinh dưỡng.","Bệnh ung thư máu và các bệnh ác tính nói chung.","Phụ nữ có thai.","Bệnh quá mẫn."}', 'Việt Nam', NULL, 'Jevax là vắc xin phòng viêm não Nhật Bản được chỉ định cho trẻ em từ 12 tháng tuổi trở lên và người lớn.', 'Viêm não Nhật Bản là căn bệnh nguy hiểm, rất khó phát hiện do triệu chứng ban đầu rất giống với các bệnh viêm nhiễm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/JEVAX.jpg', '{"Tiêm dưới da."}', '{"Vắc xin Jevax được nghiên cứu và sản xuất bởi Vabiotech – Việt Nam."}', 'Jevax', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C và không được đông băng."}', 688595, 'jevax-vac-xin-phong-viem-nao-nhat-ban-b', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (36, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Có tiền sử sốc phản vệ với vắc xin cúm IVACFLU-S.","Tiền sử mẫn cảm với bất cứ chủng virus cúm nào trong thành phần vắc xin.","Tiền sử mẫn cảm với cao su (của nút lọ đựng vắc xin) hoặc các thành phần pha chế vắc xin như dung dịch PBS.","Người có hội chứng Guilain-Barre, có rối loạn thần kinh.","Người bị động kinh đang tiến triển hoặc có tiền sử co giật.","Người có cơ địa mẫn cảm nặng với các vắc xin khác (đã từng bị sốc phản vệ khi tiêm vắc xin)","Hoãn tiêm chủng nếu người tiêm có tình trạng bệnh lý mà cán bộ tiêm chủng nhận thấy không an toàn khi tiêm vắc xin (sốt trên 38oC; bệnh nhiễm trùng cấp tính…) hoặc không đảm bảo hiệu quả của vắc xin (đang dùng thuốc ức chế miễn dịch trên 14 ngày, mắc lao thể hoạt động…)."}', 'Việt Nam', NULL, 'Vắc xin Ivacflu – S phòng 3 chủng cúm A(H3N2), cúm A(H1N1),và cúm B (Victoria/Yamagata).', 'Vắc xin Ivacflu-S là vắc xin cúm tam giá dựa trên kháng nguyên bề mặt được phân lập từ các chủng A và B, cho...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-ivacflu-s.jpg', '{"Vắc xin Ivacflu-S được sử dụng qua đường tiêm bắp. Vị trí tiêm: Cơ delta (bắp cánh tay). Không được tiêm vắc xin vào mạch máu."}', 'Vắc xin Ivacflu – S được nghiên cứu và sản xuất bởi Viện Vắc xin và Sinh phẩm Y tế IVAC – Việt Nam.', 'Ivacflu-S', '{"Nhiệt độ bảo quản vắc xin từ 2 đến 8 độ C, tránh đông băng. Bảo quản vắc xin nguyên trong hộp để tránh ánh sáng."}', 723098, 'vac-xin-ivacflu-s', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (37, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Trường hợp mẫn cảm với bất cứ thành phần nào của vắc xin;","Phụ nữ có thai;","Trường hợp bị nhiễm trùng cấp tính đường hô hấp, mắc bệnh lao tiến triển chưa được điều trị;","Người bị suy giảm miễn dịch (trừ trẻ em bị HIV);","Người bị bệnh ác tính."}', 'Việt Nam', NULL, 'Vắc xin MVVAC tạo miễn dịch chủ động phòng bệnh sởi cho trẻ từ 9 tháng tuổi trở lên và người chưa có kháng thể sởi.', 'Trước khi có vắc xin, bệnh sởi gây ra cái chết cho khoảng 2,6 triệu người mỗi năm trên toàn thế giới. Đến nay, sởi...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-MVVAC.jpg', '{"Vắc xin MVVAC chỉ được tiêm dưới da, không được tiêm tĩnh mạch."}', 'Vắc xin MVVAC được nghiên cứu và sản xuất bởi Polyvac – Việt Nam.', 'Mvvac', '{"Lọ vắc xin sởi dạng đông khô được bảo quản ở khoảng nhiệt độ  ≤ 8 độ C và tránh ánh sáng.","Lọ nước pha tiêm được bảo quản nhiệt độ dưới 30oC, không được làm đông băng.","Lọ vắc xin sau khi pha hồi chỉnh bằng nước pha tiêm sẽ được bảo quản ở nhiệt độ 2 độ C đến 8 độ C và chỉ sử dụng trong vòng 6 giờ."}', 1217675, 'vac-xin-mvvac', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (13, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm vắc xin phòng lao cho trẻ có dấu hiệu hoặc triệu chứng bệnh AIDS.","Các trường hợp chống chỉ định khác theo hướng dẫn của manufacturer vắc xin lao."}', 'Việt Nam', NULL, 'Vắc xin BCG phòng ngừa hiệu quả các hình thái lao nguy hiểm, trong đó có lao viêm màng não với độ bảo vệ lên tới 70%. Vắc xin được khuyến cáo cho trẻ sơ sinh và trẻ nhỏ, chỉ cần tiêm 1 liều duy nhất có thể bảo vệ trọn đời, không cần tiêm nhắc lại.', 'Bé tiêm lao bị sai vị trí, vết thương mưng mủ có sao không? Vắc xin lao có tiêm chung với vắc xin 6 trong...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-bcg.jpg', '{"Tiêm trong da chính xác, ở mặt ngoài phía trên cánh tay hoặc vai trái.","Nhân viên y tế cần sử dụng bơm kim tiêm riêng để tiêm vắc xin BCG."}', 'Vắc xin phòng Lao – BCG (Bacille Calmette-Guerin) được sản xuất tại Việt Nam.', 'BCG', '{"Vắc xin BCG được bảo quản ở nhiệt độ 2-8 độ C (vắc xin không bị hỏng bởi đông băng nhưng dung môi thì không được đông băng). Sau khi hoàn nguyên dung dịch tiêm cần được bảo quản ở nhiệt độ 2-8 độ C trong vòng 6 giờ. Phần còn lại của lọ vắc xin sau mỗi buổi tiêm chủng hoặc sau 6 giờ cần phải hủy bỏ."}', 2684365, 'bcg-vac-xin-phong-lao', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (14, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người mẫn cảm với các thành phần có trong vắc xin.","Không được tiếp tục dùng Gardasil nếu có phản ứng quá mẫn với lần tiêm trước."}', 'Mỹ', NULL, 'Vắc xin Gardasil (Mỹ) phòng bệnh ung thư cổ tử cung, âm hộ, âm đạo, các tổn thương tiền ung thư và loạn sản, mụn cóc sinh dục, các bệnh lý do nhiễm virus HPV, được chỉ định dành cho trẻ em và phụ nữ trong độ tuổi từ 9-26 tuổi.', 'Địa điểm và giá tiêm vắc xin ung thư cổ tử cung Đã quan hệ có tiêm phòng HPV được không? Bị nhiễm HPV có...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-gardasil.jpg', '{"Tiêm bắp với liều 0.5ml vào vùng cơ Delta vào phần trên cánh tay hoặc phần trước bên của phía trên đùi.","Không được tiêm tĩnh mạch. Chưa có nghiên cứu về đường tiêm trong da hoặc dưới da nên không có khuyến cáo tiêm theo hai đường tiêm này"}', '{"Vắc xin Gardasil được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới Merck Sharp and Dohm (Mỹ)."}', 'Gardasil 4', '{"Vắc xin được bảo quản ở nhiệt độ từ 2-8 độ C, không được đông băng và tránh ánh sáng.","Khi đưa ra khỏi tủ bảo quản nên sử dụng vắc xin ngay nhưng cũng có thể để ngoài nhiệt độ phòng <25 độ C trong thời gian 3 ngày mà không bị ảnh hưởng đến chất lượng vắc xin. Sau 3 ngày, vắc xin cần được loại bỏ."}', 2024859, 'gardasil-vac-xin-phong-ung-thu-co-tu-cung', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (15, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Synflorix không được tiêm cho các đối tượng quá mẫn với bất kỳ thành phần nào trong vắc xin."}', 'Bỉ', NULL, 'Vắc xin Synflorix phòng tránh 10 chủng vi khuẩn phế cầu ( Streptococcus pneumoniae) gây các bệnh như: Hội chứng nhiễm trùng, viêm màng não, viêm phổi, nhiễm khuẩn huyết và viêm tai giữa cấp,…', 'Mỗi năm, các bệnh gây ra do khuẩn phế cầu đang đe dọa tính mạng hàng tỷ người trên thế giới: Gần 1 triệu ca...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/Synflorix-1.jpg', '{"Vắc xin Synflorix tiêm bắp ở mặt trước – bên đùi của trẻ nhỏ và tiêm ở cơ delta cánh tay của trẻ lớn. Không được tiêm tĩnh mạch hoặc tiêm trong da đối với vắc xin Synflorix."}', 'Vắc xin Synflorix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ.', 'Synflorix', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C, không được để đông băng ( * )."}', 756700, 'synflorix-vac-xin-phong-viem-nao-viem-phoi-nhiem-khuan-huyet-viem-tai-giua-h-influenzae-khong-dinh-tuyp', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (16, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Tiền sử quá mẫn với thành phần của vắc xin. Quá mẫn sau khi tiêm vắc xin bạch hầu, ho gà hoặc uốn ván trước đó.","Người đã từng bị các biểu hiện về não: hôn mê, bất tỉnh, co giật kéo dài.","Người có tiền sử giảm tiểu cầu thoáng qua hoặc biến chứng thần kinh sau chủng ngừa bạch hầu và/hoặc uốn ván trước đó."}', 'Bỉ', NULL, 'Vắc xin Boostrix (Bỉ) tạo đáp ứng kháng thể chống 3 bệnh ho gà – bạch hầu – uốn ván.', 'Ho gà - Bạch hầu - Uốn ván là những căn bệnh nguy hiểm hàng đầu đối với trẻ nhỏ đặc biệt trong những năm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2020/02/vac-xin-boostrix.jpg', '{"Vắc xin Boostrix được chỉ định tiêm bắp với liều 0.5ml. Không được tiêm dưới da hoặc tĩnh mạch. Ở trẻ lớn và người lớn, thường tiêm vào cơ delta còn trẻ nhỏ thường vào mặt trước – bên đùi."}', 'Vắc xin Boostrix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ.', 'Boostrix', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C. Không được để đông băng."}', 933573, 'boostrix', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (17, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với thành phần của vắc xin.","Bệnh lý não (ví dụ hôn mê, giảm tri giác, co giật kéo dài) xảy ra trong vòng 7 ngày sau khi tiêm một liều vắc xin bất kỳ có chứa thành phần ho gà mà không xác định được nguyên nhân nào khác."}', 'Canada', NULL, 'Vắc xin Adacel tạo miễn dịch chủ động nhắc lại nhằm phòng bệnh ho gà – bạch hầu – uốn ván.', 'Bạch hầu - Ho gà - Uốn ván là những căn bệnh nguy hiểm hàng đầu đối với trẻ nhỏ đặc biệt trong những năm...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/Adacel.jpg', '{"Tiêm bắp."}', 'Vắc xin Adacel ngừa ho gà – bạch hầu – uốn ván được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur – Pháp. Vắc xin Adacel được sản xuất tại Canada.', 'Adacel', '{"Vắc xin được bảo quản ở nhiệt độ từ +2 đến +8 độ C. Không được để đông băng."}', 243153, 'vac-xin-adacel', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (18, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Tiền sử quá mẫn với thành phần của vắc xin. Có biểu hiện dị ứng với kháng nguyên bạch hầu và uốn ván ở những lần tiêm trước.","Tạm hoãn tiêm vắc xin uốn ván – bạch hầu hấp phụ (Td) trong những trường hợp có bệnh nhiễm trùng cấp tính, sốt chưa rõ nguyên nhân.","Không tiêm bắp cho người có rối loạn chảy máu như Hemophilia hoặc giảm tiểu cầu."}', 'Việt Nam', NULL, 'Vắc xin uốn ván – bạch hầu hấp phụ (Td) được chỉ định cho trẻ em lứa tuổi lớn (từ 7 tuổi trở lên) và người lớn nhằm gây miễn dịch, phòng các bệnh uốn ván và bạch hầu.', 'Vắc xin uốn ván - bạch hầu hấp phụ (Td) được chỉ định cho trẻ em lứa tuổi lớn (từ 7 tuổi trở lên) và...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2020/07/vac-xin-uon-van-bach-hau-hap-phu-td.jpg', '{"Vắc xin uốn ván - bạch hầu hấp phụ (Td) được chỉ định tiêm bắp sâu.","Liều tiêm: 0,5ml cho mỗi mũi.","Lịch tiêm cơ bản: 2 mũi cách nhau ít nhất 1 tháng.","Tiêm nhắc lại mỗi 10 năm để duy trì miễn dịch."}', '{"Là vắc xin được sản xuất bởi Viện vắc xin và sinh phẩm y tế Nha Trang IVAC (Việt Nam)."}', 'Uốn ván, bạch hầu hấp phụ', '{"Vắc xin nên được bảo quản ở nhiệt độ từ 2 đến 8 độ C, và không được để đông băng.","Để xa tầm tay trẻ em."}', 1236990, 'vac-xin-uon-van-bach-hau-hap-phu-td-viet-nam', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (19, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm cho người dị ứng, quá mẫn với bất kỳ thành phần nào của vắc xin.","Không tiêm cho đối tượng có các biểu hiện dị ứng ở lần tiêm vắc xin trước.","Không dùng cho người có các dấu hiệu, triệu chứng thần kinh sau khi tiêm các liều trước đó.","Hoãn tiêm với các trường hợp sốt cao hoặc đang mắc các bệnh cấp tính."}', 'Việt Nam', NULL, 'Vắc xin uốn ván hấp phụ (TT) giúp tạo miễn dịch chủ động phòng bệnh uốn ván cho người lớn và trẻ em.', 'Uốn ván là bệnh nhiễm trùng cấp tính do vi khuẩn yếm khí Clostridium tetani gây ra. Theo Tổ chức Y tế Thế giới (WHO),...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-uon-van-hap-phu-tt.jpg', '{"Vắc xin uốn ván hấp phụ (TT) được chỉ định tiêm bắp sâu, liều tiêm 0,5ml.","Không tiêm tĩnh mạch trong bất cứ trường hợp nào.","Lắc tan đều trước khi tiêm."}', 'Vắc xin uốn ván hấp phụ (TT) được nghiên cứu và sản xuất bởi Viện vắc xin và sinh phẩm y tế Nha Trang IVAC – Việt Nam.', 'uốn ván hấp phụ', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C. Không được để đông đá vắc xin. Loại bỏ vắc xin nếu bị đông đá."}', 2832697, 'vac-xin-vat', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (20, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người có tiền sử dị ứng nghiêm trọng với bất kỳ thành phần nào của vắc xin;","Người có phản ứng nặng của lần tiêm chủng trước đối với vắc xin Sởi, Sởi – Rubella (MR), Sởi – Quai bị – Rubella (MMR);","Phụ nữ mang thai;","Người bị mắc bệnh lao tiến triển chưa được điều trị hay suy giảm miễn dịch;","Người bị bệnh ác tính."}', 'Việt Nam', NULL, 'Vắc xin MRVAC là chế phẩm sinh học có chứa kháng nguyên của virus sởi và rubella đã được giảm độc lực, không còn khả năng gây bệnh nhưng vẫn đảm bảo khả năng kích thích hệ thống miễn dịch sản sinh kháng thể đặc hiệu, chủ động chống lại sự tấn công và xâm nhập của virus sởi và rubella. Nhờ đó, bảo vệ người được tiêm khỏi nguy cơ mắc bệnh sởi và rubella.', 'MRVAC là vắc xin phối hợp 2 trong 1 phòng bệnh Sởi và Rubella có trong chương trình Tiêm chủng Mở rộng, chỉ định chủng...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2024/09/vac-xin-mrvac.jpg', '{"MRVAC được chỉ định tiêm dưới da;","Không được tiêm tĩnh mạch"}', 'Vắc xin MRVAC là một trong những thành tựu quan trọng của ngành y tế Việt Nam trong công tác phòng ngừa bệnh tật và ngăn chặn nguy cơ bùng phát dịch bệnh gây ra bởi 2 căn bệnh truyền nhiễm nguy hiểm hàng đầu là sởi và rubella. Vắc xin MRVAC được nghiên cứu, phát triển và sản xuất bởi Trung tâm nghiên cứu sản xuất vắc xin và sinh phẩm y tế (POLYVAC) tại Việt Nam, đánh dấu bước tiến quan trọng trong việc tự chủ nguồn cung cấp vắc xin trong nước.', 'Sởi – Rubella MRVAC', '{"Lọ vắc xin MRVAC dạng đông khô được bảo quản ở nhiệt độ ≤ 80C và tránh ánh sáng.","Lọ nước pha tiêm được bảo quản nhiệt độ không quá 300C, không được làm đông băng.","Phải đảm bảo vắc xin được bảo quản đúng quy định trước khi sử dụng để đảm bảo hiệu quả tối đa.","Để xa tầm tay của trẻ em."}', 2576385, 'vac-xin-mrvac', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (21, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không tiêm bắp ở người có rối loạn chảy máu như hemophilia hoặc giảm tiểu cầu."}', 'Ấn Độ', NULL, 'Vắc xin Abhayrab có tác dụng tạo miễn dịch chủ động phòng bệnh dại cho cả người lớn và trẻ em, sau khi tiếp xúc hoặc bị con vật nghi bị dại cắn.', 'Bệnh dại là bệnh truyền nhiễm cấp tính do virus Rabies gây ra. Theo thống kê từ Tổ chức Y tế Thế giới (WHO), mỗi...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-abhayrab-1.jpg', '{"Tiêm bắp (IM): người lớn tiêm ở vùng cơ Delta cánh tay, trẻ em tiêm ở mặt trước bên đùi. Không tiêm vào vùng mông.","Trong một số trường hợp có thể áp dụng tiêm trong da (ID), tiêm ở cẳng tay hoặc cánh tay."}', 'Vắc xin Abhayrab phòng bệnh dại tế bào vero tinh chế do công ty Human Biological Institute (Ấn Độ) sản xuất.', 'Abhayrab', '{"Bảo quản ở nhiệt độ lạnh (từ 2 – 8 độ C). Không được đóng băng."}', 2472838, 'vac-xin-abhayrab', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (22, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không được tiêm trong da ở những trường hợp sau: đang điều trị dài ngày bằng các thuốc ức chế miễn dịch (bao gồm cả corticoid), và thuốc Chloroquin ; người bị khiếm khuyết miễn dịch; trẻ em hoặc người có vết cắn nặng phần đầu, cổ, hay đến khám trễ sau khi bị vết thương."}', 'Pháp', NULL, 'Vắc xin Verorab có tác dụng tạo miễn dịch chủ động phòng bệnh dại cho cả người lớn và trẻ em, sau khi tiếp xúc hoặc bị con vật nghi bị dại cắn.', 'Theo thống kê từ Tổ chức Y tế Thế giới (WHO), mỗi năm có đến 59.000 người tử vong do dại. Dại là căn bệnh...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-verorab-1.jpg', '{"Tiêm bắp: với liều 0.5ml vắc xin đã hoàn nguyên, ở người lớn vào vùng cơ Delta ở cánh tay, trẻ nhỏ tiêm ở mặt trước – bên đùi. Không tiêm ở vùng mông.","Tiêm trong da: với liều 0.1ml vắc xin đã hoàn nguyên (bằng 1/5 liều tiêm bắp)."}', '{"Vắc xin Verorab là vắc xin phòng dại cho trẻ em và người lớn, do tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp) sản xuất."}', 'Verorab', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C."}', 2065332, 'verorab-vac-xin-phong-dai', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (26, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Những người mẫn cảm với bất cứ thành phần nào của vắc xin;","Mắc các bệnh bẩm sinh;","Mệt mỏi, sốt cao hoặc phản ứng toàn thân với bất kỳ một bệnh nhiễm trùng đang tiến triển;","Bệnh tim, bệnh thận hoặc bệnh gan chưa điều trị ổn định;","Bệnh tiểu đường chưa điều trị ổn định;","Bệnh ung thư máu và các bệnh ác tính nói chung;","Bệnh quá mẫn."}', 'Việt Nam', NULL, 'Vắc xin phòng viêm gan B tái tổ hợp Gene-HBvax phòng bệnh do virus viêm gan B – loại virus này có thể lây truyền qua đường máu, qua quan hệ tình dục và từ mẹ truyền sang con với khả năng lây nhiễm cao gấp 10 lần so với virus HIV. 25% trong bệnh nhân viêm gan siêu vi B sẽ phát sinh những vấn đề nghiêm trọng về gan, kể cả ung thư gan.', 'Vắc xin phòng viêm gan B tái tổ hợp Gene-HBvax phòng bệnh do virus viêm gan B – loại virus này có thể lây truyền...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2023/03/vac-xin-Gene-HBvax.jpg', '{"Vắc xin Gene-HBvax được chỉ định tiêm bắp. Không được tiêm đường tĩnh mạch hoặc trong da. Ở người lớn thì tiêm vắc xin vào vùng cơ delta, song ở trẻ sơ sinh và trẻ nhỏ thì nên tiêm vào vùng đùi ngoài thì tốt hơn vì cơ delta còn nhỏ. Ngoại lệ có thể tiêm vắc xin theo đường dưới da cho những bệnh nhân ưa chảy máu. Lắc kỹ lọ vắc xin trước khi tiêm."}', 'Vắc xin phòng viêm gan B tái tổ hợp Gene-HBvax được sản xuất bởi Công ty TNHH MTV Vắc xin và Sinh phẩm số 1 VABIOTECH (Việt Nam) .', 'Gene Hbvax', '{"Bảo quản ở nhiệt độ lạnh (từ +2 độ C đến +8 độ C). Không được đông băng."}', 950495, 'vac-xin-gene-hbvax', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (31, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Người quá mẫn với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm Priorix trước đó.","Người bị suy giảm miễn dịch nặng (bẩm sinh hoặc mắc phải).","Phụ nữ đang mang thai hoặc dự định mang thai trong vòng 1 tháng sau tiêm.","Người đang sốt cao hoặc mắc bệnh cấp tính nặng.","Người có tiền sử giảm tiểu cầu hoặc ban xuất huyết giảm tiểu cầu."}', 'Bỉ', NULL, 'Vắc xin Priorix có thể tiêm sớm cho trẻ từ 9 tháng tuổi, Priorix có thể tăng khả năng bảo vệ lên đến 98% nếu tiêm đủ 2 mũi. Priorix bảo vệ sớm cho trẻ, giảm tỷ lệ bệnh nặng và tử vong, giúp ngăn ngừa sự lây lan của virus.', 'Vắc xin Priorix là vắc xin thế hệ mới đầu tiên phòng ngừa hiệu quả 3 bệnh Sởi - Quai bị - Rubella được sử...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2022/07/vac-xin-priorix.jpg', '{"Vắc xin Priorix được chỉ định tiêm dưới da hoặc tiêm bắp.","Liều tiêm 0.5ml cho mỗi mũi.","Trẻ từ 9-12 tháng tuổi: Tiêm mũi 1, sau đó tiêm mũi 2 cách mũi 1 ít nhất 3 tháng.","Trẻ từ 12 tháng tuổi trở lên: Tiêm 2 mũi cách nhau ít nhất 4 tuần."}', 'Vắc xin Priorix được nghiên cứu và phát triển bởi tập đoàn GlaxoSmithKline (GSK) – Bỉ, một trong những tập đoàn dược phẩm hàng đầu thế giới.', 'Priorix', '{"Bảo quản ở nhiệt độ từ 2 đến 8 độ C.","Tránh ánh sáng trực tiếp.","Không được đông băng.","Sau khi pha hồi chỉnh, vắc xin phải được sử dụng ngay hoặc trong vòng 8 giờ nếu bảo quản ở 2-8 độ C."}', 2515143, 'vac-xin-priorix', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (5, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Quá mẫn cảm với hoạt chất hoặc với bất kỳ tá dược nào hoặc quá mẫn cảm với liều Qdenga trước đó","Những người bị suy giảm miễn dịch bẩm sinh hoặc mắc phải, bao gồm sử dụng các liệu pháp ức chế miễn dịch như hóa trị hoặc dùng corticosteroid toàn thân liều cao (ví dụ: với liều 20mg/ngày hoặc liều tương đương với prednisone 2 mg/kg/ngày trong 2 tuần trở lên) trong vòng 4 tuần trước khi tiêm chủng, tương tự như với các vắc xin sống giảm độc lực khác","Những người nhiễm HIV có triệu chứng hoặc nhiễm HIV không có triệu chứng kèm theo bằng chứng suy giảm chức năng hệ miễn dịch","Phụ nữ có thai","Phụ nữ cho con bú"}', 'Nhật Bản', NULL, 'Vắc xin Qdenga là chế phẩm sinh học đặc biệt có khả năng phòng bệnh sốt xuất huyết do virus Dengue gây ra, có khả năng bảo vệ chống lại cả 4 nhóm huyết thanh của virus dengue, bao gồm DEN-1, DEN-2, DEN-3 và DEN-4, được chỉ định tiêm cho người từ 4 tuổi trở lên với hiệu lực bảo vệ hơn 80% nguy cơ mắc bệnh do 4 tuýp virus Dengue và trên 90% nguy cơ nhập viện, mắc bệnh nặng và biến chứng nguy hiểm do bệnh sốt xuất huyết gây ra.', 'Vắc xin Qdenga được phê duyệt sử dụng tại hơn 40 quốc gia, là vắc xin phòng bệnh sốt xuất huyết đầu tiên và duy...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2024/09/vaccine-qdenga-1.jpg', '{"Sau khi hoàn nguyên hoàn toàn vắc xin đông khô với chất pha loãng (dung môi), Qdenga nên được tiêm dưới da, tốt nhất là ở cánh tay trên ở vùng cơ delta.","Qdenga không được tiêm vào mạch, không được tiêm trong da hoặc tiêm bắp.","Không nên trộn vắc xin trong cùng một ống tiêm với bất kỳ loại vắc xin hoặc sản phẩm thuốc tiêm nào khác."}', 'Vắc xin Qdenga là vắc xin sống giảm độc lực được nghiên cứu, phát triển và sản xuất bởi Hãng vắc xin và dược phẩm Takeda – Nhật Bản, xuất xứ tại Đức.', 'Qdenga', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 –  8°C.","Tránh tiếp xúc với chất bảo quản, thuốc sát trùng, chất tẩy rửa và các chất chống vi rút khác vì chúng có thể làm bất hoạt vắc xin.","Chỉ sử dụng ống tiêm vô trùng không chứa chất bảo quản, chất khử trùng, chất tẩy rửa và các chất chống virus khác để pha và tiêm Qdenga.","Qdenga phải được hoàn nguyên trước khi dùng."}', 836851, 'vac-xin-qdenga', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (28, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Chống chỉ định đối với những trường hợp mẫn cảm với các hoạt chất hay bất cứ tá dược hoặc chất tồn dư nào trong thuốc.","Quá mẫn sau mũi tiêm vắc xin bạch hầu, uốn ván, ho gà, viêm gan B, bại liệt hoặc Hib trước đó.","Infanrix hexa chống chỉ định đối với những trẻ trong tiền sử đã có bệnh về não không rõ nguyên nhân trong vòng 7 ngày sau khi tiêm vắc xin chứa thành phần ho gà."}', 'Bỉ', NULL, 'Vắc xin Infanrix Hexa là vắc xin 6 trong 1 kết hợp phòng được 6 loại bệnh trong 1 mũi tiêm, bao gồm: Ho gà, bạch hầu, uốn ván, bại liệt, viêm gan B và các bệnh viêm phổi, viêm màng não mủ do H.Influenzae týp B (Hib). Tích hợp trong duy nhất trong 1 vắc xin, 6 trong 1 Infanrix Hexa giúp giảm số mũi tiêm, đồng nghĩa với việc hạn chế đau đớn cho bé khi phải tiêm quá nhiều mũi.', 'Bạch hầu, ho gà, uốn ván, viêm gan B, bại liệt và các bệnh viêm phổi, viêm màng não do H.influenzae týp B là 6...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-Infanrix-hexa.jpg', '{"Infanrix Hexa được chỉ định tiêm bắp sâu. Không được tiêm tĩnh mạch hoặc trong da."}', 'Vắc xin Infanrix Hexa được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ.', 'Infanrix Hexa', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 – 8 độ C. Không đông đá huyền dịch DTPa-HB-IPV và vắc xin đã hoàn nguyên. Loại bỏ nếu vắc xin bị đông băng."}', 1791683, 'infanrix-vac-xin-6-trong-1', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (29, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Chống chỉ định đối với những trường hợp mẫn cảm với các hoạt chất hay bất cứ tá dược nào trong thuốc.","Trẻ bị dị ứng với một trong các thành phần của vắc xin hay với vắc xin ho gà (vô bào hoặc nguyên bào), hay trước đây trẻ đã có phản ứng dị ứng sau khi tiêm vắc xin có chứa các chất tương tự.","Trẻ có bệnh não tiến triển hoặc tổn thương ở não.","Nếu lần trước trẻ từng bị bệnh não (tổn thương ở não) trong vòng 7 ngày sau khi tiêm vắc xin ho gà (ho gà vô bào hay nguyên bào)."}', 'Pháp', NULL, 'Vắc xin Pentaxim l à vắc xin kết hợp phòng được 5 loại bệnh trong 1 mũi tiêm, bao gồm: Ho gà, bạch hầu, uốn ván, bại liệt và các bệnh viêm phổi, viêm màng não mủ do H.Influenzae týp B (Hib). Tích hợp trong duy nhất trong 1 vắc xin, 5 trong 1 Pentaxim giúp giảm số mũi tiêm, đồng nghĩa với việc hạn chế đau đớn cho bé khi phải tiêm quá nhiều.', 'Vắc xin Pentaxim là gì Vắc xin 5 trong 1 là mũi gì Tiêm vắc xin 5 trong 1 giá bao nhiêu Tiêm vắc xin...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-pentaxim-1.jpg', '{"Vắc xin Pentaxim được chỉ định tiêm bắp (ở mặt trước – bên đùi)."}', 'Vắc xin Pentaxim được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp).', 'Pentaxim', '{"Bảo quản ở nhiệt độ lạnh (từ 2 – 8 độ C). Không được đóng băng.","Vắc xin phải được hoàn nguyên trước khi tiêm, tạo nên hỗn dịch màu trắng đục. Sau khi hoàn nguyên nên sử dụng ngay."}', 2221976, 'pentaxim-vac-xin-5-trong-1', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (33, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Không dùng vắc xin cho trẻ khi có dị ứng với bất kỳ thành phần nào trong vắc xin.","Không dùng liều tiếp theo nếu trẻ có biểu hiện mẫn cảm với lần uống vắc xin Rotateq trước.","Không dùng vắc xin Rotateq cho trẻ suy giảm miễn dịch kết hợp trầm trọng, vì đã có báo cáo về trường hợp viêm dạ dày ruột khi dùng vắc xin ở trẻ suy giảm miễn dịch kết hợp trầm trọng."}', 'Mỹ', NULL, 'Rotateq là vắc xin sống giảm độc lực phòng ngừa Rotavirus, ngũ giá, dùng đường uống được chỉ định cho trẻ từ 6 tuần tuổi phòng viêm dạ dày – ruột do Rotavirus ở trẻ nhỏ gây ra bởi các tuýp vi-rút G1, G2, G3, G4 và các tuýp có chứa P1A (ví dụ như G9).', 'Tiêu chảy cấp do virus Rota là bệnh cấp tính do virus gây nên. Bệnh thường gặp ở trẻ nhỏ với biểu hiện: nôn ói,...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-RotaTeq.jpg', '{"Chỉ dùng đường uống. Không được tiêm.","Nếu trẻ bị nôn trớ hoặc nhổ ra thì không được uống liều thay thế vì chưa có nghiên cứu lâm sàng cho việc uống thay thế. Cứ dùng liều tiếp theo trong lịch uống vắc xin.","Vắc xin được đóng trong tuýp định liều có thể vặn nắp và cho uống luôn, không được pha loãng bằng nước hoặc sữa."}', 'Vắc xin Rotateq được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Meck Sharp and Dohme ( MSD ) – Mỹ.', 'Rotateq', '{"Vắc xin Rotateq được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C. Sau khi lấy ra khỏi tủ lạnh, vắc xin cần được sử dụng ngay. Khi bảo quản ở nhiệt độ 25 độ C, vắc xin Rotateq có thể sử dụng trong vòng 48 giờ. Sau 48 giờ vắc xin cần phải loại bỏ theo quy định."}', 778002, 'vac-xin-rotateq', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (6, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Chống chỉ định tiêm vắc xin Shingrix cho các đối tượng có tiền sử phản ứng dị ứng nghiêm trọng như sốc phản vệ với bất kỳ thành phần nào của vắc xin Shingrix."}', 'Bỉ', NULL, 'Vắc xin Shingrix là sinh phẩm y tế được chỉ định để phòng bệnh zona thần kinh (Herpes Zoster) hay còn gọi là giời leo và các biến chứng liên quan đến Herpes Zoster, như đau dây thần kinh sau khi mắc zona (PHN). Vắc xin Shingrix được chỉ định sử dụng để tiêm ngừa cho người lớn từ 50 tuổi trở lên và người từ 18 tuổi trở lên có nguy cơ mắc zona thần kinh.', 'Vắc xin Shingrix được dùng để phòng bệnh zona thần kinh và các biến chứng như đau dây thần kinh sau zona. Vắc xin này...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2023/11/vacxin-shingrix.jpg', '{"Vắc xin Shingrix được chỉ định tiêm bắp, tốt nhất tại vùng cơ delta của cánh tay."}', 'Vắc xin Shingrix là vắc xin tái tổ hợp được bào chế ở dạng hỗn dịch tiêm, được cung cấp dưới dạng lọ đơn liều chứa thành phần kháng nguyên glycoprotein E (gE) của VZV đông khô để được hoàn nguyên bằng lọ đi kèm thành phần hỗn dịch bổ trợ AS01.', 'Shingrix', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 –  8°C. Sau khi pha (hoàn nguyên), sử dụng Shingrix ngay lập tức. Nếu không thể sử dụng ngay, sản phần đã hoàn nguyên cần bảo quản trong tủ bảo quản chuyên dụng từ 2 – 8°C và sử dụng trong vòng 6 giờ tại phòng tiêm. Loại bỏ vắc xin đã hoàn nguyên nếu không sử dụng trong vòng 6 giờ."}', 1818454, 'vac-xin-shingrix', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (47, '2025-11-17 02:43:15.408049', false, '2025-11-17 02:43:15.408049', '{"Những trường hợp có tiền sử dị ứng với huyết thanh kháng độc tố uốn ván nguồn gốc từ ngựa. Những trường hợp này nếu bắt buộc dùng nên dùng loại huyết thanh uốn ván nguồn gốc từ người.","Phụ nữ đang mang thai."}', 'Việt Nam', NULL, 'Huyết thanh uốn ván SAT được dùng để phòng ngừa uốn ván ở người vừa mới bị vết thương có thể nhiễm bào tử uốn ván, bao gồm những người không tiêm ngừa uốn ván trong 10 năm gần đây, hoặc không nhớ rõ lịch tiêm uốn ván.', 'Uốn ván là bệnh nhiễm trùng cấp tính do vi khuẩn yếm khí Clostridium tetani gây ra. Theo Tổ chức Y tế Thế giới (WHO),...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2021/02/huyet-thanh-uon-van-SAT.jpg', '{"Huyết thanh uốn ván SAT được chỉ định tiêm bắp."}', 'Huyết thanh uốn ván SAT được nghiên cứu và phát triển bởi Viện Vắc xin và Sinh phẩm Y tế ( IVAC – Việt Nam).', 'Uốn Ván SAT', '{"Bảo quản ở nhiệt độ lạnh (từ 2 – 8 độ C). Không được đóng băng."}', 886289, 'huyet-thanh-uon-van-sat', 20);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (103, '2025-12-19 00:00:00', false, '2025-12-22 21:41:54.840087', NULL, 'Trung Quốc', NULL, 'Vắc xin Covilo là vắc xin COVID-19 bất hoạt, được sản xuất bằng công nghệ truyền thống sử dụng virus SARS-CoV-2 đã được làm bất hoạt. Vắc xin được chỉ định cho người từ 18 tuổi trở lên và đã được WHO phê duyệt sử dụng khẩn cấp. Hiệu quả bảo vệ đạt khoảng 79% trong việc ngăn ngừa nhiễm COVID-19 có triệu chứng.', 'Vắc xin Covilo (Sinopharm) là vắc xin COVID-19 bất hoạt, được WHO phê duyệt sử dụng khẩn cấp với hiệu quả bảo vệ 79%.', 2, 21, 'https://vnvc.vn/wp-content/uploads/2021/07/sinopharm-vacxin-cua-nuoc-nao.jpg', NULL, 'Vắc xin Covilo được nghiên cứu và sản xuất bởi Beijing Institute of Biological Products thuộc Tập đoàn Sinopharm (Trung Quốc).', 'Covilo (Sinopharm)', NULL, 1100000, 'covilo-sinopharm', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (101, '2025-12-19 00:00:00', false, '2025-12-22 21:46:38.397546', NULL, 'Mỹ', NULL, 'Vắc xin Spikevax là vắc xin mRNA phòng COVID-19 được chỉ định cho người từ 6 tháng tuổi trở lên. Vắc xin sử dụng công nghệ mRNA để hướng dẫn tế bào sản xuất protein spike của virus SARS-CoV-2, từ đó kích thích cơ thể tạo đáp ứng miễn dịch. Hiệu quả bảo vệ đạt 94.1% trong thử nghiệm lâm sàng với hơn 30,000 người tham gia.', 'Vắc xin Spikevax (Moderna) là vắc xin mRNA phòng COVID-19, với hiệu quả bảo vệ 94.1% trong các thử nghiệm lâm sàng quy mô lớn.', 2, 28, 'https://products.modernatx.com/assets/images/products_spikevaxpro_ca_Spikevax_Vial.webp', NULL, 'Vắc xin Spikevax được nghiên cứu và sản xuất bởi Moderna Inc. (Mỹ).', 'Spikevax (Moderna)', NULL, 1450000, 'spikevax-moderna', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (102, '2025-12-19 00:00:00', false, '2025-12-22 21:47:41.701094', NULL, 'Anh', NULL, 'Vắc xin Vaxzevria là vắc xin COVID-19 sử dụng công nghệ vector adenovirus không sao chép (ChAdOx1), được chỉ định cho người từ 18 tuổi trở lên. Vắc xin đã được WHO và EMA phê duyệt sử dụng khẩn cấp. Hiệu quả bảo vệ đạt khoảng 76% sau khi hoàn thành 2 liều tiêm, và đặc biệt hiệu quả trong việc ngăn ngừa nhập viện và tử vong do COVID-19.', 'Vắc xin Vaxzevria (AstraZeneca) là vắc xin vector virus phòng COVID-19, với hiệu quả bảo vệ khoảng 76% sau 2 liều tiêm.', 2, 84, 'https://upload.wikimedia.org/wikipedia/commons/1/19/Oxford_AstraZeneca_COVID-19_vaccine_%282021%29_B_%28cropped%29.jpeg', NULL, 'Vắc xin Vaxzevria được nghiên cứu bởi Đại học Oxford và sản xuất bởi AstraZeneca (Anh).', 'Vaxzevria (AstraZeneca)', NULL, 1200000, 'vaxzevria-astrazeneca', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (110, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Trẻ có tiền sử phản ứng dị ứng nặng với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm trước.","Trẻ bị bệnh não tiến triển.","Trẻ có tiền sử co giật hoặc sốt cao sau tiêm vắc xin ho gà trước đó.","Hoãn tiêm khi trẻ đang sốt hoặc mắc bệnh cấp tính."}', 'Pháp', NULL, 'Vắc xin Pentaxim là vắc xin phối hợp 5 trong 1 phòng được 5 bệnh nguy hiểm cho trẻ em gồm: Bạch hầu, Ho gà (vô bào), Uốn ván, Bại liệt và các bệnh xâm lấn do Haemophilus influenzae type b (Hib) gây ra như viêm màng não mủ, viêm phổi, viêm thanh quản. Vắc xin được chỉ định cho trẻ từ 2 tháng tuổi và là một trong những vắc xin được khuyến cáo trong chương trình tiêm chủng mở rộng.', 'Vắc xin Pentaxim 5 trong 1 phòng 5 bệnh nguy hiểm: Bạch hầu, Ho gà, Uốn ván, Bại liệt và các bệnh do Hib gây ra cho trẻ từ 2 tháng tuổi.', 4, 60, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-pentaxim.jpg', '{"Tiêm bắp sâu vào mặt trước ngoài đùi (trẻ dưới 2 tuổi) hoặc cơ delta cánh tay (trẻ từ 2 tuổi trở lên).","Không được tiêm tĩnh mạch hoặc trong da.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Pentaxim được nghiên cứu và sản xuất bởi Sanofi Pasteur (Pháp).', 'Pentaxim', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Sau khi pha với thành phần Hib, sử dụng ngay."}', 795000, 'pentaxim-5-trong-1-tre-em', 50);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (111, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Trẻ có tiền sử phản ứng phản vệ với bất kỳ thành phần nào của vắc xin.","Trẻ bị bệnh não trong vòng 7 ngày sau tiêm vắc xin ho gà trước đó.","Trẻ có rối loạn thần kinh không kiểm soát hoặc động kinh không kiểm soát.","Hoãn tiêm khi trẻ đang sốt hoặc mắc bệnh cấp tính."}', 'Bỉ', NULL, 'Vắc xin Infanrix Hexa là vắc xin phối hợp 6 trong 1 cao cấp, phòng được 6 bệnh nguy hiểm cho trẻ nhỏ gồm: Bạch hầu, Ho gà (vô bào), Uốn ván, Bại liệt, Viêm gan B và các bệnh xâm lấn do Haemophilus influenzae type b (Hib). Vắc xin sử dụng thành phần ho gà vô bào nên ít gây phản ứng phụ hơn vắc xin ho gà toàn tế bào, đặc biệt an toàn cho trẻ sơ sinh từ 6 tuần tuổi.', 'Vắc xin Infanrix Hexa 6 trong 1 phòng 6 bệnh: Bạch hầu, Ho gà, Uốn ván, Bại liệt, Viêm gan B và các bệnh do Hib cho trẻ từ 6 tuần tuổi.', 4, 60, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-infanrix-hexa.jpg', '{"Tiêm bắp sâu vào mặt trước ngoài đùi (trẻ nhỏ) hoặc cơ delta cánh tay (trẻ lớn hơn).","Không được tiêm tĩnh mạch, dưới da hoặc trong da.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Infanrix Hexa được nghiên cứu và sản xuất bởi GlaxoSmithKline (GSK) - Bỉ.', 'Infanrix Hexa', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh - nếu đã đông lạnh phải hủy bỏ.","Tránh ánh sáng. Sau khi pha, sử dụng ngay."}', 1050000, 'infanrix-hexa-6-trong-1', 50);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (112, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Trẻ có tiền sử phản ứng dị ứng nặng với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm trước.","Trẻ có tiền sử dị ứng với nấm men.","Hoãn tiêm khi trẻ đang sốt cao hoặc mắc bệnh cấp tính."}', 'Bỉ', NULL, 'Vắc xin Engerix-B là vắc xin tái tổ hợp phòng bệnh Viêm gan B cho trẻ em từ sơ sinh đến 15 tuổi. Viêm gan B là bệnh truyền nhiễm do virus HBV gây ra, có thể lây truyền từ mẹ sang con, qua đường máu và quan hệ tình dục. Bệnh có thể dẫn đến xơ gan và ung thư gan. Tiêm vắc xin sớm từ khi sinh giúp bảo vệ trẻ suốt đời.', 'Vắc xin Engerix-B dành cho trẻ em phòng bệnh Viêm gan B - một bệnh truyền nhiễm nguy hiểm có thể dẫn đến xơ gan và ung thư gan.', 3, 30, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-engerix-b.jpg', '{"Tiêm bắp vào mặt trước ngoài đùi (trẻ sơ sinh và trẻ nhỏ) hoặc cơ delta cánh tay (trẻ lớn hơn).","Không được tiêm tĩnh mạch.","Liều 0.5ml (10mcg) cho trẻ từ 0-15 tuổi."}', 'Vắc xin Engerix-B được nghiên cứu và sản xuất bởi GlaxoSmithKline (GSK) - Bỉ.', 'Engerix-B (Trẻ em)', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Tránh ánh sáng."}', 350000, 'engerix-b-viem-gan-b-tre-em', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (113, '2025-12-19 00:00:00', false, '2025-12-22 21:45:33.718876', NULL, 'Bỉ', NULL, 'Vắc xin Priorix là vắc xin sống giảm độc lực phối hợp phòng 3 bệnh: Sởi, Quai bị và Rubella (còn gọi là vắc xin MMR). Vắc xin được chỉ định cho trẻ từ 9 tháng tuổi và người lớn chưa có miễn dịch. Sởi có thể gây biến chứng viêm phổi, viêm não; Quai bị có thể gây viêm tinh hoàn, vô sinh; Rubella đặc biệt nguy hiểm cho phụ nữ mang thai gây dị tật bẩm sinh.', 'Vắc xin Priorix phòng 3 bệnh nguy hiểm: Sởi, Quai bị và Rubella cho trẻ từ 9 tháng tuổi và người lớn.', 2, 90, 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Priorix_%28MMR_vaccine%29.jpg/500px-Priorix_%28MMR_vaccine%29.jpg', NULL, 'Vắc xin Priorix được nghiên cứu và sản xuất bởi GlaxoSmithKline (GSK) - Bỉ.', 'Priorix', NULL, 450000, 'priorix', 80);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (120, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Người có tiền sử phản ứng phản vệ với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm vắc xin DTP trước đó.","Người có tiền sử bệnh não trong vòng 7 ngày sau tiêm vắc xin ho gà.","Hoãn tiêm khi đang sốt cao hoặc mắc bệnh cấp tính."}', 'Bỉ', NULL, 'Vắc xin Boostrix (Tdap) là vắc xin phối hợp phòng 3 bệnh: Bạch hầu, Uốn ván và Ho gà (thành phần ho gà vô bào liều thấp). Vắc xin được WHO và CDC khuyến cáo tiêm cho phụ nữ mang thai trong tam cá nguyệt thứ 3 (tuần 27-36) để truyền kháng thể bảo vệ cho trẻ sơ sinh trong những tháng đầu đời, khi trẻ chưa đủ tuổi tiêm chủng. Đây là biện pháp an toàn và hiệu quả bảo vệ cả mẹ và bé.', 'Vắc xin Boostrix được khuyến cáo cho phụ nữ mang thai để phòng Ho gà, Bạch hầu, Uốn ván cho cả mẹ và bé sơ sinh.', 1, 0, 'https://vnvc.vn/wp-content/uploads/2020/02/vac-xin-boostrix.jpg', '{"Tiêm bắp vào cơ delta cánh tay.","Không được tiêm tĩnh mạch, dưới da hoặc trong da.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Boostrix được nghiên cứu và sản xuất bởi GlaxoSmithKline (GSK) - Bỉ.', 'Boostrix (Bà bầu)', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh - nếu đã đông lạnh phải hủy bỏ.","Tránh ánh sáng."}', 550000, 'tdap-boostrix-phu-nu-mang-thai', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (121, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Người có tiền sử phản ứng phản vệ với protein trứng hoặc bất kỳ thành phần nào của vắc xin.","Người có tiền sử hội chứng Guillain-Barré trong vòng 6 tuần sau tiêm vắc xin cúm trước đó.","Hoãn tiêm khi đang sốt cao hoặc mắc bệnh cấp tính."}', 'Pháp', NULL, 'Vắc xin Vaxigrip Tetra là vắc xin cúm tứ giá (4 chủng) phòng 4 chủng virus cúm: 2 chủng cúm A (H1N1, H3N2) và 2 chủng cúm B (Yamagata, Victoria). Phụ nữ mang thai có nguy cơ cao bị biến chứng nặng do cúm, bao gồm viêm phổi, sinh non và thai chết lưu. WHO và CDC khuyến cáo phụ nữ mang thai nên tiêm vắc xin cúm ở bất kỳ giai đoạn nào của thai kỳ để bảo vệ cả mẹ và bé.', 'Vắc xin cúm Vaxigrip Tetra được khuyến cáo cho phụ nữ mang thai phòng cúm mùa, bảo vệ cả mẹ và thai nhi.', 1, 365, 'https://vnvc.vn/wp-content/uploads/2021/07/vaccine-vaxigrip-tetra.jpg', '{"Tiêm bắp vào cơ delta cánh tay.","Có thể tiêm dưới da cho người có rối loạn đông máu.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Vaxigrip Tetra được nghiên cứu và sản xuất bởi Sanofi Pasteur (Pháp).', 'Vaxigrip Tetra (Bà bầu)', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Tránh ánh sáng."}', 550000, 'vaxigrip-tetra-phu-nu-mang-thai', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (116, '2025-12-19 00:00:00', false, '2025-12-22 21:46:00.283355', NULL, 'Mỹ', NULL, 'Vắc xin RotaTeq là vắc xin sống giảm độc lực dạng uống, phòng bệnh tiêu chảy cấp do 5 type Rotavirus (G1, G2, G3, G4 và P1A[8]) gây ra. Rotavirus là nguyên nhân hàng đầu gây tiêu chảy cấp nặng ở trẻ nhỏ, có thể dẫn đến mất nước nghiêm trọng và tử vong. Vắc xin được chỉ định cho trẻ từ 6-32 tuần tuổi.', 'Vắc xin RotaTeq phòng bệnh Tiêu chảy cấp do Rotavirus - nguyên nhân hàng đầu gây tiêu chảy nặng và tử vong ở trẻ nhỏ.', 3, 60, 'https://www.mcguff.com/content/images/thumbs/0015259_rotateq-rotavirus-vaccine-single-dose-tube-2-ml-10tray.jpeg', NULL, 'Vắc xin RotaTeq được nghiên cứu và sản xuất bởi Merck Sharp & Dohme (MSD) - Mỹ.', 'RotaTeq', NULL, 750000, 'rotateq', 60);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (115, '2025-12-19 00:00:00', false, '2025-12-22 21:47:10.967359', NULL, 'Mỹ', NULL, 'Vắc xin Varivax là vắc xin sống giảm độc lực phòng bệnh Thủy đậu do virus Varicella Zoster gây ra. Thủy đậu là bệnh truyền nhiễm cấp tính rất dễ lây, có thể gây nhiều biến chứng nguy hiểm như viêm phổi, viêm não, nhiễm trùng da. Vắc xin được chỉ định cho trẻ từ 12 tháng tuổi và người lớn chưa có miễn dịch.', 'Vắc xin Varivax phòng bệnh Thủy đậu - bệnh truyền nhiễm cấp tính có thể gây nhiều biến chứng nguy hiểm.', 2, 90, 'https://upload.wikimedia.org/wikipedia/commons/5/5b/Varivax_vial.jpg', NULL, 'Vắc xin Varivax được nghiên cứu và sản xuất bởi Merck Sharp & Dohme (MSD) - Mỹ.', 'Varivax', NULL, 850000, 'varivax', 50);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (122, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Người có tiền sử phản ứng dị ứng nặng với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm trước.","Người có tiền sử dị ứng với nấm men.","Hoãn tiêm khi đang sốt cao hoặc mắc bệnh cấp tính."}', 'Bỉ', NULL, 'Vắc xin Engerix-B là vắc xin tái tổ hợp phòng bệnh Viêm gan B, an toàn cho phụ nữ mang thai. Virus viêm gan B có thể lây truyền từ mẹ sang con trong quá trình mang thai và sinh nở, gây viêm gan mãn tính, xơ gan và ung thư gan ở trẻ. Phụ nữ mang thai có nguy cơ cao (nhân viên y tế, bạn tình có HBV+) nên được tiêm phòng để bảo vệ cả mẹ và bé.', 'Vắc xin Viêm gan B Engerix-B được khuyến cáo cho phụ nữ mang thai có nguy cơ cao nhiễm virus viêm gan B.', 3, 30, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-engerix-b.jpg', '{"Tiêm bắp vào cơ delta cánh tay.","Không được tiêm tĩnh mạch hoặc trong da.","Liều 1.0ml (20mcg) cho người lớn."}', 'Vắc xin Engerix-B được nghiên cứu và sản xuất bởi GlaxoSmithKline (GSK) - Bỉ.', 'Engerix-B (Bà bầu)', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Tránh ánh sáng."}', 450000, 'engerix-b-phu-nu-mang-thai', 80);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (126, '2025-12-19 00:00:00', false, '2025-12-19 00:00:00', '{"Trẻ có tiền sử phản ứng dị ứng nặng với bất kỳ thành phần nào của vắc xin hoặc sau lần tiêm trước.","Hoãn tiêm khi trẻ đang sốt cao hoặc mắc bệnh cấp tính."}', 'Cuba', NULL, 'Vắc xin Hib (Haemophilus influenzae type b) phòng các bệnh xâm lấn nguy hiểm do vi khuẩn Hib gây ra, bao gồm: viêm màng não mủ, viêm phổi, viêm nắp thanh quản, nhiễm khuẩn huyết. Đây là những bệnh đặc biệt nguy hiểm ở trẻ dưới 5 tuổi, có thể gây tử vong hoặc di chứng thần kinh vĩnh viễn. Vắc xin được khuyến cáo cho trẻ từ 2 tháng tuổi.', 'Vắc xin Hib phòng các bệnh nguy hiểm do Haemophilus influenzae type b gây ra như viêm màng não mủ, viêm phổi.', 4, 60, 'https://vnvc.vn/wp-content/uploads/2021/02/vac-xin-quimi-hib.jpg', '{"Tiêm bắp vào mặt trước ngoài đùi (trẻ dưới 2 tuổi) hoặc cơ delta cánh tay (trẻ trên 2 tuổi).","Không được tiêm tĩnh mạch.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Quimihib được nghiên cứu và sản xuất bởi CIGB - Cuba.', 'Hib (Quimihib)', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Sử dụng ngay sau khi mở lọ."}', 350000, 'hib-viem-mang-nao-mu', 80);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (124, '2025-12-19 00:00:00', false, '2025-12-22 21:43:22.73907', NULL, 'Việt Nam', NULL, 'Vắc xin DPT là vắc xin phối hợp phòng 3 bệnh nguy hiểm: Bạch hầu (Diphtheria), Ho gà (Pertussis) và Uốn ván (Tetanus). Đây là vắc xin thuộc chương trình tiêm chủng mở rộng quốc gia, được tiêm miễn phí cho trẻ em Việt Nam. Vắc xin sử dụng thành phần ho gà toàn tế bào, đã được sử dụng an toàn trong nhiều thập kỷ.', 'Vắc xin DPT phòng 3 bệnh: Bạch hầu, Ho gà, Uốn ván - thuộc chương trình tiêm chủng mở rộng cho trẻ em Việt Nam.', 4, 60, 'https://media.istockphoto.com/id/546805660/vi/anh/v%E1%BA%AFc-xin-dtp.jpg?s=612x612&w=0&k=20&c=8InybgyXCdfdIPojvACaplOP5SRop-JGnwItMIE3Uns=', NULL, 'Vắc xin DPT được sản xuất tại Việt Nam bởi các đơn vị thuộc Bộ Y tế.', 'DPT (Việt Nam)', NULL, 0, 'dpt-viet-nam', 200);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (125, '2025-12-19 00:00:00', false, '2025-12-22 21:45:18.618362', NULL, 'Việt Nam', NULL, 'Vắc xin OPV (Oral Poliovirus Vaccine) là vắc xin bại liệt sống giảm độc lực dạng uống, phòng bệnh bại liệt do 3 type poliovirus gây ra. Đây là vắc xin thuộc chương trình tiêm chủng mở rộng quốc gia, được sử dụng miễn phí cho trẻ em Việt Nam. Vắc xin dễ sử dụng, không cần tiêm, giúp tạo miễn dịch cộng đồng hiệu quả.', 'Vắc xin OPV phòng bệnh Bại liệt dạng uống - thuộc chương trình tiêm chủng mở rộng quốc gia.', 4, 60, 'https://lh3.googleusercontent.com/proxy/MTnXysXP6-yHSKzpECRzuc1tNpdIhsF5Yx4nT3pwrOj9GsXynUO33_EcUV5jLefHsghTuJdeGcFo3XMJX0Eq4L9jo5bxDhwvtlc1QP3hMJ3KVTeOF1o_KGKS98nw', NULL, 'Vắc xin OPV được sản xuất tại Việt Nam.', 'OPV (Bại liệt uống)', NULL, 0, 'opv-bai-liet-uong', 200);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (104, '2025-12-19 00:00:00', false, '2025-12-23 03:15:27.545449', NULL, 'Cuba', NULL, 'Vắc xin Abdala là vắc xin COVID-19 sử dụng công nghệ tiểu đơn vị protein tái tổ hợp, chứa miền gắn thụ thể (RBD) của protein spike virus SARS-CoV-2. Vắc xin được chỉ định cho người từ 19 tuổi trở lên với lịch tiêm 3 liều. Hiệu quả bảo vệ đạt 92.28% trong các thử nghiệm lâm sàng tại Cuba.', 'Vắc xin Abdala là vắc xin COVID-19 tiểu đơn vị protein đầu tiên của Mỹ Latinh, với hiệu quả bảo vệ 92.28%.', 3, 14, 'https://dongnaicdc.vn/UserFiles/Images/2021/Thang%209/tiep/vccuba_jxqd.jpg', NULL, 'Vắc xin Abdala được nghiên cứu và sản xuất bởi Trung tâm Kỹ thuật Di truyền và Công nghệ Sinh học (CIGB) - Cuba.', 'Abdala', NULL, 950000, 'abdala', 99);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (123, '2025-12-19 00:00:00', true, '2025-12-22 21:39:59.526802', '{"Người có tiền sử phản ứng phản vệ với bất kỳ thành phần nào của vắc xin.","Người có tiền sử bệnh não trong vòng 7 ngày sau tiêm vắc xin ho gà.","Người có tiền sử hội chứng Guillain-Barré trong vòng 6 tuần sau tiêm vắc xin chứa độc tố uốn ván.","Hoãn tiêm khi đang sốt cao hoặc mắc bệnh cấp tính."}', 'Canada', NULL, 'Vắc xin Adacel là vắc xin Tdap (Bạch hầu, Uốn ván, Ho gà vô bào) dành cho thanh thiếu niên từ 10 tuổi và người lớn, bao gồm phụ nữ mang thai. Vắc xin được khuyến cáo tiêm nhắc mỗi 10 năm để duy trì miễn dịch, và đặc biệt quan trọng cho phụ nữ mang thai để truyền kháng thể bảo vệ cho trẻ sơ sinh khỏi bệnh ho gà.', 'Vắc xin Adacel (Tdap) phòng Ho gà, Bạch hầu, Uốn ván cho thanh thiếu niên và người lớn, đặc biệt quan trọng cho phụ nữ mang thai.', 1, 3650, 'https://vnvc.vn/wp-content/uploads/2020/03/vac-xin-adacel.jpg', '{"Tiêm bắp vào cơ delta cánh tay.","Không được tiêm tĩnh mạch, dưới da hoặc trong da.","Liều 0.5ml cho mỗi lần tiêm."}', 'Vắc xin Adacel được nghiên cứu và sản xuất bởi Sanofi Pasteur (Canada).', 'Adacel', '{"Vắc xin được bảo quản ở nhiệt độ 2-8°C.","Không được đông lạnh.","Tránh ánh sáng."}', 600000, 'adacel-tdap-nguoi-lon', 80);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (100, '2025-12-19 00:00:00', false, '2025-12-22 21:40:42.800965', NULL, 'Mỹ', NULL, 'Vắc xin Comirnaty là vắc xin mRNA phòng COVID-19, được chỉ định cho người từ 6 tháng tuổi trở lên. Vắc xin hoạt động bằng cách hướng dẫn tế bào tạo ra protein spike của virus SARS-CoV-2, kích thích hệ miễn dịch tạo kháng thể bảo vệ. Đây là vắc xin COVID-19 đầu tiên được FDA Hoa Kỳ cấp phép đầy đủ với hiệu quả bảo vệ lên đến 95% trong các thử nghiệm lâm sàng.', 'Vắc xin Comirnaty (Pfizer-BioNTech) là vắc xin mRNA đầu tiên được FDA cấp phép đầy đủ để phòng COVID-19, với hiệu quả bảo vệ lên đến 95%.', 2, 28, 'https://static01.nyt.com/newsgraphics/2020/12/05/how-coronavirus-vaccines-work/assets/images/201208-pfizer-vial-600.jpg', NULL, 'Vắc xin Comirnaty được nghiên cứu và phát triển bởi Pfizer (Mỹ) hợp tác với BioNTech (Đức).', 'Comirnaty (Pfizer-BioNTech)', NULL, 1500000, 'comirnaty-pfizer-biontech', 100);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (114, '2025-12-19 00:00:00', false, '2025-12-22 21:44:47.747291', NULL, 'Pháp', NULL, 'Vắc xin IPV (Inactivated Poliovirus Vaccine) là vắc xin bại liệt bất hoạt dạng tiêm, phòng bệnh bại liệt do 3 type poliovirus (type 1, 2, 3) gây ra. Bại liệt là bệnh truyền nhiễm cấp tính do virus polio gây ra, có thể dẫn đến liệt vĩnh viễn hoặc tử vong. Vắc xin IPV an toàn hơn vắc xin uống (OPV) vì không có nguy cơ gây bại liệt do vắc xin.', 'Vắc xin IPV phòng bệnh Bại liệt - căn bệnh có thể gây liệt vĩnh viễn và tử vong, đặc biệt nguy hiểm ở trẻ nhỏ.', 4, 60, 'https://i1-suckhoe.vnecdn.net/2023/10/23/lich-su-vaccine-bai-liet-4-1409-1698038742.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=OZn0rSJCJaHyTVaQGYxEdA', NULL, 'Vắc xin IPV (Imovax Polio) được nghiên cứu và sản xuất bởi Sanofi Pasteur (Pháp).', 'IPV (Bại liệt tiêm)', NULL, 450000, 'ipv-bai-liet-tiem', 60);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (43, '2025-11-17 02:43:15.408049', false, '2025-12-22 22:35:26.849025', '{"Người nhạy cảm với bất kỳ thành phần nào trong vắc xin hoặc có biểu hiện quá mẫn với vắc xin phòng viêm gan B và viêm gan A đơn lẻ."}', 'Bỉ', NULL, 'Vắc xin Twinrix được chỉ định để phòng 2 bệnh viêm gan A và viêm gan B ở trẻ em từ 1 tuổi và người lớn chưa có miễn dịch.', 'Việt Nam đang thuộc nhóm nước mắc ung thư gan cao nhất thế giới. Trung bình cứ 100.000 người Việt thì có 23,2 người bị...', 2, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-twinrix.jpg', '{"Tiêm bắp."}', '{"Vắc xin Twinrix được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Glaxosmithkline (GSK) – Bỉ."}', 'Twinrix', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 đến 8 độ C và không được đông băng."}', 1442847, 'twinrix', 19);
INSERT INTO public.vaccines (id, created_at, is_deleted, updated_at, contraindications, country, days_for_next_dose, description, description_short, doses_required, duration, image, injection, manufacturer, name, preserve, price, slug, stock) VALUES (44, '2025-11-17 02:43:15.408049', false, '2025-12-23 03:34:18.111291', '{"Mẫn cảm với các thành phần trong vắc xin.","Không tiêm bắp cho người bị rối loạn đông máu hoặc giảm tiểu cầu.","Trẻ em dưới 2 tuổi vì đáp ứng miễn dịch thấp."}', 'Pháp', NULL, 'Vắc xin Typhim VI phòng ngừa bệnh Thương hàn (bệnh về đường tiêu hóa) gây ra bởi vi khuẩn thương hàn (Salmonella typhi) cho trẻ từ trên 2 tuổi và người lớn.', 'Thương hàn là bệnh truyền nhiễm cấp tính do vi khuẩn Salmonella typhi gây ra. Bệnh dễ dàng lây nhiễm qua đường tiêu hóa và...', 3, 20, 'https://vnvc.vn/wp-content/uploads/2017/04/vac-xin-typhim-vi.jpg', '{"Tiêm bắp hoặc tiêm dưới da."}', 'Vắc xin Typhim VI được nghiên cứu và phát triển bởi tập đoàn hàng đầu thế giới về dược phẩm và chế phẩm sinh học Sanofi Pasteur (Pháp).', 'Typhim VI', '{"Vắc xin được bảo quản ở nhiệt độ từ 2 độ C đến 8 độ C."}', 857998, 'typhim-vi-vac-xin-phong-thuong-han', 19);


-- ========================
-- Bảng: users
-- ========================
INSERT INTO
    users (
        id,
        address,
        avatar,
        birthday,
        blockchain_identity_hash,
        did,
        email,
        full_name,
        gender,
        ipfs_data_hash,
        is_active,
        is_deleted,
        password,
        phone,
        refresh_token,
        role_id
    )
VALUES (
        1,
        NULL,
        'https_example.com/avatars/doc_a.png',
        NULL,
        NULL,
        NULL,
        'doctor.a@vax.com',
        'Bác sĩ Nguyễn Văn A',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        'eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE4NDg1MzQ1OTcsInN1YiI6ImRvY3Rvci5hQHZheC5jb20iLCJpYXQiOjE3NjI1MzQ1OTd9.DDg2rhfruCXs5GLAloeRvyax6l6fGmLVBc0l24IPLdDLlaHsJ4BH508xiqY4ryr4rxpgYJVBMMFxD8sCfIc7cw',
        3
    ),
    (
        2,
        NULL,
        'https_example.com/avatars/doc_b.png',
        NULL,
        NULL,
        NULL,
        'doctor.b@vax.com',
        'Bác sĩ Trần Văn B',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        3,
        NULL,
        'https_example.com/avatars/doc_c.png',
        NULL,
        NULL,
        NULL,
        'doctor.c@vax.com',
        'Bác sĩ Lê Thị C',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        4,
        NULL,
        'https_example.com/avatars/cash_d.png',
        NULL,
        NULL,
        NULL,
        'cashier.d@vax.com',
        'Thu ngân Phạm Văn D',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        4
    ),
    (
        5,
        NULL,
        'https_example.com/avatars/doc_e.png',
        NULL,
        NULL,
        NULL,
        'doctor.e@vax.com',
        'Bác sĩ Hoàng Văn E',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJkb2N0b3IuZUB2YXguY29tIiwiZXhwIjoxODQ5ODkwMzc3LCJpYXQiOjE3NjM4OTAzNzd9.YBOsLMSmg4YLLoxU6waIbfsasKFnhzC9WZ4QYCnV6DUi1DSNFrIsaa15wjTAcJQ5rGsSWF8XJQxqx0LoF1YOeA',
        3
    ),
    (
        6,
        NULL,
        'https_example.com/avatars/doc_f.png',
        NULL,
        NULL,
        NULL,
        'doctor.f@vax.com',
        'Bác sĩ Võ Thị F',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        7,
        NULL,
        'https_example.com/avatars/doc_g.png',
        NULL,
        NULL,
        NULL,
        'doctor.g@vax.com',
        'Bác sĩ Đặng Văn G',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        8,
        NULL,
        'https_example.com/avatars/doc_h.png',
        NULL,
        NULL,
        NULL,
        'doctor.h@vax.com',
        'Bác sĩ Bùi Thị H',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        9,
        NULL,
        'https_example.com/avatars/cash_i.png',
        NULL,
        NULL,
        NULL,
        'cashier.i@vax.com',
        'Thu ngân Ngô Văn I',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        4
    ),
    (
        10,
        NULL,
        'https_example.com/avatars/doc_j.png',
        NULL,
        NULL,
        NULL,
        'doctor.j@vax.com',
        'Bác sĩ Trịnh Văn J',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        11,
        NULL,
        'https_example.com/avatars/doc_k.png',
        NULL,
        NULL,
        NULL,
        'doctor.k@vax.com',
        'Bác sĩ Mai Thị K',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        12,
        NULL,
        'https_example.com/avatars/doc_l.png',
        NULL,
        NULL,
        NULL,
        'doctor.l@vax.com',
        'Bác sĩ Phan Văn L',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        13,
        NULL,
        'https_example.com/avatars/doc_m.png',
        NULL,
        NULL,
        NULL,
        'doctor.m@vax.com',
        'Bác sĩ Dương Thị M',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        14,
        NULL,
        'https_example.com/avatars/doc_n.png',
        NULL,
        NULL,
        NULL,
        'doctor.n@vax.com',
        'Bác sĩ Hà Văn N',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        15,
        NULL,
        'http://localhost:8080/storage/user/1762459328103-chungnhan.png',
        NULL,
        NULL,
        NULL,
        'cashier.o@vax.com',
        'Thu ngân Lương Thị O',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjYXNoaWVyLm9AdmF4LmNvbSIsImV4cCI6MTg0OTg5Nzg2NCwiaWF0IjoxNzYzODk3ODY0fQ.G2OyWIkI1dAojcg6NeOSY6pcYPiP2HczI_Fe5Ac1NtNbk1_k1JWHydz7UmPxhNzHRZG2PNr26cKzCmNE0aZDAg',
        4
    ),
    (
        16,
        NULL,
        'https_example.com/avatars/doc_p.png',
        NULL,
        NULL,
        NULL,
        'doctor.p@vax.com',
        'Bác sĩ Vũ Văn P',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        17,
        NULL,
        'https_example.com/avatars/doc_q.png',
        NULL,
        NULL,
        NULL,
        'doctor.q@vax.com',
        'Bác sĩ Đỗ Thị Q',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        18,
        NULL,
        'https_example.com/avatars/doc_r.png',
        NULL,
        NULL,
        NULL,
        'doctor.r@vax.com',
        'Bác sĩ Hồ Văn R',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        19,
        NULL,
        'https_example.com/avatars/cash_s.png',
        NULL,
        NULL,
        NULL,
        'cashier.s@vax.com',
        'Thu ngân Đinh Thị S',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        'eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE4NDgwMjQ4MjYsInN1YiI6ImNhc2hpZXIuc0B2YXguY29tIiwiaWF0IjoxNzYyMDI0ODI2fQ.XeCMUGXrl7t1zphdfCwo3jNEH76Wr_w55KBw3BCJQ8sqVh_WQ-bVRwsTpaLjNOe1wrDaBdYaE6KPr5iw6OlQDQ',
        4
    ),
    (
        20,
        NULL,
        'https_example.com/avatars/doc_t.png',
        NULL,
        NULL,
        NULL,
        'doctor.t@vax.com',
        'Bác sĩ Lâm Văn T',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        21,
        NULL,
        'https_example.com/avatars/doc_u.png',
        NULL,
        NULL,
        NULL,
        'doctor.u@vax.com',
        'Bác sĩ Trương Thị U',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        22,
        NULL,
        'https_example.com/avatars/doc_v.png',
        NULL,
        NULL,
        NULL,
        'doctor.v@vax.com',
        'Bác sĩ Mạc Văn V',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        23,
        NULL,
        'https_example.com/avatars/doc_w.png',
        NULL,
        NULL,
        NULL,
        'doctor.w@vax.com',
        'Bác sĩ Tạ Thị W',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        3
    ),
    (
        24,
        NULL,
        'https_example.com/avatars/cash_x.png',
        NULL,
        NULL,
        NULL,
        'cashier.x@vax.com',
        'Thu ngân Đoàn Văn X',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        4
    ),
    (
        26,
        NULL,
        'https://res.cloudinary.com/dcwzhi4tp/image/upload/v1764097281/user/syrvax40k3nise2l2uak.jpg',
        NULL,
        NULL,
        NULL,
        'admin@gmail.com',
        'Super Admin',
        NULL,
        NULL,
        true,
        false,
        '$2a$10$khUSAS5S7gXcMMG6pwIPCeo5raxxdJggD/3fnKwjVTRFaBLD.TIIG',
        NULL,
        NULL,
        1
    );

-- ========================
-- Bảng: doctors
-- ========================
INSERT INTO
    doctors (
        doctor_id,
        consultation_duration,
        created_at,
        is_available,
        license_number,
        max_patients_per_day,
        specialization,
        updated_at,
        center_id,
        user_id
    )
VALUES (
        1,
        30,
        NULL,
        true,
        'BYT-000066',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        2,
        5
    ),
    (
        2,
        30,
        NULL,
        true,
        'BYT-000064',
        20,
        'Tiêm chủng người lớn',
        NULL,
        1,
        3
    ),
    (
        3,
        30,
        NULL,
        true,
        'BYT-000062',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        1,
        1
    ),
    (
        4,
        30,
        NULL,
        true,
        'BYT-000063',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        1,
        2
    ),
    (
        5,
        30,
        NULL,
        true,
        'BYT-000067',
        20,
        'Tiêm chủng người lớn',
        NULL,
        2,
        6
    ),
    (
        6,
        30,
        NULL,
        true,
        'BYT-000068',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        2,
        7
    ),
    (
        7,
        30,
        NULL,
        true,
        'BYT-000069',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        2,
        8
    ),
    (
        8,
        30,
        NULL,
        true,
        'BYT-000071',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        3,
        10
    ),
    (
        9,
        30,
        NULL,
        true,
        'BYT-000072',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        3,
        11
    ),
    (
        10,
        30,
        NULL,
        true,
        'BYT-000073',
        20,
        'Tiêm chủng người lớn',
        NULL,
        3,
        12
    ),
    (
        11,
        30,
        NULL,
        true,
        'BYT-000074',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        3,
        13
    ),
    (
        12,
        30,
        NULL,
        true,
        'BYT-000075',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        3,
        14
    ),
    (
        13,
        30,
        NULL,
        true,
        'BYT-000077',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        4,
        16
    ),
    (
        14,
        30,
        NULL,
        true,
        'BYT-000078',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        4,
        17
    ),
    (
        15,
        30,
        NULL,
        true,
        'BYT-000079',
        20,
        'Tiêm chủng người lớn',
        NULL,
        4,
        18
    ),
    (
        16,
        30,
        NULL,
        true,
        'BYT-000081',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        5,
        20
    ),
    (
        17,
        30,
        NULL,
        true,
        'BYT-000082',
        20,
        'Tiêm chủng người lớn',
        NULL,
        5,
        21
    ),
    (
        18,
        30,
        NULL,
        true,
        'BYT-000083',
        20,
        'Tiêm chủng tổng hợp',
        NULL,
        5,
        22
    ),
    (
        19,
        30,
        NULL,
        true,
        'BYT-000084',
        20,
        'Tiêm chủng trẻ em',
        NULL,
        5,
        23
    );

INSERT INTO
    cashiers (
        cashier_id,
        created_at,
        employee_code,
        is_active,
        shift_end_time,
        shift_start_time,
        updated_at,
        center_id,
        user_id
    )
VALUES (
        1,
        NULL,
        'CASHIER-001',
        true,
        '17:00:00',
        '07:30:00',
        NULL,
        1,
        4
    ),
    (
        2,
        NULL,
        'CASHIER-002',
        true,
        '17:00:00',
        '08:00:00',
        NULL,
        2,
        9
    ),
    (
        3,
        NULL,
        'CASHIER-003',
        true,
        '17:00:00',
        '07:30:00',
        NULL,
        3,
        15
    ),
    (
        4,
        NULL,
        'CASHIER-004',
        true,
        '17:00:00',
        '07:30:00',
        NULL,
        4,
        19
    ),
    (
        5,
        NULL,
        'CASHIER-005',
        true,
        '17:00:00',
        '07:30:00',
        NULL,
        5,
        24
    );