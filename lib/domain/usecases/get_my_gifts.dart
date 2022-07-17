import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/benefit_repository.dart';
import '../entities/gift.dart';



class GetMyGiftsUsecase {
  BenefitRepository repository;

  GetMyGiftsUsecase(this.repository);

  Future<Either<Failure, List<Gift>>> call({
    required int employeeNumber,
  }) {
    return repository.getMyGifts(employeeNumber: employeeNumber);
  }
}
