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
    requestNumber,
    benefitId,
  }) : super(
          employeeNumber: employeeNumber,
          employeeFullName: employeeFullName,
          employeeProfilePicture: employeeProfilePicture,
          notificationType: notificationType,
          message: message,
          requestStatus: requestStatus,
          date: date,
    requestNumber: requestNumber,
    benefitId: benefitId,
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
        requestNumber: json["requestNumber"],
        benefitId: json["benefitId"],
      );
}
