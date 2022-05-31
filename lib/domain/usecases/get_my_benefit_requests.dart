import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/my_benefit_request.dart';
import 'package:more4u/domain/repositories/benefit_repository.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit.dart';

class GetMyBenefitRequestsUsecase {
  BenefitRepository repository;

  GetMyBenefitRequestsUsecase(this.repository);

  Future<Either<Failure, List<MyBenefitRequest>>> call({
    required int employeeNumber,
    required int benefitId,
  }) {
    return repository.getMyBenefitRequests(
        employeeNumber: employeeNumber, benefitId: benefitId);
  }
}
