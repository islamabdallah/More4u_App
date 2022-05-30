import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';

abstract class BenefitRepository {
  Future<Either<Failure, Benefit>> getBenefitDetails({
    required int benefitId,
  });

  Future<Either<Failure, List<Benefit>>> getMyBenefits({
    required int employeeNumber,
  });
}
