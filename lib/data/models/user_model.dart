import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required employeeName,
    required email,
    required employeeNumber,
    required positionName,
    required departmentName,
    required birthDate,
    required joinDate,
    required hasRequests,
    required gender,
    required maritalStatus,
    required company,
    required nationality,
    phoneNumber,
    required address,
    required collar,
    required sapNumber,
    required id,
    required supervisorName,
    required profilePicture,
  }) : super(
          employeeName: employeeName,
          email: email,
          employeeNumber: employeeNumber,
          positionName: positionName,
          departmentName: departmentName,
          birthDate: birthDate,
          joinDate: joinDate,
          hasRequests: hasRequests,
          gender: gender,
          maritalStatus: maritalStatus,
          company: company,
          nationality: nationality,
          phoneNumber: phoneNumber,
          address: address,
          collar: collar,
          sapNumber: sapNumber,
          id: id,
          supervisorName: supervisorName,
          profilePicture: profilePicture,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      employeeName: json['employeeName'],
      email: json['email'],
      employeeNumber: json['employeeNumber'],
      positionName: json['positionName'],
      departmentName: json['departmentName'],
      birthDate: json['birthDate'],
      joinDate: json['joinDate'],
      hasRequests: json['hasRequests'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      company: json['company'],
      nationality: json['nationality'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      collar: json['collar'],
      sapNumber: json['sapNumber'],
      id: json['id'],
      supervisorName: json['supervisorName'],
      profilePicture: json['profilePicture'],
    );
  }
}
