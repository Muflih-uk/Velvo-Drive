package com.velvodrive.controller;

import com.velvodrive.dto.VehicleDTO;
import com.velvodrive.model.Vehicle;
import com.velvodrive.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.nio.file.AccessDeniedException;
import java.util.List;


@RestController
@RequestMapping("/api/vehicles")
public class VehicleController {

    @Autowired
    private VehicleService vehicleService;

    @PostMapping("/add")
    public ResponseEntity<?> addVehicle(@RequestBody VehicleDTO vehicleDto,
                                        @AuthenticationPrincipal UserDetails userDetails){
        try{
            String ownerUsername = userDetails.getUsername();
            Vehicle newVehicle = vehicleService.addVehicle(vehicleDto, ownerUsername);
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

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteVehicle(@PathVariable Long id, @AuthenticationPrincipal UserDetails userDetails) {
        try {
            // Get the username of the currently logged-in user
            String username = userDetails.getUsername();
            vehicleService.deleteVehicle(id, username);
            return ResponseEntity.ok("Vehicle with ID " + id + " deleted successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (AccessDeniedException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.FORBIDDEN);
        }
    }

}