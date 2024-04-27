import 'package:dartz/dartz.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/repository/home_repository.dart';

class SendFCMMessage extends UseCases<void, Map<String, dynamic>> {
  final HomeRepository repository;

  SendFCMMessage({required this.repository});
  @override
  Future<Either<String, void>> call(Map<String, dynamic> params) async {
    return await repository.sendFCMMessage(params);
  }
}
