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
  final int gender;
  final int maritalStatus;
  final String company;
  final String nationality;
  final String? phoneNumber;
  final String address;
  final int collar;
  final int sapNumber;
  final String id;
  final String supervisorName;
  final String profilePicture;

  const User({
    required this.employeeName,
    required this.email,
    required this.employeeNumber,
    required this.positionName,
    required this.departmentName,
    required this.birthDate,
    required this.joinDate,
    required this.hasRequests,
    required this.gender,
    required this.maritalStatus,
    required this.company,
    required this.nationality,
    this.phoneNumber,
    required this.address,
    required this.collar,
    required this.sapNumber,
    required this.id,
    required this.supervisorName,
    required this.profilePicture,
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
        hasRequests,
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
      ];

  String get genderString {
    switch (gender) {
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Any';
    }
  }

  String get maritalStatusString {
    switch (gender) {
      case 1:
        return 'Single';
      case 2:
        return 'Married';
      case 3:
        return 'Divorced';
      default:
        return 'Any';
    }
  }

  String get collarString {
    switch (gender) {
      case 1:
        return 'WhiteCollar';
      case 2:
        return 'blueCollar';
      default:
        return 'Any';
    }
  }
}
