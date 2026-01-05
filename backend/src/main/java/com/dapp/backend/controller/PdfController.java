package com.dapp.backend.controller;

import com.dapp.backend.service.PdfService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.ByteArrayInputStream;

@RestController
@RequestMapping("/api/pdf")
public class PdfController {

    @Autowired
    private PdfService pdfService;

    @GetMapping("/generate")
    public ResponseEntity<InputStreamResource> generatePdf(@RequestParam(required = false) Long userId) {
        // TODO: In a real app, we should get the ID from the SecurityContext if not
        // provided,
        // or ensure the user is allowed to access this ID.
        // For now, if userId is null, we might need a default or handle error.
        // Let's assume the frontend passes it for now.

        if (userId == null) {
            // Throw an error or handle accordingly.
            // For simplicity, let's just return bad request or handle in service if we want
            // defaults.
            // But service expects Non-null.
            // Let's rely on the caller sending it, or maybe use a Principal to get "my"
            // records.
            // But let's stick to the simplest integration first: RequestParam.
            return ResponseEntity.badRequest().body(null);
        }

        ByteArrayInputStream bis = pdfService.generatePdf(userId);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=vaxsafe_report_" + userId + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }

    @GetMapping("/generate/record")
    public ResponseEntity<InputStreamResource> generateRecordPdf(@RequestParam Long recordId) {
        if (recordId == null) {
            return ResponseEntity.badRequest().body(null);
        }

        ByteArrayInputStream bis = pdfService.generateSingleRecordPdf(recordId);
        if (bis == null) {
            return ResponseEntity.notFound().build();
        }

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=vaccine_passport_" + recordId + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }

    @GetMapping("/generate/blockchain")
    public ResponseEntity<InputStreamResource> generateBlockchainPdf(@RequestParam String txHash) {
        if (txHash == null || txHash.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        ByteArrayInputStream bis = pdfService.generatePdfFromTransactionHash(txHash);
        if (bis == null) {
            return ResponseEntity.notFound().build();
        }

        HttpHeaders headers = new HttpHeaders();
        // Use a truncated or full hash in filename
        String shortHash = txHash.length() > 10 ? txHash.substring(0, 10) : txHash;
        headers.add("Content-Disposition", "inline; filename=blockchain_record_" + shortHash + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }

    @GetMapping("/generate/identity-hash")
    public ResponseEntity<InputStreamResource> generatePdfFromIdentityHash(@RequestParam String identityHash) {
        if (identityHash == null || identityHash.isEmpty()) {
            return ResponseEntity.badRequest().body(null);
        }

        try {
            ByteArrayInputStream bis = pdfService.generatePdfFromIdentityHash(identityHash);
            if (bis == null) {
                return ResponseEntity.notFound().build();
            }

            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Disposition",
                    "inline; filename=vaccine_passport_full_" + identityHash.substring(0, 8) + ".pdf");

            return ResponseEntity
                    .ok()
                    .headers(headers)
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(new InputStreamResource(bis));
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}
