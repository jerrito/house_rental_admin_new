import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class AddId extends UseCases<void, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  AddId({required this.repository});
  @override
  Future<Either<String, void>> call(
      Map<String, dynamic> params) async {
    return await repository.addId(params);
  }
}
