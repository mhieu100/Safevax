-- ============================================================
-- Migration: Sửa các điểm bất hợp lý trong target groups
-- Author: VaxSafe Team  
-- Date: 2025-12-24
-- Description: Fix HPV cho cả nam/nữ, BCG max age, Viêm gan B pregnancy safe
-- ============================================================

-- 1. BCG - Có thể tiêm bù cho trẻ đến 12 tháng nếu chưa tiêm sơ sinh
UPDATE vaccines SET 
    max_age_months = 12
WHERE slug IN ('bcg-vac-xin-phong-lao');

-- 2. Viêm gan B - An toàn cho phụ nữ mang thai nếu có chỉ định, mọi lứa tuổi đều tiêm được
UPDATE vaccines SET 
    target_group = 'ALL',
    pregnancy_safe = TRUE
WHERE slug IN ('engerix-b-vac-xin-phong-viem-gan-b', 'vac-xin-euvax-b', 'heberbiovac-hb', 'vac-xin-gene-hbvax', 'engerix-b-viem-gan-b-tre-em');

-- 3. Pneumovax-23 - Chỉ cho người từ 2 tuổi, khuyến cáo cho người cao tuổi (tách khỏi nhóm trẻ em)
UPDATE vaccines SET 
    target_group = 'ADULT',
    min_age_months = 24,
    priority_level = 'RECOMMENDED',
    category = 'ELDERLY_CARE'
WHERE slug = 'vac-xin-pneumovax-23';

-- 4. Huyết thanh uốn ván (SAT) - Đây là huyết thanh điều trị, không phải vaccine phòng ngừa
UPDATE vaccines SET 
    target_group = 'ALL',
    min_age_months = 0,
    priority_level = 'OPTIONAL'
WHERE slug = 'huyet-thanh-uon-van-sat';

-- 5. Uốn ván - Bạch hầu vaccine (loại bỏ huyết thanh khỏi nhóm này)
UPDATE vaccines SET 
    pregnancy_safe = TRUE
WHERE slug IN ('vac-xin-uon-van-bach-hau-hap-phu-td-viet-nam', 'vac-xin-vat');
