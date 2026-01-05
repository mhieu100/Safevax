package com.dapp.backend.controller;

import com.dapp.backend.annotation.ApiMessage;
import com.dapp.backend.dto.request.FamilyMemberDetailRequest;
import com.dapp.backend.dto.response.VaccineRecordResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.model.User;
import com.dapp.backend.service.AuthService;
import com.dapp.backend.service.VaccineRecordService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/vaccine-records")
@RequiredArgsConstructor
@Slf4j
public class VaccineRecordController {

    private final VaccineRecordService vaccineRecordService;
    private final AuthService authService;

    @PostMapping("/my-records")
    @ApiMessage("Get my vaccine records")
    public ResponseEntity<List<VaccineRecordResponse>> getMyVaccineRecords() throws AppException {
        User user = authService.getCurrentUserLogin();
        log.info("Request to get vaccine records for patient ID: {}", user.getId());

        List<VaccineRecordResponse> records = vaccineRecordService.getAllVaccineRecordsByPatient(user.getId());

        log.info("Returning {} vaccine records for patient ID: {}", records.size(), user.getId());
        return ResponseEntity.ok(records);
    }

    @PostMapping("/family-records")
    @ApiMessage("Get family member vaccine records")
    public ResponseEntity<List<VaccineRecordResponse>> getFamilyMemberRecords(
            @RequestBody FamilyMemberDetailRequest request) throws AppException {
        User user = authService.getCurrentUserLogin();
        return ResponseEntity.ok(vaccineRecordService.getFamilyMemberVaccineRecords(request.getId(), user.getId()));
    }

    @GetMapping("/blockchain/my-records")
    @ApiMessage("Get my vaccine records from blockchain")
    public ResponseEntity<List<VaccineRecordResponse>> getMyBlockchainRecords() throws AppException {
        User user = authService.getCurrentUserLogin();
        return ResponseEntity.ok(vaccineRecordService.getBlockchainRecords(user.getId()));
    }

    @GetMapping("/blockchain/family/{id}")
    @ApiMessage("Get family member vaccine records from blockchain")
    public ResponseEntity<List<VaccineRecordResponse>> getFamilyMemberBlockchainRecords(@PathVariable Long id)
            throws AppException {
        User user = authService.getCurrentUserLogin();
        return ResponseEntity.ok(vaccineRecordService.getFamilyMemberBlockchainRecords(id, user.getId()));
    }
}
