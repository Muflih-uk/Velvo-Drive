package com.velvodrive.controller;

import com.velvodrive.dto.VehicleDTO;
import com.velvodrive.model.Vehicle;
import com.velvodrive.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;


@RestController
@RequestMapping("/api/vehicles")
public class VehicleController {

    @Autowired
    private VehicleService vehicleService;

    @PostMapping("/add")
    public ResponseEntity<?> addVehicle(@RequestBody VehicleDTO vehicleDto){
        try{
            Vehicle newVehicle = vehicleService.addVehicle(vehicleDto);
            return new ResponseEntity<>(newVehicle, HttpStatus.CREATED);
        } catch (RuntimeException e){
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/available")
    public ResponseEntity<List<Vehicle>> getAvailableVehicles() {
        return ResponseEntity.ok(vehicleService.getAvailableVehicles());
    }

    @PostMapping("/{vehicleId}/rent")
    public ResponseEntity<?> rentVehicle(
            @PathVariable Long vehicleId,
            @RequestParam Long renterId,
            @RequestParam int durationInDays
    ){
        try {
            return ResponseEntity.ok(vehicleService.rentVehicle(vehicleId, renterId, durationInDays));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

}