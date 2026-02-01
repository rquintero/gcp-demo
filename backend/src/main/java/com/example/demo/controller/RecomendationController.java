package com.example.demo.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.RecommendationDTO;
import com.example.demo.service.RecommendationService;

import lombok.RequiredArgsConstructor;

@RestController
@CrossOrigin(origins = {"http://localhost:3000", "https://0.0.0.0:3000"}, 
             allowedHeaders = "*", 
             methods = {org.springframework.web.bind.annotation.RequestMethod.GET, 
                       org.springframework.web.bind.annotation.RequestMethod.POST, 
                       org.springframework.web.bind.annotation.RequestMethod.PUT, 
                       org.springframework.web.bind.annotation.RequestMethod.DELETE, 
                       org.springframework.web.bind.annotation.RequestMethod.OPTIONS},
             allowCredentials = "true")
@RequiredArgsConstructor
public class RecomendationController {

    private final RecommendationService recommendationService;

    @GetMapping("/top-recommendations")
    public ResponseEntity<List<RecommendationDTO>> topRecommendations(
        @RequestParam(defaultValue = "3") int top) {
        
        return new ResponseEntity<>(recommendationService.recommendations(top), HttpStatus.OK);
    }
}
