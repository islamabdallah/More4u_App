import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';

abstract class UserRepository {
  Future<Either<Failure,LoginResponse>> loginUser({
    required String employeeNumber,
    required String pass,
  });
}
