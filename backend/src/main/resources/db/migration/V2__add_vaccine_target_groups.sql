-- ============================================================
-- Migration: Thêm thông tin đối tượng tiêm chủng cho vaccines
-- Author: VaxSafe Team
-- Date: 2025-12-24
-- Description: Bổ sung các trường để gợi ý vaccine theo đối tượng
-- ============================================================

-- 1. Thêm các cột mới vào bảng vaccines
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS target_group VARCHAR(50);
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS min_age_months INT DEFAULT 0;
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS max_age_months INT DEFAULT NULL;
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS gender_specific VARCHAR(10) DEFAULT 'ALL';
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS pregnancy_safe BOOLEAN DEFAULT FALSE;
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS pre_pregnancy BOOLEAN DEFAULT FALSE;
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS post_pregnancy BOOLEAN DEFAULT FALSE;
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS priority_level VARCHAR(20) DEFAULT 'RECOMMENDED';
ALTER TABLE vaccines ADD COLUMN IF NOT EXISTS category VARCHAR(50);

-- 2. Tạo ENUM types cho việc validate (PostgreSQL)
-- COMMENT: target_group values: NEWBORN, INFANT, TODDLER, CHILD, TEEN, ADULT, ELDERLY, PREGNANT, ALL
-- COMMENT: gender_specific values: MALE, FEMALE, ALL
-- COMMENT: priority_level values: ESSENTIAL, RECOMMENDED, OPTIONAL, TRAVEL
-- COMMENT: category values: BASIC_CHILDHOOD, SCHOOL_AGE, ADULT_ROUTINE, PREGNANCY, ELDERLY_CARE, TRAVEL, COVID19

-- ============================================================
-- 3. CẬP NHẬT VACCINE CHO TRẺ SƠ SINH (0-2 tháng)
-- ============================================================
-- BCG (Lao) - Tiêm 1 lần duy nhất lúc sơ sinh, hoặc bổ sung cho trẻ chưa tiêm
UPDATE vaccines SET 
    target_group = 'NEWBORN',
    min_age_months = 0,
    max_age_months = 12,   -- Có thể tiêm bù đến 12 tháng tuổi nếu chưa tiêm
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,  -- Không tiêm khi mang thai
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('bcg-vac-xin-phong-lao');

-- Viêm gan B (có thể tiêm cho mọi lứa tuổi, bao gồm cả phụ nữ mang thai nếu có nguy cơ)
UPDATE vaccines SET 
    target_group = 'ALL',
    min_age_months = 0,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- An toàn cho phụ nữ mang thai nếu có chỉ định
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('engerix-b-vac-xin-phong-viem-gan-b', 'vac-xin-euvax-b', 'heberbiovac-hb', 'vac-xin-gene-hbvax', 'engerix-b-viem-gan-b-tre-em');

-- ============================================================
-- 4. CẬP NHẬT VACCINE CHO TRẺ NHŨ NHI (2-12 tháng)
-- ============================================================

-- Vaccine 5 trong 1, 6 trong 1
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = 24,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'hexaxim-vac-xin-6-trong-1', 
    'infanrix-vac-xin-6-trong-1',
    'pentaxim-vac-xin-5-trong-1',
    'vac-xin-5-trong-1-infanrix-ipv-hib',
    'vac-xin-tetraxim',
    'pentaxim-5-trong-1-tre-em',
    'infanrix-hexa-6-trong-1',
    'dpt-viet-nam'
);

-- Rotavirus
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 1,  -- 6 tuần = ~1.5 tháng
    max_age_months = 8,  -- 32 tuần = ~8 tháng
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('vac-xin-rotarix', 'rotavin-m1-vac-xin-phong-benh-tieu-chay-cap-rotavirus', 'vac-xin-rotateq', 'rotateq');

-- Phế cầu kết hợp (Prevenar, Synflorix) - cho trẻ em và người lớn
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = NULL,  -- Có thể tiêm cho người lớn
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'prevenar-13-vac-xin-phong-benh-viem-phoi-viem-mang-nao-viem-tai-giua-nhiem-khuan-huyet-phe-cau-khuan',
    'synflorix-vac-xin-phong-viem-nao-viem-phoi-nhiem-khuan-huyet-viem-tai-giua-h-influenzae-khong-dinh-tuyp',
    'vac-xin-prevenar-20',
    'vac-xin-vaxneuvance-15'
);

