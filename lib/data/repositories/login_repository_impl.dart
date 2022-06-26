import 'package:dartz/dartz.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/local_data_source.dart';
import '../models/login_response_model.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl(
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
}
