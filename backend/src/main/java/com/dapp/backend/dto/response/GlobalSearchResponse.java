package com.dapp.backend.dto.response;

import java.util.List;

public class GlobalSearchResponse {
    private List<VaccineResponse> vaccines;
    private List<NewsResponse> news;
    private String aiConsultation;

    public GlobalSearchResponse() {
    }

    public GlobalSearchResponse(List<VaccineResponse> vaccines, List<NewsResponse> news, String aiConsultation) {
        this.vaccines = vaccines;
        this.news = news;
        this.aiConsultation = aiConsultation;
    }

    public List<VaccineResponse> getVaccines() {
        return vaccines;
    }

    public void setVaccines(List<VaccineResponse> vaccines) {
        this.vaccines = vaccines;
    }

    public List<NewsResponse> getNews() {
        return news;
    }

    public void setNews(List<NewsResponse> news) {
        this.news = news;
    }

    public String getAiConsultation() {
        return aiConsultation;
    }

    public void setAiConsultation(String aiConsultation) {
        this.aiConsultation = aiConsultation;
    }
}
