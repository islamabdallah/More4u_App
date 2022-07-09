import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    employeeNumber,
    employeeFullName,
    employeeProfilePicture,
    notificationType,
    message,
    requestStatus,
    date,
    time,
  }) : super(
          employeeNumber: employeeNumber,
          employeeFullName: employeeFullName,
          employeeProfilePicture: employeeProfilePicture,
          notificationType: notificationType,
          message: message,
          requestStatus: requestStatus,
          date: date,
          time: time,
        );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        employeeNumber: json["employeeNumber"],
        employeeFullName: json["employeeFullName"],
        employeeProfilePicture: json["employeeProfilePicture"],
        notificationType: json["notificationType"],
        message: json["message"],
        requestStatus: json["requestStatus"],
        date: json["date"],
        time: json["time"],
      );
}
