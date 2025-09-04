package com.velvodrive.service;

import com.velvodrive.dto.UserUpdateDTO;
import com.velvodrive.model.User;
import com.velvodrive.model.Vehicle;
import com.velvodrive.repository.UserRepository;
import com.velvodrive.repository.VehicleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    public User getUserDetails(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
    }

    @Transactional
    public User updateUserDetails(String username, UserUpdateDTO userUpdateDTO) {
        User user = getUserDetails(username);
        user.setEmail(userUpdateDTO.getEmail());
        return userRepository.save(user);
    }

    public List<Vehicle> getVehiclesAddedByUser(String username) {
        User user = getUserDetails(username);
        return vehicleRepository.findByOwnerId(user.getId());
    }


    @Transactional
    public void addBookmark(String username, Long vehicleId) {
        User user = getUserDetails(username);
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new RuntimeException("Vehicle not found with id: " + vehicleId));
        user.getBookmarkedVehicles().add(vehicle);
        userRepository.save(user);
    }

    @Transactional
    public void removeBookmark(String username, Long vehicleId) {
        User user = getUserDetails(username);
        Vehicle vehicle = vehicleRepository.findById(vehicleId)
                .orElseThrow(() -> new RuntimeException("Vehicle not found with id: " + vehicleId));
        user.getBookmarkedVehicles().remove(vehicle);
        userRepository.save(user);
    }

    public Set<Vehicle> getBookmarkedVehicles(String username) {
        User user = getUserDetails(username);
        return user.getBookmarkedVehicles();
    }
}