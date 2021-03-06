import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit_request.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';
import '../entities/filtered_search.dart';
import '../entities/gift.dart';
import '../entities/manage_requests_response.dart';
import '../entities/notification.dart';
import '../entities/profile_and_documents.dart';

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
    int? requestNumber,
  });

  Future<Either<Failure, List<Gift>>> getMyGifts({
    required int employeeNumber,
    required int requestNumber,
  });


  Future<Either<Failure, String>> cancelRequest({
    required int employeeNumber,
    required int benefitId,
    required int requestNumber,
  });

  Future<Either<Failure, String>> addResponse({
    required int employeeNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
  });

  Future<Either<Failure, ManageRequestsResponse>> getBenefitsToManage({
    required int employeeNumber,
    FilteredSearch? search,
    int? requestNumber,
  });

  Future<Either<Failure, ProfileAndDocuments>> getRequestProfileAndDocuments({
    required int employeeNumber,
    required int requestNumber,
  });


  Future<Either<Failure, Unit>> redeemCard({
    required BenefitRequest request,
  });

  Future<Either<Failure, List<Notification>>> getNotifications({
    required int employeeNumber,
  });
}
