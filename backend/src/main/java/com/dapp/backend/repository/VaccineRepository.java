package com.dapp.backend.repository;

import com.dapp.backend.model.Vaccine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface VaccineRepository extends JpaRepository<Vaccine, Long>, JpaSpecificationExecutor<Vaccine> {
    List<Vaccine> findAllByName(String vaccineName);
    Optional<Vaccine> findBySlug(String slug);
    @Query("SELECT DISTINCT country FROM Vaccine")
    List<String> findDistinctCountries();
    
    // === Queries cho việc gợi ý vaccine theo đối tượng ===
    
    /**
     * Tìm vaccine phù hợp với độ tuổi (tính theo tháng)
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false " +
           "AND (v.minAgeMonths IS NULL OR v.minAgeMonths <= :ageInMonths) " +
           "AND (v.maxAgeMonths IS NULL OR v.maxAgeMonths >= :ageInMonths)")
    List<Vaccine> findByAgeRange(@Param("ageInMonths") Integer ageInMonths);
    
    /**
     * Tìm vaccine theo nhóm đối tượng
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false " +
           "AND (v.targetGroup = :targetGroup OR v.targetGroup = 'ALL')")
    List<Vaccine> findByTargetGroup(@Param("targetGroup") String targetGroup);
    
    /**
     * Tìm vaccine an toàn cho phụ nữ mang thai
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false AND v.pregnancySafe = true")
    List<Vaccine> findPregnancySafeVaccines();
    
    /**
     * Tìm vaccine cần tiêm trước khi mang thai
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false AND v.prePregnancy = true")
    List<Vaccine> findPrePregnancyVaccines();
    
    /**
     * Tìm vaccine cần tiêm sau sinh
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false AND v.postPregnancy = true")
    List<Vaccine> findPostPregnancyVaccines();
    
    /**
     * Tìm vaccine theo danh mục
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false AND v.category = :category")
    List<Vaccine> findByCategory(@Param("category") String category);
    
    /**
     * Tìm vaccine theo giới tính
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false " +
           "AND (v.genderSpecific = :gender OR v.genderSpecific = 'ALL')")
    List<Vaccine> findByGender(@Param("gender") String gender);
    
    /**
     * Tìm vaccine phù hợp với độ tuổi và giới tính
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false " +
           "AND (v.minAgeMonths IS NULL OR v.minAgeMonths <= :ageInMonths) " +
           "AND (v.maxAgeMonths IS NULL OR v.maxAgeMonths >= :ageInMonths) " +
           "AND (v.genderSpecific = :gender OR v.genderSpecific = 'ALL') " +
           "ORDER BY v.priorityLevel ASC, v.name ASC")
    List<Vaccine> findRecommendedVaccines(
        @Param("ageInMonths") Integer ageInMonths, 
        @Param("gender") String gender
    );
    
    /**
     * Tìm vaccine thiết yếu theo độ tuổi
     */
    @Query("SELECT v FROM Vaccine v WHERE v.isDeleted = false " +
           "AND v.priorityLevel = 'ESSENTIAL' " +
           "AND (v.minAgeMonths IS NULL OR v.minAgeMonths <= :ageInMonths) " +
           "AND (v.maxAgeMonths IS NULL OR v.maxAgeMonths >= :ageInMonths)")
    List<Vaccine> findEssentialVaccinesByAge(@Param("ageInMonths") Integer ageInMonths);
    
    /**
     * Lấy danh sách các category có sẵn
     */
    @Query("SELECT DISTINCT v.category FROM Vaccine v WHERE v.category IS NOT NULL")
    List<String> findDistinctCategories();
    
    /**
     * Lấy danh sách các target group có sẵn
     */
    @Query("SELECT DISTINCT v.targetGroup FROM Vaccine v WHERE v.targetGroup IS NOT NULL")
    List<String> findDistinctTargetGroups();
}
