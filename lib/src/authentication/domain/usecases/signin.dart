import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class Signin extends UseCases<Owner?,Map<String,dynamic>> {
  final AuthenticationRepository repository;

  Signin({required this.repository});
  
  @override
  Future<Either<String, Owner?>> call(Map<String, dynamic> params) async{
    return await repository.signIn(params);
  }
  
  }
