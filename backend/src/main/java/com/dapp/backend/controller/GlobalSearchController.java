package com.dapp.backend.controller;

import com.dapp.backend.dto.response.GlobalSearchResponse;
import com.dapp.backend.dto.response.NewsResponse;
import com.dapp.backend.dto.response.VaccineResponse;
import com.dapp.backend.service.NewsService;
import com.dapp.backend.service.RagService;
import com.dapp.backend.service.VaccineService;
import com.dapp.backend.service.spec.NewsSpecifications;
import com.dapp.backend.service.spec.VaccineSpecifications;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/search")
public class GlobalSearchController {

    private final VaccineService vaccineService;
    private final NewsService newsService;
    private final RagService ragService;

    public GlobalSearchController(VaccineService vaccineService, NewsService newsService, RagService ragService) {
        this.vaccineService = vaccineService;
        this.newsService = newsService;
        this.ragService = ragService;
    }

    @GetMapping("/global")
    public ResponseEntity<GlobalSearchResponse> globalSearch(@RequestParam String query) {
        if (query == null || query.trim().isEmpty()) {
            return ResponseEntity.ok(new GlobalSearchResponse(Collections.emptyList(), Collections.emptyList(), null));
        }

        String searchTerm = query.trim();

        // Run searches in parallel to improve performance
        CompletableFuture<List<VaccineResponse>> vaccinesFuture = CompletableFuture.supplyAsync(() -> {
            try {
                Object result = vaccineService.getAllVaccines(
                        VaccineSpecifications.globalSearch(searchTerm),
                        PageRequest.of(0, 5, Sort.by("name").ascending())).getResult();
                return (List<VaccineResponse>) result;
            } catch (Exception e) {
                return Collections.emptyList();
            }
        });

        CompletableFuture<List<NewsResponse>> newsFuture = CompletableFuture.supplyAsync(() -> {
            try {
                Object result = newsService.getAllNews(
                        NewsSpecifications.contentContains(searchTerm).and(NewsSpecifications.isPublished()),
                        PageRequest.of(0, 5, Sort.by("publishedAt").descending())).getResult();
                return (List<NewsResponse>) result;
            } catch (Exception e) {
                return Collections.emptyList();
            }
        });

        CompletableFuture<String> aiFuture = CompletableFuture.supplyAsync(() -> {
            // Smart AI Trigger: Only query AI for questions or sufficiently complex queries
            // Simple heuristics: contains '?' or length > 10
            if (searchTerm.contains("?") ||
                    searchTerm.toLowerCase().contains("là gì") ||
                    searchTerm.toLowerCase().contains("như thế nào") ||
                    searchTerm.toLowerCase().contains("có nên") ||
                    searchTerm.length() > 15) {
                try {
                    return ragService.chat(searchTerm);
                } catch (Exception e) {
                    // Log error if needed, but return null to not break flow
                    return null;
                }
            }
            return null;
        });

        try {
            // Wait for all to complete
            CompletableFuture.allOf(vaccinesFuture, newsFuture, aiFuture).join();

            return ResponseEntity.ok(new GlobalSearchResponse(
                    vaccinesFuture.get(),
                    newsFuture.get(),
                    aiFuture.get()));

        } catch (Exception e) {
            // In case of severe thread error, try to return partial results or error
            return ResponseEntity.internalServerError().build();
        }
    }
}
