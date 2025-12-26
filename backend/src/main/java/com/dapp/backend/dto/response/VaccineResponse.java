package com.dapp.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class VaccineResponse {
    Long id;
    String slug;
    String name;
    String country;
    String image;
    Integer price;
    Integer stock;
    String descriptionShort;
    String description;
    String manufacturer;
    List<String> injection;
    List<String> preserve;
    List<String> contraindications;
    Integer dosesRequired;
    Integer duration;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
    Integer daysForNextDose;

    // === Thông tin đối tượng tiêm chủng ===
    String targetGroup; // NEWBORN, INFANT, TODDLER, CHILD, TEEN, ADULT, ELDERLY, PREGNANT, ALL
    Integer minAgeMonths; // Tuổi tối thiểu (tháng)
    Integer maxAgeMonths; // Tuổi tối đa (tháng)
    String genderSpecific; // MALE, FEMALE, ALL
    Boolean pregnancySafe; // An toàn cho bà bầu
    Boolean prePregnancy; // Cần tiêm trước mang thai
    Boolean postPregnancy; // Cần tiêm sau sinh
    String priorityLevel; // ESSENTIAL, RECOMMENDED, OPTIONAL, TRAVEL
    String category; // BASIC_CHILDHOOD, SCHOOL_AGE, ADULT_ROUTINE, PREGNANCY, ELDERLY_CARE, TRAVEL,
                     // COVID19
    String disease;
}
