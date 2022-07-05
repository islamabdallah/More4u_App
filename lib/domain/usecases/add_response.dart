import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class AddRequestResponseUsecase {
  BenefitRepository repository;

  AddRequestResponseUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int employeeNumber,
    required int status,
    required int requestNumber,
    required String message,
  }) {
    return repository.addResponse(
      employeeNumber: employeeNumber,
      status: status,
      requestNumber: requestNumber,
      message: message,
    );
  }
}
