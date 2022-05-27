import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  final int employeeNumber;
  final String fullName;
  final String profilePicture;

  Participant(
      {required this.employeeNumber,
      required this.fullName,
      required this.profilePicture});

  @override
  List<Object?> get props => [employeeNumber, fullName, profilePicture];
}
