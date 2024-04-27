import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:house_rental_admin/core/firebase/firebase_service.dart';
import 'package:house_rental_admin/core/network_info.dart/network_info.dart';
import 'package:house_rental_admin/src/authentication/data/datasources/local_ds.dart';
import 'package:house_rental_admin/src/authentication/data/datasources/remote_ds.dart';
import 'package:house_rental_admin/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/add_id.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/check_phone_number.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/get_user.dart';

import 'package:house_rental_admin/src/authentication/domain/usecases/signin.dart';

import 'package:house_rental_admin/src/authentication/domain/usecases/get_cache_data.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/phone_number_login.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/signup.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_location.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_place_by_latlng.dart';
import 'package:house_rental_admin/src/home/domain/usecases/place_search.dart';
import 'package:house_rental_admin/src/home/domain/usecases/send_fcm_message.dart';
import 'package:house_rental_admin/src/home/domain/usecases/update_house.dart';
import 'package:house_rental_admin/src/home/domain/usecases/upload_multiple_images.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/verify_number.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/home/data/data_source/localds.dart';
import 'package:house_rental_admin/src/home/data/data_source/remote_ds.dart';
import 'package:house_rental_admin/src/home/data/repository/home_repository_impl.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_house.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_multiple_image.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_all_houses.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_camera.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_gallery.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/up_load_image.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/authentication/domain/usecases/update_user.dart';
import 'src/authentication/domain/usecases/verify_otp.dart';

final locator = GetIt.instance;

Future<void> initDependencies() async {
  //bloc

  locator.registerFactory(
    () => AuthenticationBloc(
      getProfileCamera: locator(),
      getProfileGallery: locator(),
      firebaseAuth: locator(),
      signup: locator(),
      verifyNumber: locator(),
      verifyOTP: locator(),
      getCacheData: locator(),
      signin: locator(),
      firebaseService: locator(),
      updateUser: locator(),
      addId: locator(),
      verifyPhoneNumberLogin: locator(),
      upLoadImage: locator(),
      checkPhoneNumberChange: locator(),
      getUser: locator(),
    ),
  );

  locator.registerFactory(
    () => HomeBloc(
      getProfileCamera: locator(),
      getProfileGallery: locator(),
      addMultipleImage: locator(),
      addHouse: locator(),
      getAllHouses: locator(),
      uploadMultipleImages: locator(),
      updateHouse: locator(),
      placeSearch: locator(),
      getPlaceByLatLng: locator(),
      addLocation: locator(),
      sendFCMMessage: locator(),
    ),
  );

  //usecases

  locator.registerLazySingleton(() => SendFCMMessage(
        repository: locator(),
      ));

  locator.registerLazySingleton(() => GetUser(
        repository: locator(),
      ));

  locator.registerLazySingleton(() => CheckPhoneNumberChange(
        repository: locator(),
      ));
  locator.registerLazySingleton(
    () => AddLocation(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetPlaceByLatLng(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => SearchPlace(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => UpdateHouse(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetAllHouses(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UploadMultipleImages(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => AddHouse(
      repository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetProfileCamera(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => AddMultipleImage(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetProfileGallery(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UpLoadImage(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => FirebaseAuth.instance,
  );

  locator.registerLazySingleton(
    () => Signup(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => AddId(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => Signin(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => VerifyPhoneNumber(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => VerifyPhoneNumberLogin(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => VerifyOTP(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => GetCacheData(
      repository: locator(),
    ),
  );

  locator.registerLazySingleton(
    () => UpdateUser(
      repository: locator(),
    ),
  );

  //repository

  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      firebaseService: locator(),
      networkInfo: locator(),
      remoteDatasource: locator(),
      localDatasource: locator(),
    ),
  );

  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      networkInfo: locator(),
      homeLocalDatasource: locator(),
      homeRemoteDataSource: locator(),
    ),
  );
  //remoteds
  locator.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );

  locator.registerLazySingleton(
    () => FirebaseService(
      firebaseFirestore: locator(),
      firebaseAuth: locator(),
    ),
  );

  locator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton(
    () => DataConnectionChecker(),
  );

  locator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: locator(),
    ),
  );

  final sharedPreference = await SharedPreferences.getInstance();
  locator.registerLazySingleton(
    () => sharedPreference,
  );

  locator.registerLazySingleton<AuthenticationLocalDatasource>(
    () => AuhenticationLocalDataSourceImpl(
      sharedPreferences: locator(),
    ),
  );

  locator.registerLazySingleton<HomeLocalDatasource>(
    () => HomeLocalDatasourceImpl(),
  );

  locator.registerLazySingleton<AuthenticationRemoteDatasource>(
    () => AuthenticationRemoteDatasourceImpl(
      localDatasource: locator(),
      firebaseAuth: locator(),
    ),
  );
}
