import 'package:equatable/equatable.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';

class HouseDetail extends Equatable {
  final String? houseName, description, category;
  final num? amount, bedRoomCount, bathRoomCount;
  final bool? isAvailable;
  final HouseLocation? houseLocation;
  final List<String>? images;
  final Owner? owner;
  const HouseDetail({
    required this.category,
    required this.owner,
    required this.houseName,
    required this.description,
    required this.amount,
    required this.images,
    required this.bedRoomCount,
    required this.isAvailable,
    required this.bathRoomCount,
    required this.houseLocation,
  });

  @override
  List<Object?> get props => [
        houseName,
        description,
        owner,
        amount,
        bedRoomCount,
        bathRoomCount,
        images,
        isAvailable,
        houseLocation,
        category
      ];
}

class HouseLocation extends Equatable {
  final String? formatedAddress;
  final num? lat, lng;

  const HouseLocation(
      {required this.formatedAddress, required this.lat, required this.lng});

  @override
  List<Object?> get props => [formatedAddress, lat, lng];

Map<String,dynamic>  toMap()=>
  {
    "lat":lat,
    "lng":lng,
    "format_address":formatedAddress,
  };
}
