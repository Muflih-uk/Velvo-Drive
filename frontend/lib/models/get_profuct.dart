class VehicleGetModel {
  final int id;
  final String name;
  final String description;
  final String model;
  final double pricePerDay;
  final String mainPhoto;
  final String secondPhoto;
  final String thirdPhoto;
  final String ownerPhoneNumber;
  final String createdAt;
  final int rentalCount;
  final Owner owner;
  final bool flashSale;
  final bool available;

  VehicleGetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.model,
    required this.pricePerDay,
    required this.mainPhoto,
    required this.secondPhoto,
    required this.thirdPhoto,
    required this.ownerPhoneNumber,
    required this.createdAt,
    required this.rentalCount,
    required this.owner,
    required this.flashSale,
    required this.available,
  });

  factory VehicleGetModel.fromJson(Map<String, dynamic> json) {
    return VehicleGetModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      model: json['model'],
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      mainPhoto: json['main_photo'],
      secondPhoto: json['second_photo'],
      thirdPhoto: json['third_photo'],
      ownerPhoneNumber: json['ownerPhoneNumber'],
      createdAt: json['createdAt'],
      rentalCount: json['rentalCount'],
      owner: Owner.fromJson(json['owner']),
      flashSale: json['flashSale'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "model": model,
      "pricePerDay": pricePerDay,
      "main_photo": mainPhoto,
      "second_photo": secondPhoto,
      "third_photo": thirdPhoto,
      "ownerPhoneNumber": ownerPhoneNumber,
      "createdAt": createdAt,
      "rentalCount": rentalCount,
      "owner": owner.toJson(),
      "flashSale": flashSale,
      "available": available,
    };
  }
}

class Owner {
  final int id;
  final String username;
  final String email;
  final String? photo;
  final String? aboutYou;
  final String? number;

  Owner({
    required this.id,
    required this.username,
    required this.email,
    this.photo,
    this.aboutYou,
    this.number,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      photo: json['photo'],
      aboutYou: json['aboutYou'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "photo": photo,
      "aboutYou": aboutYou,
      "number": number,
    };
  }
}