-- Phế cầu polysaccharide (Pneumovax-23) - CHỈ cho người từ 2 tuổi, khuyến cáo cho người cao tuổi
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 24,    -- Từ 2 tuổi
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'ELDERLY_CARE'
WHERE slug = 'vac-xin-pneumovax-23';

-- Não mô cầu
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'vac-xin-bexsero',
    'menactra-vac-xin-nao-mo-cau-nhom-acy-va-w-135-polysaccharide-cong-hop-giai-doc-bach-hau',
    'vac-xin-nimenrix',
    'vac-xin-menquadfi',
    'va-mengoc-bc-vac-xin-phong-viem-mang-nao-nao-mo-cau-b-c'
);

-- HIB
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = 60,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('vac-xin-quimi-hib', 'hib-viem-mang-nao-mu');

-- ============================================================
-- 5. CẬP NHẬT VACCINE CHO TRẺ NHỎ (12-60 tháng / 1-5 tuổi)
-- ============================================================

-- Sởi - Quai bị - Rubella (MMR)
UPDATE vaccines SET 
    target_group = 'TODDLER',
    min_age_months = 9,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    pre_pregnancy = TRUE,  -- Phụ nữ nên tiêm TRƯỚC khi mang thai
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'mmr-ii-vac-xin-phong-3-benh-soi-quai-bi-rubella',
    'vac-xin-mmr',
    'vac-xin-priorix',
    'vac-xin-mrvac',
    'vac-xin-mvvac',
    'priorix'
);

-- Thủy đậu
UPDATE vaccines SET 
    target_group = 'TODDLER',
    min_age_months = 9,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    pre_pregnancy = TRUE,
    priority_level = 'RECOMMENDED',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'varilrix-vac-xin-phong-benh-thuy-dau',
    'varivax-vac-xin-phong-thuy-dau',
    'vac-xin-varicella',
    'varivax'
);

-- Viêm não Nhật Bản
UPDATE vaccines SET 
    target_group = 'TODDLER',
    min_age_months = 9,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN (
    'imojev-vac-xin-phong-viem-nao-nhat-ban-moi',
    'vac-xin-jeev',
    'jevax-vac-xin-phong-viem-nao-nhat-ban-b'
);

-- Viêm gan A
UPDATE vaccines SET 
    target_group = 'TODDLER',
    min_age_months = 12,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('avaxim-vac-xin-phong-viem-gan', 'vac-xin-havax');

-- Viêm gan A+B kết hợp
UPDATE vaccines SET 
    target_group = 'TODDLER',
    min_age_months = 12,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'BASIC_CHILDHOOD'
WHERE slug = 'twinrix';

-- Bại liệt
UPDATE vaccines SET 
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'ESSENTIAL',
    category = 'BASIC_CHILDHOOD'
WHERE slug IN ('ipv-bai-liet-tiem', 'opv-bai-liet-uong');

-- ============================================================
-- 6. CẬP NHẬT VACCINE CHO THANH THIẾU NIÊN (10-18 tuổi)
-- ============================================================

-- HPV (Phòng ung thư cổ tử cung, ung thư hậu môn, mụn cóc sinh dục - cho CẢ NAM VÀ NỮ)
-- Nam giới tiêm HPV để phòng ung thư hậu môn, dương vật và mụn cóc sinh dục
UPDATE vaccines SET 
    target_group = 'TEEN',
    min_age_months = 108,  -- 9 tuổi
    max_age_months = 540,  -- 45 tuổi
    gender_specific = 'ALL',  -- CẢ NAM VÀ NỮ đều có thể tiêm
    pregnancy_safe = FALSE,  -- Không tiêm khi đang mang thai
    pre_pregnancy = TRUE,    -- Nên hoàn thành trước khi mang thai
    priority_level = 'ESSENTIAL',
    category = 'SCHOOL_AGE'
WHERE slug IN ('vac-xin-gardasil-9', 'gardasil-vac-xin-phong-ung-thu-co-tu-cung');

-- ============================================================
-- 7. CẬP NHẬT VACCINE CHO NGƯỜI LỚN
-- ============================================================

-- Cúm mùa (cho mọi đối tượng từ 6 tháng tuổi)
UPDATE vaccines SET 
    target_group = 'ALL',
    min_age_months = 6,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- An toàn cho bà bầu
    priority_level = 'RECOMMENDED',
    category = 'ADULT_ROUTINE'
