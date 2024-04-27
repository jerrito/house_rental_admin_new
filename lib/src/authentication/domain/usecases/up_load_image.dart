import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/repositories/authentication_repository.dart';

class UpLoadImage extends UseCases<String, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  UpLoadImage({required this.repository});

  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async {
    return await repository.upLoadImage(params);
  }
}
