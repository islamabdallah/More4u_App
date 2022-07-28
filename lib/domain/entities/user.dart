import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? employeeName;
  final String? email;
  final int employeeNumber;
  final String? positionName;
  final String? departmentName;
  final String birthDate;
  final String joinDate;
  final String? gender;
  final String? maritalStatus;
  final String? company;
  final String? nationality;
  final String? phoneNumber;
  final String? address;
  final String? collar;
  final int? sapNumber;
  final String? id;
  final String? supervisorName;
  final String? profilePicture;
  final String? workDuration;
  final bool? hasRequests;
  final int? pendingRequestsCount;
  final bool? isTheGroupCreator;
  final bool? isAdmin;
  final bool? hasRoles;


  const User({
    this.employeeName,
    this.email,
    required this.employeeNumber,
    this.positionName,
    this.departmentName,
    required this.birthDate,
    required this.joinDate,
    this.gender,
    this.maritalStatus,
    this.company,
    this.nationality,
    this.phoneNumber,
    this.address,
    this.collar,
    this.sapNumber,
    this.id,
    this.supervisorName,
    this.profilePicture,
    this.workDuration,
    this.hasRequests,
    this.pendingRequestsCount,
    this.isTheGroupCreator,
    this.isAdmin,
    this.hasRoles,
  });

  @override
  List<Object?> get props => [
        employeeName,
        email,
        employeeNumber,
        positionName,
        departmentName,
        birthDate,
        joinDate,
        gender,
        maritalStatus,
        company,
        nationality,
        phoneNumber,
        address,
        collar,
        sapNumber,
        id,
        supervisorName,
        profilePicture,
        workDuration,
        hasRequests,
        pendingRequestsCount,
        isTheGroupCreator,
        isAdmin,
    hasRoles,
      ];

// String get genderString {
//   switch (gender) {
//     case 1:
//       return 'Male';
//     case 2:
//       return 'Female';
//     default:
//       return 'Any';
//   }
// }
//
// String get maritalStatusString {
//   switch (gender) {
//     case 1:
//       return 'Single';
//     case 2:
//       return 'Married';
//     case 3:
//       return 'Divorced';
//     default:
//       return 'Any';
//   }
// }
}