WHERE slug IN (
    'vaxigrip-tetra',
    'influvac-tetra',
    'gcflu-quadrivalent-phong-cum-mua',
    'vac-xin-ivacflu-s',
    'vaxigrip-tetra-phu-nu-mang-thai'
);

-- Ho gà - Bạch hầu - Uốn ván (cho người lớn và bà bầu)
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 84,  -- 7 tuổi trở lên
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- Khuyến cáo cho bà bầu
    priority_level = 'RECOMMENDED',
    category = 'ADULT_ROUTINE'
WHERE slug IN ('boostrix', 'vac-xin-adacel', 'tdap-boostrix-phu-nu-mang-thai', 'adacel-tdap-nguoi-lon');

-- Uốn ván - Bạch hầu (Vaccine)
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 84,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- Khuyến cáo tiêm cho bà bầu
    priority_level = 'RECOMMENDED',
    category = 'ADULT_ROUTINE'
WHERE slug IN ('vac-xin-uon-van-bach-hau-hap-phu-td-viet-nam', 'vac-xin-vat');

-- Huyết thanh uốn ván (SAT) - Dùng điều trị khẩn cấp, không phải vaccine phòng ngừa
UPDATE vaccines SET 
    target_group = 'ALL',
    min_age_months = 0,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- Có thể dùng khi cấp cứu
    priority_level = 'OPTIONAL',
    category = 'ADULT_ROUTINE'
WHERE slug = 'huyet-thanh-uon-van-sat';

-- Zona thần kinh (người cao tuổi)
UPDATE vaccines SET 
    target_group = 'ELDERLY',
    min_age_months = 600,  -- 50 tuổi
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'ELDERLY_CARE'
WHERE slug = 'vac-xin-shingrix';

-- Phế cầu cho người cao tuổi
UPDATE vaccines SET 
    target_group = 'ELDERLY',
    min_age_months = 216,  -- 18 tuổi, nhưng khuyến cáo cho >50
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'ELDERLY_CARE'
WHERE slug = 'vac-xin-prevenar-20';

-- ============================================================
-- 8. CẬP NHẬT VACCINE DÀNH RIÊNG CHO PHỤ NỮ MANG THAI
-- ============================================================

UPDATE vaccines SET 
    target_group = 'PREGNANT',
    pregnancy_safe = TRUE,
    priority_level = 'ESSENTIAL',
    category = 'PREGNANCY'
WHERE slug IN (
    'tdap-boostrix-phu-nu-mang-thai',
    'vaxigrip-tetra-phu-nu-mang-thai',
    'engerix-b-phu-nu-mang-thai'
);

-- ============================================================
-- 9. CẬP NHẬT VACCINE DU LỊCH
-- ============================================================

-- Thương hàn
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 24,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'TRAVEL',
    category = 'TRAVEL'
WHERE slug IN ('typhim-vi-vac-xin-phong-thuong-han', 'typhoid-vi-polysaccharide-vi-vac-xin-phong-benh-thuong-han');

-- Tả
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 24,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'TRAVEL',
    category = 'TRAVEL'
WHERE slug = 'morcvax-vac-xin-phong-benh-ta';

-- Sốt vàng
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 9,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'TRAVEL',
    category = 'TRAVEL'
WHERE slug = 'stamaril-vac-xin-phong-benh-sot-vang';

-- Dại
UPDATE vaccines SET 
    target_group = 'ALL',
    min_age_months = 0,
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- Có thể tiêm khi cần thiết
    priority_level = 'OPTIONAL',
    category = 'TRAVEL'
WHERE slug IN ('vac-xin-abhayrab', 'verorab-vac-xin-phong-dai');

-- Sốt xuất huyết
UPDATE vaccines SET 
    target_group = 'CHILD',
    min_age_months = 48,  -- 4 tuổi
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = FALSE,
    priority_level = 'RECOMMENDED',
    category = 'TRAVEL'
WHERE slug = 'vac-xin-qdenga';

-- ============================================================
-- 10. CẬP NHẬT VACCINE COVID-19
-- ============================================================

UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 216,  -- 18 tuổi
    max_age_months = NULL,
    gender_specific = 'ALL',
    pregnancy_safe = TRUE,  -- Một số vaccine COVID an toàn cho bà bầu
    priority_level = 'RECOMMENDED',
    category = 'COVID19'
