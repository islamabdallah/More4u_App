import 'package:equatable/equatable.dart';

class User extends Equatable {
 final String employeeName;
 final String email;
 final int employeeNumber;
 final String positionName;
 final String departmentName;
 final String birthDate;
 final String joinDate;
 final bool hasRequests;

  const User({required this.employeeName,
    required this.email,
    required this.employeeNumber,
    required this.positionName,
    required this.departmentName,
    required this.birthDate,
    required this.joinDate,
    required this.hasRequests});

  @override
  List<Object?> get props =>
      [employeeName, email, employeeNumber, employeeName, hasRequests];
}
