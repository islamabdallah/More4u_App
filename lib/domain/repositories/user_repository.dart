import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../entities/user.dart';
import '../entities/privilege.dart';

abstract class UserRepository {
  Future<Either<Failure,LoginResponse>> loginUser({
    required String employeeNumber,
    required String pass,
  });

  Future<Either<Failure,User>> updateProfilePicture({
    required int employeeNumber,
    required String photo,
  });

  Future<Either<Failure,String>> changePassword({
    required int employeeNumber,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure,List<Privilege>>> getPrivileges();

}