WHERE slug IN (
    'comirnaty-pfizer-biontech',
    'spikevax-moderna',
    'vaxzevria-astrazeneca',
    'covilo-sinopharm',
    'abdala'
);

-- ============================================================
-- 11. Tạo INDEX cho các trường mới (tăng performance query)
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_vaccines_target_group ON vaccines(target_group);
CREATE INDEX IF NOT EXISTS idx_vaccines_category ON vaccines(category);
CREATE INDEX IF NOT EXISTS idx_vaccines_min_age ON vaccines(min_age_months);
CREATE INDEX IF NOT EXISTS idx_vaccines_pregnancy_safe ON vaccines(pregnancy_safe);
CREATE INDEX IF NOT EXISTS idx_vaccines_pre_pregnancy ON vaccines(pre_pregnancy);

-- ============================================================
-- 12. Cập nhật các vaccine còn lại chưa có target_group
-- ============================================================
UPDATE vaccines SET 
    target_group = 'ALL',
    gender_specific = 'ALL',
    priority_level = 'RECOMMENDED',
    category = 'ADULT_ROUTINE'
WHERE target_group IS NULL;

-- ============================================================
-- COMMENT: Giải thích các giá trị
-- ============================================================
/*
TARGET_GROUP - Nhóm đối tượng chính (dựa theo khuyến cáo của WHO và Bộ Y tế Việt Nam):
- NEWBORN: Trẻ sơ sinh (0-2 tháng)
- INFANT: Trẻ nhũ nhi (2-12 tháng)
- TODDLER: Trẻ mới biết đi (1-5 tuổi)
- CHILD: Trẻ em (6-12 tuổi)
- TEEN: Thanh thiếu niên (9-18 tuổi) - Bao gồm vaccine HPV cho CẢ NAM VÀ NỮ
- ADULT: Người lớn (19-50 tuổi)
- ELDERLY: Người cao tuổi (>50 tuổi)
- PREGNANT: Phụ nữ mang thai
- ALL: Mọi đối tượng

GENDER_SPECIFIC - Giới tính có thể tiêm:
- ALL: Cả nam và nữ (mặc định - hầu hết vaccine)
- MALE: Chỉ nam giới
- FEMALE: Chỉ nữ giới
LƯU Ý: HPV (Gardasil) có gender_specific = 'ALL' vì nam giới cũng cần tiêm để:
  + Phòng ung thư hậu môn, dương vật, hầu họng
  + Phòng mụn cóc sinh dục
  + Giảm lây truyền HPV cho bạn tình

PREGNANCY_SAFE - An toàn khi mang thai:
- TRUE: Có thể tiêm khi đang mang thai (Cúm, Tdap, Viêm gan B nếu cần...)
- FALSE: KHÔNG tiêm khi mang thai (MMR, Thủy đậu, HPV, BCG...)

PRE_PREGNANCY - Nên tiêm TRƯỚC khi mang thai:
- TRUE: Khuyến cáo hoàn thành trước khi có thai (MMR, Thủy đậu, HPV)

POST_PREGNANCY - Nên tiêm SAU sinh:
- TRUE: Nên tiêm sau khi sinh nếu chưa có miễn dịch

CATEGORY:
- BASIC_CHILDHOOD: Vaccine cơ bản cho trẻ em (theo chương trình tiêm chủng mở rộng)
- SCHOOL_AGE: Vaccine cho lứa tuổi đi học (HPV, nhắc lại DPT...)
- ADULT_ROUTINE: Vaccine thường quy cho người lớn
- PREGNANCY: Vaccine cho phụ nữ mang thai/chuẩn bị mang thai
- ELDERLY_CARE: Vaccine cho người cao tuổi (Phế cầu, Zona...)
- TRAVEL: Vaccine du lịch (Thương hàn, Sốt vàng...)
- COVID19: Vaccine COVID-19

PRIORITY_LEVEL:
- ESSENTIAL: Thiết yếu, trong chương trình tiêm chủng quốc gia
- RECOMMENDED: Khuyến cáo bởi chuyên gia y tế
- OPTIONAL: Tùy chọn theo nhu cầu
- TRAVEL: Bắt buộc hoặc khuyến cáo khi đi du lịch
*/
