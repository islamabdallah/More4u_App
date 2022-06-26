import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int? employeeNumber;
  final String? employeeFullName;
  final String? employeeProfilePicture;
  final String? notificationType;
  final dynamic message;
  final String? requestStatus;
  final String? date;
  final String? time;

  Notification({
    this.employeeNumber,
    this.employeeFullName,
    this.employeeProfilePicture,
    this.notificationType,
    this.message,
    this.requestStatus,
    this.date,
    this.time,
  });

  @override
  List<Object?> get props => [
        employeeNumber,
        employeeFullName,
        employeeProfilePicture,
        notificationType,
        message,
        requestStatus,
        date,
        time,
      ];
}
