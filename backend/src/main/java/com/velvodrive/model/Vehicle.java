package com.velvodrive.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String model;
    private double pricePerDay;
    private String main_photo;
    private String second_photo;
    private String third_photo;
    private String ownerPhoneNumber;
    private String createdAt;
    private boolean isAvailable = true;

    private int rentalCount = 0;
    private boolean isFlashSale = false;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;
}