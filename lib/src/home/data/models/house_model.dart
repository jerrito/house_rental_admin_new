
import 'package:house_rental_admin/src/authentication/data/models/owner_model.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';

class HouseDetailModel extends HouseDetail {
  const HouseDetailModel({
      required super.houseName,
      required super.description,
      required super.amount,
      required super.images,
      required super.bedRoomCount,
      required super.bathRoomCount,
      required super.owner,
      required super.isAvailable,
      required super.category,
      required super.houseLocation,

      });

  factory HouseDetailModel.fromJson(Map<String, dynamic>? json) =>
      HouseDetailModel(
        houseName: json?["house_name"],
        description: json?["description"],
        amount: json?["amount"],
        images: List<String>.from(json?["images"].map((e) => e)),
        bedRoomCount: json?["bed_room_count"],
        bathRoomCount: json?["bath_room_count"] as num,
        owner:OwnerModel.fromJson(json?["owner"]),
        isAvailable: json?["is_available"],
        category: json?["category"],     
         houseLocation: HouseLocationModel.fromJson(json?["house_details"]),
      );

  Map<String, dynamic> toMap() {
    return {
      "house_name": houseName,
      "description": description,
      "owner": owner,
      "amount": amount,
      "bed_room_count": bedRoomCount,
      "bath_room_count": bathRoomCount,
      "images": images,
      "category": category,
      "is_available": isAvailable,
      "house_details": houseLocation,
    };
  }
}

class HouseLocationModel extends HouseLocation {
  const HouseLocationModel(
      {required super.formatedAddress, required super.lat, required super.lng});

  factory HouseLocationModel.fromJson(Map<String, dynamic>? json) =>
      HouseLocationModel(
          formatedAddress: json?["formatted_address"],
          lat: json?["lat"],
          lng: json?["lng"]);

  @override
  Map<String, dynamic> toMap() {
    return {
      "formatted_address": formatedAddress,
      "lat": lat,
      "lng": lng,
    };
  }
}
