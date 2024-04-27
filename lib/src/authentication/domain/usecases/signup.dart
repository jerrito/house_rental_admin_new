import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class Signup extends UseCases<DocumentReference<Owner>?, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  Signup({required this.repository});

  @override
  Future<Either<String, DocumentReference<Owner>?>> call(
      Map<String, dynamic> params) {
    return repository.signUp(params);
  }
}
