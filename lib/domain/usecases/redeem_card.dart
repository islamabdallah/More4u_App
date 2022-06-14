import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/benefit_request.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../repositories/benefit_repository.dart';

class RedeemCardUsecase {
  BenefitRepository repository;

  RedeemCardUsecase(this.repository);

  Future<Either<Failure, Unit>> call({required BenefitRequest request}) {
    return repository.redeemCard(request: request);
  }
}

// class RedeemRequest extends Equatable {
//   final String? message;
//   final String? groupName;
//
//   final List<int>? participants;
//   final int? sendTo;
//   final int benefitId;
//   final int employeeNumber;
//   final String from;
//   final String to;
//
//   const RedeemRequest(
//       {this.message,
//       this.groupName,
//       this.participants,
//       this.sendTo,
//       required this.benefitId,
//       required this.employeeNumber,
//       required this.from,
//       required this.to});
//
//   @override
//   List<Object?> get props => [
//         benefitId,
//         employeeNumber,
//         message,
//         groupName,
//         participants,
//         sendTo,
//         from,
//         to,
//       ];
//
// }
