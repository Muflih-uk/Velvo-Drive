package com.velvodrive.service;

import com.velvodrive.dto.VehicleDTO;
import com.velvodrive.model.Rental;
import com.velvodrive.model.User;
import com.velvodrive.model.Vehicle;
import com.velvodrive.repository.RentalRepository;
import com.velvodrive.repository.UserRepository;
import com.velvodrive.repository.VehicleRepository;
import jakarta.transaction.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.util.List;

@Service
public class VehicleService {

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RentalRepository rentalRepository;

    @Transactional
    public Vehicle addVehicle(VehicleDTO vehicleDTO, String ownerUsername){
        User owner = userRepository.findByUsername(ownerUsername)
                .orElseThrow(() -> new RuntimeException("Authenticated user not found: " + ownerUsername));


        Vehicle newVehicle = new Vehicle();
        newVehicle.setOwner(owner);
        newVehicle.setName(vehicleDTO.getName());
        newVehicle.setDescription(vehicleDTO.getDescription());
        newVehicle.setModel(vehicleDTO.getModel());
        newVehicle.setPricePerDay(vehicleDTO.getPricePerDay());
        newVehicle.setOwnerPhoneNumber(vehicleDTO.getOwnerPhoneNumber());
        newVehicle.setMain_photo(vehicleDTO.getMain_photo());
        newVehicle.setSecond_photo(vehicleDTO.getSecond_photo());
        newVehicle.setThird_photo(vehicleDTO.getThird_photo());
        newVehicle.setCreatedAt(vehicleDTO.getCreatedAt());
        newVehicle.setAvailable(true);

        return vehicleRepository.save(newVehicle);
    }

    @Transactional
    public Rental rentVehicle(Long vehicleId, Long renterId, int durationInDays) {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(()->new RuntimeException("Vehicle not found"));

        if (!vehicle.isAvailable()) {
            throw new RuntimeException("Vehicle is not available for rent.");
        }
        User renter = userRepository.findById(renterId)
                .orElseThrow(() -> new RuntimeException("Renter not found"));

        vehicle.setAvailable(false);
        vehicle.setRentalCount(vehicle.getRentalCount() + 1);
        vehicleRepository.save(vehicle);

        Rental rental = new Rental();
        rental.setVehicle(vehicle);
        rental.setRenter(renter);
        rental.setStartDate(LocalDate.now());
        rental.setEndDate(LocalDate.now().plusDays(durationInDays));

        return rentalRepository.save(rental);

    }

    @Transactional
    public void deleteVehicle(Long vehicleId, String username) throws AccessDeniedException {
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new RuntimeException("Vehicle not found with id: " + vehicleId));

        if (!vehicle.getOwner().getUsername().equals(username)) {
            throw new AccessDeniedException("You are not authorized to delete this vehicle.");
        }

        if (rentalRepository.existsByVehicleId(vehicleId)) {
            throw new RuntimeException("Cannot delete vehicle with existing rental history. Consider marking it as unavailable instead.");
        }

        vehicleRepository.delete(vehicle);
    }

    public List<Vehicle> getAvailableVehicles() {
        return vehicleRepository.findAllByIsAvailableTrue();
    }

    public List<Vehicle> getPopularVehicles() {
        return vehicleRepository.findAllByOrderByRentalCountDesc();
    }

    public List<Vehicle> getFlashSaleVehicles() {
        return vehicleRepository.findAllByIsFlashSaleTrue();
    }
}