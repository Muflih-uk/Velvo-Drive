package com.velvodrive.repository;

import com.velvodrive.model.Rental;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RentalRepository extends JpaRepository<Rental, Long> {

    List<Rental> findByRenterId(Long renterId);

    List<Rental> findByVehicleId(Long vehicleId);
}