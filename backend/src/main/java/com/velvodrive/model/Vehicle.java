package com.velvodrive.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String model;
    private double pricePerDay;
    private String photoUrl;
    private String ownerPhoneNumber;
    private boolean isAvailable = true;

    private int rentalCount = 0;
    private boolean isFlashSale = false;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;
}