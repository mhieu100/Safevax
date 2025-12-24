package com.dapp.backend.controller;

import com.dapp.backend.dto.response.VaccineRecordResponse;
import com.dapp.backend.exception.AppException;
import com.dapp.backend.service.VaccineRecordService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
@Slf4j
public class PublicVerificationController {

    private final VaccineRecordService vaccineRecordService;

    @GetMapping("/verify-vaccine/{ipfsHash}")
    public ResponseEntity<VaccineRecordResponse> verifyVaccineRecord(@PathVariable String ipfsHash)
            throws AppException {
        log.info("Public verification request for IPFS Hash: {}", ipfsHash);
        return ResponseEntity.ok(vaccineRecordService.getRecordByIpfsHash(ipfsHash));
    }

    /**
     * Verify if a patient has received a specific vaccine dose
     * Example: /api/public/verify-dose?vaccine=covid-19-pfizer&dose=3&identity=abc123hash
     */
    @GetMapping("/verify-dose")
    public ResponseEntity<VaccineRecordResponse> verifySpecificDose(
            @RequestParam("vaccine") String vaccineSlug,
            @RequestParam("dose") int doseNumber,
            @RequestParam("identity") String identityHash) throws AppException {
        log.info("Verifying dose {} of vaccine {} for identity {}", doseNumber, vaccineSlug, identityHash);
        return ResponseEntity.ok(vaccineRecordService.verifySpecificDose(vaccineSlug, doseNumber, identityHash));
    }

    /**
     * Get all verified vaccination records for a patient by identity hash
     * Example: /api/public/verify-identity/abc123hash
     */
    @GetMapping("/verify-identity/{identityHash}")
    public ResponseEntity<List<VaccineRecordResponse>> getRecordsByIdentity(
            @PathVariable String identityHash) throws AppException {
        log.info("Fetching all verified records for identity: {}", identityHash);
        return ResponseEntity.ok(vaccineRecordService.getVerifiedRecordsByIdentity(identityHash));
    }

    /**
     * Get all doses of a specific vaccine for a patient
     * Example: /api/public/verify-vaccine-doses?vaccine=covid-19-pfizer&identity=abc123hash
     */
    @GetMapping("/verify-vaccine-doses")
    public ResponseEntity<List<VaccineRecordResponse>> getVaccineDoses(
            @RequestParam("vaccine") String vaccineSlug,
            @RequestParam("identity") String identityHash) throws AppException {
        log.info("Fetching all doses of vaccine {} for identity {}", vaccineSlug, identityHash);
        return ResponseEntity.ok(vaccineRecordService.getVaccineDosesByIdentity(vaccineSlug, identityHash));
    }
}
