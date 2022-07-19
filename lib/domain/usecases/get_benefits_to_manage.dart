import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/filtered_search.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit_request.dart';
import '../entities/manage_requests_response.dart';
import '../repositories/benefit_repository.dart';

class GetBenefitsToManageUsecase {
  BenefitRepository repository;

  GetBenefitsToManageUsecase(this.repository);

  Future<Either<Failure, ManageRequestsResponse>> call({
    required int employeeNumber,

    FilteredSearch? search,
    int? requestNumber,

  }) {
    return repository.getBenefitsToManage(
        employeeNumber: employeeNumber, search: search,requestNumber:requestNumber);
  }
}