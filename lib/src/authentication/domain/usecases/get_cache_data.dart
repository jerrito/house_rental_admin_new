import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class GetCacheData extends UseCases<Owner, NoParams> {
  final AuthenticationRepository repository;

  GetCacheData({required this.repository});

  @override
  Future<Either<String, Owner>> call(NoParams params) async {
    return await repository.getOwnerCacheData();
  }
}
