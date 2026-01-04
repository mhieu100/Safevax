package com.dapp.backend.controller;

import com.dapp.backend.annotation.ApiMessage;
import com.dapp.backend.dto.request.VaccineRequest;
import com.dapp.backend.dto.response.Pagination;
import com.dapp.backend.dto.response.VaccineResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.model.Vaccine;
import com.dapp.backend.service.VaccineService;
import com.turkraft.springfilter.boot.Filter;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vaccines")
@RequiredArgsConstructor
public class VaccineController {

    private final VaccineService vaccineService;

    @GetMapping
    @ApiMessage("Get all vaccines")
    public ResponseEntity<Pagination> getAllVaccines(@Filter Specification<Vaccine> specification,
            Pageable pageable) {
        return ResponseEntity.ok().body(vaccineService.getAllVaccines(specification, pageable));
    }

    @GetMapping("/countries")
    @ApiMessage("Get all countries")
    public ResponseEntity<List<String>> getAllCountries() {
        return ResponseEntity.ok().body(vaccineService.getAllCountries());
    }

    @GetMapping("/manufacturers")
    @ApiMessage("Get all manufacturers")
    public ResponseEntity<List<String>> getAllManufacturers() {
        return ResponseEntity.ok().body(vaccineService.getAllManufacturers());
    }

    @GetMapping("/doses-required")
    @ApiMessage("Get all doses required options")
    public ResponseEntity<List<Integer>> getAllDosesRequired() {
        return ResponseEntity.ok().body(vaccineService.getAllDosesRequired());
    }

    @GetMapping("/diseases")
    @ApiMessage("Get all diseases")
    public ResponseEntity<List<String>> getAllDiseases() {
        return ResponseEntity.ok().body(vaccineService.getAllDiseases());
    }

    @GetMapping("/{slug}")
    @ApiMessage("Get a vaccine by slug with full info")
    public ResponseEntity<VaccineResponse> getVaccine(@PathVariable String slug) throws AppException {
        return ResponseEntity.ok(vaccineService.getVaccineDetailBySlug(slug));
    }

    @PostMapping
    @ApiMessage("Create a new vaccine")
    public ResponseEntity<VaccineResponse> createVaccine(@Valid @RequestBody VaccineRequest request)
            throws AppException {
        return ResponseEntity.status(HttpStatus.CREATED).body(vaccineService.createVaccine(request));
    }

    @PutMapping("/{id}")
    @ApiMessage("Update a vaccine")
    public ResponseEntity<VaccineResponse> updateVaccine(@PathVariable Long id,
            @Valid @RequestBody VaccineRequest request) throws AppException {
        return ResponseEntity.ok().body(vaccineService.updateVaccine(id, request));
    }

    @DeleteMapping("/{id}")
    @ApiMessage("Delete a vaccine")
    public ResponseEntity<Void> deleteVaccine(@PathVariable Long id) throws AppException {
        vaccineService.deleteVaccine(id);
        return ResponseEntity.noContent().build();
    }

    // === API MỚI: Gợi ý vaccine theo đối tượng ===

    /**
     * Lấy vaccine gợi ý theo độ tuổi (tháng) và giới tính
     * GET /api/vaccines/recommended?ageInMonths=24&gender=FEMALE
     */
    @GetMapping("/recommended")
    @ApiMessage("Get recommended vaccines by age and gender")
    public ResponseEntity<List<VaccineResponse>> getRecommendedVaccines(
            @RequestParam Integer ageInMonths,
            @RequestParam(required = false, defaultValue = "ALL") String gender) {
        return ResponseEntity.ok(vaccineService.getRecommendedVaccines(ageInMonths, gender));
    }

    /**
     * Lấy vaccine thiết yếu theo độ tuổi
     * GET /api/vaccines/essential?ageInMonths=24
     */
    @GetMapping("/essential")
    @ApiMessage("Get essential vaccines by age")
    public ResponseEntity<List<VaccineResponse>> getEssentialVaccines(
            @RequestParam Integer ageInMonths) {
        return ResponseEntity.ok(vaccineService.getEssentialVaccinesByAge(ageInMonths));
    }

    /**
     * Lấy vaccine theo nhóm đối tượng
     * GET /api/vaccines/target-group/INFANT
     */
    @GetMapping("/target-group/{targetGroup}")
    @ApiMessage("Get vaccines by target group")
    public ResponseEntity<List<VaccineResponse>> getVaccinesByTargetGroup(
            @PathVariable String targetGroup) {
        return ResponseEntity.ok(vaccineService.getVaccinesByTargetGroup(targetGroup));
    }

    /**
     * Lấy vaccine theo danh mục
     * GET /api/vaccines/category/BASIC_CHILDHOOD
     */
    @GetMapping("/category/{category}")
    @ApiMessage("Get vaccines by category")
    public ResponseEntity<List<VaccineResponse>> getVaccinesByCategory(
            @PathVariable String category) {
        return ResponseEntity.ok(vaccineService.getVaccinesByCategory(category));
    }

    /**
     * Lấy vaccine theo loại bệnh
     * GET /api/vaccines/disease/Cúm
     */
    @GetMapping("/disease/{disease}")
    @ApiMessage("Get vaccines by disease")
    public ResponseEntity<List<VaccineResponse>> getVaccinesByDisease(
            @PathVariable String disease) {
        return ResponseEntity.ok(vaccineService.getVaccinesByDisease(disease));
    }

    /**
     * Lấy danh sách tất cả categories
     * GET /api/vaccines/categories
     */
    @GetMapping("/categories")
    @ApiMessage("Get all vaccine categories")
    public ResponseEntity<List<String>> getAllCategories() {
        return ResponseEntity.ok().body(vaccineService.getAllCategories());
    }

    /**
     * Lấy danh sách tất cả target groups
     * GET /api/vaccines/target-groups
     */
    @GetMapping("/target-groups")
    @ApiMessage("Get all target groups")
    public ResponseEntity<List<String>> getAllTargetGroups() {
        return ResponseEntity.ok().body(vaccineService.getAllTargetGroups());
    }

    // === API CHO PHỤ NỮ MANG THAI ===

    /**
     * Lấy vaccine an toàn cho bà bầu
     * GET /api/vaccines/pregnancy/safe
     */
    @GetMapping("/pregnancy/safe")
    @ApiMessage("Get pregnancy-safe vaccines")
    public ResponseEntity<List<VaccineResponse>> getPregnancySafeVaccines() {
        return ResponseEntity.ok(vaccineService.getPregnancySafeVaccines());
    }

    /**
     * Lấy vaccine cần tiêm TRƯỚC khi mang thai
     * GET /api/vaccines/pregnancy/pre
     */
    @GetMapping("/pregnancy/pre")
    @ApiMessage("Get pre-pregnancy vaccines")
    public ResponseEntity<List<VaccineResponse>> getPrePregnancyVaccines() {
        return ResponseEntity.ok(vaccineService.getPrePregnancyVaccines());
    }

    /**
     * Lấy vaccine cần tiêm SAU sinh
     * GET /api/vaccines/pregnancy/post
     */
    @GetMapping("/pregnancy/post")
    @ApiMessage("Get post-pregnancy vaccines")
    public ResponseEntity<List<VaccineResponse>> getPostPregnancyVaccines() {
        return ResponseEntity.ok(vaccineService.getPostPregnancyVaccines());
    }

}
