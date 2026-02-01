package com.example.demo.dto;

import lombok.Data;

@Data
public class RecommendationDTO {

    private String imageUrl;
    private String description;
    private String name;
    private Number price;
    private String weather;

}
