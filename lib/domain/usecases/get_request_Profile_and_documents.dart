import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/filtered_search.dart';
import 'package:more4u/domain/entities/profile_and_documents.dart';

import '../../core/errors/failures.dart';
import '../entities/benefit_request.dart';
import '../repositories/benefit_repository.dart';

class GetRequestProfileAndDocumentsUsecase {
  BenefitRepository repository;

  GetRequestProfileAndDocumentsUsecase(this.repository);

  Future<Either<Failure, ProfileAndDocuments>> call({
    required int employeeNumber,
    required int requestNumber,

  }) {
    return repository.getRequestProfileAndDocuments(
        employeeNumber: employeeNumber,requestNumber:requestNumber);
  }
}