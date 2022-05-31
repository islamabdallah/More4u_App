import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../repositories/benefit_repository.dart';

class RedeemCardUsecase {
  BenefitRepository repository;

  RedeemCardUsecase(this.repository);
//todo add call method
// Future<Either<Failure, LoginResponse>> call({
//   required String username,
//   required String pass,
// }) {
//   return repository.loginUser(username: username, pass: pass);
// }
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
