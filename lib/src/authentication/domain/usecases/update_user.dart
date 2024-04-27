import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class UpdateUser extends UseCases<void, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  UpdateUser({required this.repository});

  @override
  Future<Either<String, void>> call(Map<String, dynamic> params) async {
    return await repository.updateUser(params);
  }
}
