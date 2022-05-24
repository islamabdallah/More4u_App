import 'package:dartz/dartz.dart';
import 'package:more4u/data/datasources/benefit_remote_data_source.dart';
import 'package:more4u/domain/entities/benefit.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/repositories/benefit_repository.dart';

class BenefitRepositoryImpl extends BenefitRepository {
  final BenefitRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BenefitRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, Benefit>> getBenefitDetails(
      {required int benefitId}) async {
    if (await networkInfo.isConnected) {
      try {
        Benefit result =
            await remoteDataSource.getBenefitDetails(benefitId: benefitId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }
}
