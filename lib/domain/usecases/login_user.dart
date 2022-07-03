import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../repositories/login_repository.dart';

class LoginUserUsecase {
  LoginRepository repository;

  LoginUserUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> call({
    required String employeeNumber,
    required String pass,
  }) {
    return repository.loginUser(employeeNumber: employeeNumber, pass: pass);
  }
}
