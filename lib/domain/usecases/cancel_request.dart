import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';

class CancelRequestsUsecase {
  BenefitRepository repository;

  CancelRequestsUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int employeeNumber,
    required int benefitId,
    required int requestNumber,
  }) {
    return repository.cancelRequest(
        employeeNumber: employeeNumber,
        benefitId: benefitId,
        requestNumber: requestNumber);
  }
}
