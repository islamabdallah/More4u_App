import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit_request.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';
import '../entities/filtered_search.dart';
import '../entities/notification.dart';

abstract class BenefitRepository {
  Future<Either<Failure, Benefit>> getBenefitDetails({
    required int benefitId,
  });

  Future<Either<Failure, List<Benefit>>> getMyBenefits({
    required int employeeNumber,
  });

  Future<Either<Failure, List<BenefitRequest>>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
  });

  Future<Either<Failure, String>> cancelRequest({
    required int employeeNumber,
    required int benefitId,
    required int requestNumber,
  });

  Future<Either<Failure, List<BenefitRequest>>> getBenefitsToManage({
    required int employeeNumber,
    FilteredSearch? search,
  });

  Future<Either<Failure, Unit>> redeemCard({
    required BenefitRequest request,
  });

  Future<Either<Failure, List<Notification>>> getNotifications({
    required int employeeNumber,
  });
}
