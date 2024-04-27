import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';

class AddMultipleImage extends UseCases<List<PlatformFile>,NoParams> {
  final HomeRepository repository;

  AddMultipleImage({required this.repository});

  @override
  Future<Either<String, List<PlatformFile>>> call(NoParams params) async {
    return await repository.addMultipleImage();
  }
}
