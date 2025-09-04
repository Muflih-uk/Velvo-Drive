package com.velvodrive.repository;

import com.velvodrive.model.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {


    List<Vehicle> findAllByIsAvailableTrue();

    List<Vehicle> findAllByIsFlashSaleTrue();

    List<Vehicle> findAllByOrderByRentalCountDesc();

    List<Vehicle> findByOwnerId(Long ownerId);

}