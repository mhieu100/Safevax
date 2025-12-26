-- ============================================================
-- Migration: Add missing data for Disease, Target Group, Age filters
-- Description: Updates existing vaccines with disease, target_group, min/max age, and category data.
-- ============================================================

UPDATE vaccines
SET
    disease = 'Viêm gan A, Viêm gan B',
    target_group = 'ADULT',
    min_age_months = 12,
    category = 'TRAVEL'
WHERE
    slug = 'twinrix';

UPDATE vaccines
SET
    disease = 'Thương hàn',
    target_group = 'CHILD',
    min_age_months = 24,
    category = 'TRAVEL'
WHERE
    slug = 'typhim-vi-vac-xin-phong-thuong-han';

UPDATE vaccines
SET
    disease = 'Sởi, Quai bị, Rubella',
    target_group = 'CHILD',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'mmr-ii-vac-xin-phong-3-benh-soi-quai-bi-rubella';

UPDATE vaccines
SET
    disease = 'Bạch hầu, Ho gà, Uốn ván, Bại liệt',
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = 156,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-tetraxim';

UPDATE vaccines
SET
    disease = 'Cúm',
    target_group = 'ALL',
    min_age_months = 6,
    category = 'ADULT_ROUTINE'
WHERE
    slug = 'vaxigrip-tetra';

UPDATE vaccines
SET
    disease = 'Viêm não Nhật Bản',
    target_group = 'INFANT',
    min_age_months = 9,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'imojev-vac-xin-phong-viem-nao-nhat-ban-moi';

UPDATE vaccines
SET
    disease = 'Viêm gan A',
    target_group = 'CHILD',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'avaxim-vac-xin-phong-viem-gan';

UPDATE vaccines
SET
    disease = 'Viêm gan A',
    target_group = 'CHILD',
    min_age_months = 24,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-havax';

UPDATE vaccines
SET
    disease = 'Tả',
    target_group = 'CHILD',
    min_age_months = 24,
    category = 'TRAVEL'
WHERE
    slug = 'morcvax-vac-xin-phong-benh-ta';

UPDATE vaccines
SET
    disease = 'Viêm não mủ Hib',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-quimi-hib';

UPDATE vaccines
SET
    disease = 'Cúm',
    target_group = 'ALL',
    min_age_months = 6,
    category = 'ADULT_ROUTINE'
WHERE
    slug = 'gcflu-quadrivalent-phong-cum-mua';

UPDATE vaccines
SET
    disease = 'Phế cầu',
    target_group = 'ADULT',
    min_age_months = 216,
    category = 'ELDERLY_CARE'
WHERE
    slug = 'vac-xin-prevenar-20';

UPDATE vaccines
SET
    disease = 'Cúm',
    target_group = 'ALL',
    min_age_months = 6,
    category = 'ADULT_ROUTINE'
WHERE
    slug = 'influvac-tetra';

UPDATE vaccines
SET
    disease = 'Viêm gan B',
    target_group = 'ALL',
    min_age_months = 0,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'heberbiovac-hb';

UPDATE vaccines
SET
    disease = 'Bạch hầu, Ho gà, Uốn ván, Bại liệt, Viêm gan B, Hib',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'hexaxim-vac-xin-6-trong-1';

UPDATE vaccines
SET
    disease = 'Rotavirus',
    target_group = 'INFANT',
    min_age_months = 1,
    max_age_months = 6,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-rotarix';

UPDATE vaccines
SET
    disease = 'Viêm màng não mô cầu',
    target_group = 'CHILD',
    min_age_months = 9,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'menactra-vac-xin-nao-mo-cau-nhom-acy-va-w-135-polysaccharide-cong-hop-giai-doc-bach-hau';

UPDATE vaccines
SET
    disease = 'HPV',
    target_group = 'TEEN',
    min_age_months = 108,
    category = 'SCHOOL_AGE'
WHERE
    slug = 'vac-xin-gardasil-9';

