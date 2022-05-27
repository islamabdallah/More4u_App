import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/participant.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/benefit.dart';

abstract class RedeemRepository {
  Future<Either<Failure, List<Participant>>> getParticipants();
}
