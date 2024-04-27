import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:house_rental_admin/src/home/domain/entities/place_search.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/house.dart';

abstract class HomeRepository {
  Future<Either<String, XFile>> getProfileImageGallery();
  Future<Either<String, XFile>> getProfileImageCamera();
  Future<Either<String, List<PlatformFile>>> addMultipleImage();
  Future<Either<String, DocumentReference<Map<String, dynamic>>?>> addHouse(
      Map<String, dynamic> params);

  Future<Either<String, QuerySnapshot<HouseDetail>>> getAllHouses(
      Map<String, dynamic> params);

  Future<Either<String, List<String>>> upLoadMultipleImages(
      Map<String, dynamic> params);

  Future<Either<String, void>> updateHouse(Map<String, dynamic> params);

  Future<Either<String, PlaceSearch>> placeSearch(Map<String, dynamic> params);
  Future<Either<String, PlaceSearch>> getPlaceByLatLng(
      Map<String, dynamic> params);
  Future<Either<String, HouseLocation>> addLocation(
      Map<String, dynamic> params);

  Future<Either<String,void>> sendFCMMessage(Map<String, dynamic> params);
}
