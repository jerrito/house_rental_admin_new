import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:house_rental_admin/src/authentication/data/models/owner_model.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationLocalDatasource {
  Future cacheUserData(Owner user);
  Future<OwnerModel> getUserCachedData();
  Future<String> upLoadImage(Map<String, dynamic> params);
}

class AuhenticationLocalDataSourceImpl
    implements AuthenticationLocalDatasource {
  final SharedPreferences sharedPreferences;
  final String cacheKey = "userCacheKey";

  AuhenticationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future cacheUserData(Owner owner) async {
    final jsonString = jsonEncode(owner.toMap());

    return sharedPreferences.setString(cacheKey, jsonString);
  }

  @override
  Future<OwnerModel> getUserCachedData() async {
    final jsonString = sharedPreferences.getString(cacheKey);

    if (jsonString == null) {
      throw Exception("No user cache data");
    }
    return OwnerModel.fromJson(json.decode(jsonString));
  }

  @override
  Future<String> upLoadImage(Map<String, dynamic> params) async {
    //Upload file
    final upLoadPath = FirebaseStorage.instance.ref().child(
          params["phone_number"],
        );

    final upLoadTask = upLoadPath.child(params["path"]).putFile(File(params["path"]));

    String? returnURL;
    await upLoadTask.whenComplete(
      () => upLoadPath.child(params["path"]).getDownloadURL().then((value) => returnURL = value),
    );

    return returnURL!;
  }

  
}
