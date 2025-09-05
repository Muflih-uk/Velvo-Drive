package com.velvodrive.dto;

import lombok.Data;

@Data
public class VehicleDTO {
    private String name;
    private String description;
    private String model;
    private double pricePerDay;
    private String main_photo;
    private String second_photo;
    private String third_photo;
    private String ownerPhoneNumber;
    private String createdAt;
}