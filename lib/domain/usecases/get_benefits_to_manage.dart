import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/filtered_search.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit_request.dart';
import '../repositories/benefit_repository.dart';

class GetBenefitsToManageUsecase {
  BenefitRepository repository;

  GetBenefitsToManageUsecase(this.repository);

  Future<Either<Failure, List<BenefitRequest>>> call({
    required int employeeNumber,

    FilteredSearch? search,

  }) {
    return repository.getBenefitsToManage(
        employeeNumber: employeeNumber, search: search);
  }
}