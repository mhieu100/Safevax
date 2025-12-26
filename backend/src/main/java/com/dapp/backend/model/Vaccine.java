package com.dapp.backend.model;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "vaccines")
@Data
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Vaccine extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    long id;
    String slug;
    String name;
    String country;
    String image;
    int price;
    int stock;

    @Column(name = "description_short")
    String descriptionShort;

    @Column(columnDefinition = "text")
    String description;

    @Column(name = "manufacturer", length = 1000)
    String manufacturer;

    @Column(name = "injection", columnDefinition = "TEXT")
    String injection;

    @Column(name = "preserve", columnDefinition = "TEXT")
    String preserve;

    @Column(name = "contraindications", columnDefinition = "TEXT")
    String contraindications;

    int dosesRequired;
    int duration;

    Integer daysForNextDose;

    // === Thông tin đối tượng tiêm chủng ===

    @Column(name = "target_group")
    String targetGroup; // NEWBORN, INFANT, TODDLER, CHILD, TEEN, ADULT, ELDERLY, PREGNANT, ALL

    @Column(name = "min_age_months")
    Integer minAgeMonths; // Tuổi tối thiểu (tháng)

    @Column(name = "max_age_months")
    Integer maxAgeMonths; // Tuổi tối đa (tháng), NULL = không giới hạn

    @Column(name = "gender_specific")
    String genderSpecific; // MALE, FEMALE, ALL

    @Column(name = "pregnancy_safe")
    Boolean pregnancySafe; // An toàn cho bà bầu

    @Column(name = "pre_pregnancy")
    Boolean prePregnancy; // Cần tiêm trước mang thai

    @Column(name = "post_pregnancy")
    Boolean postPregnancy; // Cần tiêm sau sinh

    @Column(name = "priority_level")
    String priorityLevel; // ESSENTIAL, RECOMMENDED, OPTIONAL, TRAVEL

    @Column(name = "category")
    String category; // BASIC_CHILDHOOD, SCHOOL_AGE, ADULT_ROUTINE, PREGNANCY, ELDERLY_CARE, TRAVEL,
                     // COVID19

    @Column(name = "disease")
    String disease; // e.g. "Influenza", "Hepatitis B"
}
