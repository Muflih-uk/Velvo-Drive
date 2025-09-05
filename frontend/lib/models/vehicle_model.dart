import 'dart:convert';

String vehicleToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
    final String name;
    final String description;
    final String model;
    final double pricePerDay;
    final String mainPhoto;
    final String secondPhoto;
    final String? thirdPhoto;
    final String ownerPhoneNumber;
    final String createdAt;

    Vehicle({
        required this.name,
        required this.description,
        required this.model,
        required this.pricePerDay,
        required this.mainPhoto,
        required this.secondPhoto,
        this.thirdPhoto,
        required this.ownerPhoneNumber,
        required this.createdAt,
    });

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "model": model,
        "pricePerDay": pricePerDay,
        "main_photo": mainPhoto,
        "second_photo": secondPhoto,
        "third_photo": thirdPhoto ?? "", // Ensure it's an empty string if null
        "ownerPhoneNumber": ownerPhoneNumber,
        "createdAt": createdAt,
    };
}