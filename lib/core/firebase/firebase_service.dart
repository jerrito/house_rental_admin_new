import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_rental_admin/src/authentication/data/models/owner_model.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';

class FirebaseService {
  final auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  FirebaseService(
      {required this.firebaseFirestore, required this.firebaseAuth});
  final usersRef = FirebaseFirestore.instance
      .collection('houseRentalAdminAccount')
      .withConverter<OwnerModel>(
        fromFirestore: (snapshot, _) => OwnerModel.fromJson(snapshot.data()!),
        toFirestore: (owner, _) => owner.toMap(),
      );
  String idGet = "";

  Future<OwnerModel?> getUser({required String phoneNumber}) async {
    OwnerModel? result;

    return await usersRef
        .where("phone_number", isEqualTo: phoneNumber)
        .get()
        .then((snapshot) {
      var userSnapShot = snapshot.docs;

      OwnerModel? data;
      if (userSnapShot.isNotEmpty) {
        data = userSnapShot.first.data();
        idGet = data.id!;
        idGet = userSnapShot.first.id;
        //data.id=
        // print(data.id);
      }

      // var status = QueryStatus.successful;

      result = data;
      return result;
    });
  }

  Future<DocumentReference<OwnerModel>?> saveUser(
      {required OwnerModel user}) async {
    // UserModel? result;

    //
    return await usersRef.add(user);
  }

  Future<void> updateUser({required Owner owner}) async {
    // print(user.id);

    //
    return await usersRef.doc(owner.id).update(owner.toMap());

    //return result;
  }

  Future<void> phoneSignIn(Map<String, dynamic> params) async {
    await firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: params["phoneNumber"],
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(auth.PhoneAuthCredential authCredential) async {}

  _onVerificationFailed(auth.FirebaseAuthException exception) async {}

  _onCodeSent(String verificationId, int? forceResendingToken) async {}

  _onCodeTimeout(String timeout) async {
    return null;
  }
}
