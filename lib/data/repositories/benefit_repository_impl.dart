import 'package:dartz/dartz.dart';
import 'package:more4u/data/datasources/benefit_remote_data_source.dart';
import 'package:more4u/data/models/benefit_request_model.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/entities/filtered_search.dart';

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

  @override
  Future<Either<Failure, List<Benefit>>> getMyBenefits(
      {required int employeeNumber}) async {
    if (await networkInfo.isConnected) {
      try {
        List<Benefit> result = await remoteDataSource.getMyBenefits(
            employeeNumber: employeeNumber);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<BenefitRequest>>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        List<BenefitRequest> result =
        await remoteDataSource.getMyBenefitRequests(
            employeeNumber: employeeNumber, benefitId: benefitId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<BenefitRequest>>> getBenefitsToManage(
      {required int employeeNumber, FilteredSearch? search}) async {
    if (await networkInfo.isConnected) {
      try {
        List<BenefitRequest> result =
        await remoteDataSource.getBenefitsToManage(
          employeeNumber: employeeNumber,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> redeemCard(
      {required BenefitRequest request}) async {
    if (await networkInfo.isConnected) {
      try {
        BenefitRequestModel myBenefitRequestModel = BenefitRequestModel
            .fromEntity(request);

        await remoteDataSource.redeemCard(requestModel: myBenefitRequestModel);

    return const Right(unit);
    } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
    }
    } else {
    return const Left(ConnectionFailure('No internet Connection'));
    }
  }
}
