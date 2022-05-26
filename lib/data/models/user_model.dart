import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel(
      {required String employeeName,
      required String email,
      required int employeeNumber,
      required String positionName,
      required String departmentName,
      required String birthDate,
      required String joinDate,
      required bool hasRequests})
      : super(
            employeeName: employeeName,
            email: email,
            employeeNumber: employeeNumber,
            positionName: positionName,
            departmentName: departmentName,
            birthDate: birthDate,
            joinDate: joinDate,
            hasRequests: hasRequests);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        employeeName: json['employeeName'],
        email: json['email'],
        employeeNumber: json['employeeNumber'],
        positionName: json['positionName'],
        departmentName: json['departmentName'],
        birthDate: json['birthDate'],
        joinDate: json['joinDate'],
        hasRequests: json['hasRequests']);
  }
}
