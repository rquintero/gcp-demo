package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dto.RecommendationDTO;

@Service
public class RecommendationService {

    public List<RecommendationDTO> recommendations(int top) {
        var recommx = new RecommendationDTO();
        recommx.setDescription("Unlock advanced features and priority support for the ultimate user experience.");
        recommx.setName("Paradise Beach");
        recommx.setImageUrl("https://storage.googleapis.com/hack-beach/beach.jpg");
        recommx.setPrice(99.99);
        recommx.setWeather("23 °C - Sunny");
        return List.of(recommx, recommx, recommx);
    }
}
