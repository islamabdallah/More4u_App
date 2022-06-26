import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/notification.dart';

import '../entities/participant.dart';
import '../repositories/benefit_repository.dart';
import '../../core/errors/failures.dart';

class GetNotificationsUsecase {
  BenefitRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, List<Notification>>> call({
    required int employeeNumber,
}) {
    return repository.getNotifications(employeeNumber: employeeNumber);
  }
}
