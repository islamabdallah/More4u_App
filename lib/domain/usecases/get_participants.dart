import 'package:dartz/dartz.dart';

import '../entities/participant.dart';
import '../repositories/redeem_repository.dart';
import '../../core/errors/failures.dart';

class GetParticipantsUsecase {
  RedeemRepository repository;

  GetParticipantsUsecase(this.repository);

  Future<Either<Failure, List<Participant>>> call(  {required int employeeNumber,
    required int benefitId,
    required bool isGift}) {
    return repository.getParticipants(
      employeeNumber: employeeNumber,
      benefitId: benefitId,
      isGift: isGift,
    );
  }
}
