import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/entities/place_search.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';

class SearchPlace extends UseCases<PlaceSearch, Map<String, dynamic>> {
  final HomeRepository repository;

  SearchPlace({required this.repository});
  @override
  Future<Either<String, PlaceSearch>> call(params) async{
    return await  repository.placeSearch(params);
  }
}
