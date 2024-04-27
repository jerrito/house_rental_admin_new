// ignore_for_file: must_be_immutable

import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';

class OwnerModel extends Owner {
  OwnerModel({
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.profileURL,
    required super.email,
    required super.password,
    required super.houseGPSAddress,
    required super.townORCity,
    required super.role,
    required super.houseDocument,
    required super.id,
    required super.uid,
  });

  factory OwnerModel.fromJson(Map<String, dynamic>? json) =>
   OwnerModel(
        firstName: json?["first_name"],
        lastName: json?["last_name"],
        phoneNumber: json?["phone_number"],
        profileURL: json?["profile_URL"],
        email: json?["email"],
        password: json?["password"],
        houseGPSAddress: json?["house_GPS_address"],
        townORCity: json?["town_or_city"],
        role: json?["role"],
        houseDocument: json?["house_document"],
        id: json?["id"],
        uid: json?["uid"],
      );

      @override
        Map<String,dynamic> toMap()=>
      {
        "first_name":firstName,
        "last_name":lastName,
        "phone_number":phoneNumber,
        "profile_URL":profileURL,
        "email":email,
        "password":password,
        "house_GPS_address":houseGPSAddress,
        "town_or_city":townORCity,
        "role":role,
        "house_document":houseDocument,
        "id":id,
        "uid":uid
      };
}
