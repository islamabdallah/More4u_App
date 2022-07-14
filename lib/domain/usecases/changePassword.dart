import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class ChangePasswordUsecase {
  UserRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<Either<Failure, String>> call(
      {required int employeeNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) {
    return repository.changePassword(
        employeeNumber: employeeNumber,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
  }
}
