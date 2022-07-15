import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/privilege.dart';
import 'package:more4u/domain/entities/user.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/local_data_source.dart';
import '../models/login_response_model.dart';
import '../models/privilege_model.dart';

class UserRepositoryImpl extends UserRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, LoginResponse>> loginUser(
      {required String employeeNumber, required String pass}) async {
    if (await networkInfo.isConnected) {
      try {
        LoginResponseModel result = await remoteDataSource.loginUser(
            employeeNumber: employeeNumber, pass: pass);
        localDataSource.cacheUser(employeeNumber, pass);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfilePicture(
      {required int employeeNumber, required String photo}) async {
    if (await networkInfo.isConnected) {
      try {
        User result = await remoteDataSource.updateProfilePicture(
            employeeNumber: employeeNumber, photo: photo);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword(
      {required int employeeNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    if (await networkInfo.isConnected) {
      try {
        String result = await remoteDataSource.changePassword(
            employeeNumber: employeeNumber,
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Privilege>>> getPrivileges() async {
    if (await networkInfo.isConnected) {
      try {
        List<Privilege> privileges = await remoteDataSource.getPrivileges();
        return Right(privileges);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }
}
