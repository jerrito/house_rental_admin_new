// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final String? firstName,
      lastName,
      phoneNumber,
      profileURL,
      email,
      password,
      houseGPSAddress,
      townORCity,
      role,
      houseDocument;
  String? id, uid;

  Owner({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profileURL,
    required this.email,
    required this.password,
    required this.houseGPSAddress,
    required this.townORCity,
    required this.role,
    required this.houseDocument,
    required this.id,
    required this.uid,
  });
  //const Owner({});

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phoneNumber,
        profileURL,
        email,
        password,
        houseGPSAddress,
        townORCity,
        role,
        houseDocument,
        id,
        uid
      ];

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
