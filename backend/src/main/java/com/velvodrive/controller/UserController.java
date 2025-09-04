package com.velvodrive.controller;

import com.velvodrive.dto.UserUpdateDTO;
import com.velvodrive.model.User;
import com.velvodrive.model.Vehicle;
import com.velvodrive.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;


    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUserDetails(@AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(userService.getUserDetails(userDetails.getUsername()));
    }

    @PutMapping("/me")
    public ResponseEntity<User> updateCurrentUserDetails(@AuthenticationPrincipal UserDetails userDetails, @RequestBody UserUpdateDTO userUpdateDTO) {
        return ResponseEntity.ok(userService.updateUserDetails(userDetails.getUsername(), userUpdateDTO));
    }

    @GetMapping("/me/vehicles")
    public ResponseEntity<List<Vehicle>> getVehiclesAddedByCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(userService.getVehiclesAddedByUser(userDetails.getUsername()));
    }


    @GetMapping("/me/bookmarks")
    public ResponseEntity<Set<Vehicle>> getCurrentUserBookmarks(@AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(userService.getBookmarkedVehicles(userDetails.getUsername()));
    }

    @PostMapping("/me/bookmarks/{vehicleId}")
    public ResponseEntity<?> addBookmark(@AuthenticationPrincipal UserDetails userDetails, @PathVariable Long vehicleId) {
        userService.addBookmark(userDetails.getUsername(), vehicleId);
        return ResponseEntity.ok("Vehicle bookmarked successfully.");
    }

    @DeleteMapping("/me/bookmarks/{vehicleId}")
    public ResponseEntity<?> removeBookmark(@AuthenticationPrincipal UserDetails userDetails, @PathVariable Long vehicleId) {
        userService.removeBookmark(userDetails.getUsername(), vehicleId);
        return ResponseEntity.ok("Bookmark removed successfully.");
    }
}