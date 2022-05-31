import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/my_benefit_request.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';

abstract class BenefitRepository {
  Future<Either<Failure, Benefit>> getBenefitDetails({
    required int benefitId,
  });

  Future<Either<Failure, List<Benefit>>> getMyBenefits({
    required int employeeNumber,
  });

  Future<Either<Failure, List<MyBenefitRequest>>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
  });
}
