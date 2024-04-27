import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';

class UploadMultipleImages extends UseCases<List<String>, Map<String,dynamic>> {
  final HomeRepository repository;

  UploadMultipleImages({required this.repository});

  @override
  Future<Either<String, List<String>>> call(Map<String,dynamic> params) async {
    return await repository.upLoadMultipleImages( params);
  }
}
