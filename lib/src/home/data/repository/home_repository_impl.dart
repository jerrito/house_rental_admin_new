import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:house_rental_admin/core/network_info.dart/network_info.dart';
import 'package:house_rental_admin/src/home/data/data_source/localds.dart';
import 'package:house_rental_admin/src/home/data/data_source/remote_ds.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';
import 'package:house_rental_admin/src/home/domain/entities/place_search.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';
import 'package:image_picker/image_picker.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDatasource homeLocalDatasource;
  final NetworkInfo networkInfo;
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({
    required this.networkInfo,
    required this.homeLocalDatasource,
    required this.homeRemoteDataSource,
  });
  @override
  Future<Either<String, XFile>> getProfileImageGallery() async {
    try {
      final response = await homeLocalDatasource.getProfileImageGallery();

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, XFile>> getProfileImageCamera() async {
    try {
      final response = await homeLocalDatasource.getProfileImageCamera();

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<PlatformFile>>> addMultipleImage() async {
    try {
      final response = await homeLocalDatasource.addMultipleImage();
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, DocumentReference<Map<String, dynamic>>?>> addHouse(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.addHouse(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, QuerySnapshot<HouseDetail>>> getAllHouses(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.getAllHouses(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, List<String>>> upLoadMultipleImages(
      Map<String, dynamic> params) async {
    try {
      final response = await homeRemoteDataSource.upLoadMultipleImages(params);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateHouse(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.updateHouse(params);

        return Right(response);
      } catch (e) {
        return Left(
          e.toString(),
        );
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, PlaceSearch>> placeSearch(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.placeSearch(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, PlaceSearch>> getPlaceByLatLng(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.getPlaceByLatLng(params);

        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }

  @override
  Future<Either<String, HouseLocation>> addLocation(
      Map<String, dynamic> params) async {
    try {
      final response = await homeLocalDatasource.addLocation(params);

      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> sendFCMMessage(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await homeRemoteDataSource.sendFCMMessage(params);
        return Right(response);
      } catch (e) {
        return Left(e.toString());
      }
    } else {
      return Left(networkInfo.noNetworkMessage);
    }
  }
}