UPDATE vaccines
SET
    disease = 'Thủy đậu',
    target_group = 'CHILD',
    min_age_months = 9,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'varilrix-vac-xin-phong-benh-thuy-dau';

UPDATE vaccines
SET
    disease = 'Bạch hầu, Ho gà, Uốn ván, Bại liệt, Hib',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-5-trong-1-infanrix-ipv-hib';

UPDATE vaccines
SET
    disease = 'Sốt vàng',
    target_group = 'CHILD',
    min_age_months = 9,
    category = 'TRAVEL'
WHERE
    slug = 'stamaril-vac-xin-phong-benh-sot-vang';

UPDATE vaccines
SET
    disease = 'Phế cầu',
    target_group = 'ELDERLY',
    min_age_months = 24,
    category = 'ELDERLY_CARE'
WHERE
    slug = 'vac-xin-pneumovax-23';

UPDATE vaccines
SET
    disease = 'Viêm màng não mô cầu B',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-bexsero';

UPDATE vaccines
SET
    disease = 'Phế cầu',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'prevenar-13-vac-xin-phong-benh-viem-phoi-viem-mang-nao-viem-tai-giua-nhiem-khuan-huyet-phe-cau-khuan';

UPDATE vaccines
SET
    disease = 'Viêm não Nhật Bản',
    target_group = 'INFANT',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-jeev';

UPDATE vaccines
SET
    disease = 'Thủy đậu',
    target_group = 'CHILD',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-varicella';

UPDATE vaccines
SET
    disease = 'Sởi, Quai bị, Rubella',
    target_group = 'CHILD',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-mmr';

UPDATE vaccines
SET
    disease = 'Viêm gan B',
    target_group = 'ALL',
    min_age_months = 0,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'engerix-b-vac-xin-phong-viem-gan-b';

UPDATE vaccines
SET
    disease = 'Viêm gan B',
    target_group = 'ALL',
    min_age_months = 0,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-euvax-b';

UPDATE vaccines
SET
    disease = 'Thương hàn',
    target_group = 'CHILD',
    min_age_months = 24,
    category = 'TRAVEL'
WHERE
    slug = 'typhoid-vi-polysaccharide-vi-vac-xin-phong-benh-thuong-han';

UPDATE vaccines
SET
    disease = 'Viêm màng não mô cầu',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-nimenrix';

UPDATE vaccines
SET
    disease = 'Rotavirus',
    target_group = 'INFANT',
    min_age_months = 2,
    max_age_months = 6,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'rotavin-m1-vac-xin-phong-benh-tieu-chay-cap-rotavirus';

UPDATE vaccines
SET
    disease = 'Viêm màng não mô cầu',
    target_group = 'INFANT',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-menquadfi';

UPDATE vaccines
SET
    disease = 'Phế cầu',
    target_group = 'INFANT',
    min_age_months = 2,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-vaxneuvance-15';

UPDATE vaccines
SET
    disease = 'Thủy đậu',
    target_group = 'CHILD',
    min_age_months = 12,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'varivax-vac-xin-phong-thuy-dau';

UPDATE vaccines
SET
    disease = 'Viêm màng não mô cầu',
    target_group = 'INFANT',
    min_age_months = 3,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'va-mengoc-bc-vac-xin-phong-viem-mang-nao-nao-mo-cau-b-c';

UPDATE vaccines
SET
    disease = 'Cúm',
    target_group = 'ALL',
    min_age_months = 18,
    category = 'ADULT_ROUTINE'
WHERE
    slug = 'vac-xin-ivacflu-s';

UPDATE vaccines
SET
    disease = 'Sởi',
    target_group = 'INFANT',
    min_age_months = 9,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'vac-xin-mvvac';

UPDATE vaccines
SET
    disease = 'Lao',
    target_group = 'NEWBORN',
    min_age_months = 0,
    category = 'BASIC_CHILDHOOD'
WHERE
    slug = 'bcg-vac-xin-phong-lao';