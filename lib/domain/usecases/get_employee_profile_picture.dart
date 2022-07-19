import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/user_repository.dart';


class GetEmployeeProfilePictureUsecase {
  UserRepository repository;

  GetEmployeeProfilePictureUsecase(this.repository);

  Future<Either<Failure, String>> call({
    required int employeeNumber,
  }) {
    return repository.getEmployeeProfilePicture(
      employeeNumber: employeeNumber,
    );
  }
}
