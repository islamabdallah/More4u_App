import 'package:more4u/domain/entities/participant.dart';

class ParticipantModel extends Participant {
  ParticipantModel(
      {required int employeeNumber,
      required String fullName,
      required String profilePicture})
      : super(
            employeeNumber: employeeNumber,
            fullName: fullName,
            profilePicture: profilePicture);

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      employeeNumber: json['employeeNumber'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
    );
  }
}
