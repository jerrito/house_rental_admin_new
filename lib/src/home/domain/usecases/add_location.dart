import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';

class AddLocation extends UseCases<HouseLocation, Map<String, dynamic>> {
  final HomeRepository repository;

  AddLocation({required this.repository});
  @override
  Future<Either<String, HouseLocation>> call(
      Map<String, dynamic> params) async {
    return await repository.addLocation(params);
  }
}
