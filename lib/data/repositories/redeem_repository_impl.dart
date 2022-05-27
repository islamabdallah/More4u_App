import 'package:dartz/dartz.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:more4u/domain/entities/participant.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/repositories/redeem_repository.dart';
import '../datasources/redeem_remote_data_source.dart';

class RedeemRepositoryImpl extends RedeemRepository {
  final RedeemRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RedeemRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Participant>>> getParticipants() async {
    if (await networkInfo.isConnected) {
      try {
        List<Participant> result = await remoteDataSource.getParticipants();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet Connection'));
    }
  }
}
