package com.velvodrive.controller;

import com.velvodrive.model.Vehicle;
import com.velvodrive.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;


@RestController
@RequestMapping("/api/featured")
public class FeaturedController {

    @Autowired
    private VehicleService vehicleService;

    @GetMapping("/popular")
    public ResponseEntity<List<Vehicle>> getPopularVehicle(){
        return ResponseEntity.ok(vehicleService.getPopularVehicles());
    }

    @GetMapping("/flash-sales")
    public ResponseEntity<List<Vehicle>> getFlashSaleVehicles(){
        return ResponseEntity.ok(vehicleService.getFlashSaleVehicles());
    }

    @GetMapping("/bestseller")
    public ResponseEntity<List<Vehicle>> getBestSeller(){
        return ResponseEntity.ok(vehicleService.getPopularVehicles());
    }
}