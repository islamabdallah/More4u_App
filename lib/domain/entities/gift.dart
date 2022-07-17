import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final int? requestNumber;
  final int? employeeNumber;
  final String? employeeName;
  final String? benefitName;
  final String? benefitCard;
  final String? employeeDepartment;
  final String? employeeEmail;
  final String? date;

  const Gift({
    this.requestNumber,
    this.employeeNumber,
    this.employeeName,
    this.benefitName,
    this.benefitCard,
    this.employeeDepartment,
    this.employeeEmail,
    this.date,
  });

  @override
  List<Object?> get props => [];
}
