import '../../domain/entities/gift.dart';

class GiftModel extends Gift {
  const GiftModel({
    int? requestNumber,
    int? employeeNumber,
    String? employeeName,
    String? benefitName,
    String? benefitCard,
    String? employeeDepartment,
    String? employeeEmail,
    String? date,
  }) : super(
          requestNumber: requestNumber,
          employeeNumber: employeeNumber,
          employeeName: employeeName,
          benefitName: benefitName,
          benefitCard: benefitCard,
          employeeDepartment: employeeDepartment,
          employeeEmail: employeeEmail,
          date: date,
        );

  factory GiftModel.fromJson(Map<String, dynamic> json) => GiftModel(
        requestNumber: json["requestNumber"],
        employeeNumber: json["employeeNumber"],
        employeeName: json["employeeName"],
        benefitName: json["benefitName"],
        benefitCard: json["benefitCard"],
        employeeDepartment: json["employeeDepartment"],
        employeeEmail: json["employeeEmail"],
        date: json["date"],
      );
}
