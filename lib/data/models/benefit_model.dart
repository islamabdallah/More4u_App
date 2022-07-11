import 'package:more4u/domain/entities/benefit.dart';

class BenefitModel extends Benefit {
  const BenefitModel({
    required int id,
    required String name,
    required String benefitCard,
    required int times,
    required int timesEmployeeReceiveThisBenefit,
    required bool employeeCanRedeem,
    required String benefitType,
    //Data to use in details screen
    String? description,
    List<String>? benefitWorkflows,
    BenefitConditionsModel? benefitConditions,
    BenefitApplicable? benefitApplicable,
    //Data to use in Redeem
    required bool isAgift,
    required int minParticipant,
    required int maxParticipant,
    List<String>? requiredDocumentsArray,
    int? numberOfDays,
    String? dateToMatch,
    String? certainDate,
    String? lastStatus,
    int? totalRequestsCount,
    bool? hasHoldingRequests,
  }) : super(
          id: id,
          name: name,
          benefitCard: benefitCard,
          times: times,
          timesEmployeeReceiveThisBenefit: timesEmployeeReceiveThisBenefit,
          employeeCanRedeem: employeeCanRedeem,
          benefitType: benefitType,
          description: description,
          benefitWorkflows: benefitWorkflows,
          benefitConditions: benefitConditions,
          benefitApplicable: benefitApplicable,
          isAgift: isAgift,
          minParticipant: minParticipant,
          maxParticipant: maxParticipant,
          requiredDocumentsArray: requiredDocumentsArray,
          numberOfDays: numberOfDays,
          dateToMatch: dateToMatch,
          certainDate: certainDate,
          lastStatus: lastStatus,
          totalRequestsCount: totalRequestsCount,
          hasHoldingRequests: hasHoldingRequests,
        );

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(
      id: json['id'],
      name: json['name'],
      benefitCard: json['benefitCard'],
      times: json['times'],
      timesEmployeeReceiveThisBenefit: json['timesEmployeeReceiveThisBenefit'],
      employeeCanRedeem: json['employeeCanRedeem'],
      benefitType: json['benefitType'],
      description: json['description'],
      benefitWorkflows: json['benefitWorkflows']?.cast<String>(),
      benefitConditions: json["benefitConditions"] != null
          ? BenefitConditionsModel.fromJson(json["benefitConditions"])
          : null,
      benefitApplicable: json["benefitApplicable"] != null
          ? BenefitApplicableModel.fromJson(json["benefitApplicable"])
          : null,
      isAgift: json['isAgift'],
      minParticipant: json['minParticipant'],
      maxParticipant: json['maxParticipant'],
      requiredDocumentsArray: json['requiredDocumentsArray']?.cast<String>(),
      numberOfDays: json['numberOfDays'],
      dateToMatch: json['dateToMatch'],
      certainDate: json['certainDate'],
      lastStatus: json['lastStatus'],
      totalRequestsCount: json['totalRequestsCount'],
      hasHoldingRequests: json['hasHoldingRequests'],
    );
  }
}

class BenefitConditionsModel extends BenefitConditions {
  const BenefitConditionsModel({
    final String? type,
    final String? workDuration,
    final String? dateToMatch,
    final String? gender,
    final String? maritalStatus,
    final String? requiredDocuments,
    final String? age,
    final String? minParticipant,
    final String? maxParticipant,
    final String? payrollArea,
  }) : super(
            type: type,
            workDuration: workDuration,
            dateToMatch: dateToMatch,
            gender: gender,
            maritalStatus: maritalStatus,
            requiredDocuments: requiredDocuments,
            age: age,
            minParticipant: minParticipant,
            maxParticipant: maxParticipant,
            payrollArea: payrollArea);

  factory BenefitConditionsModel.fromJson(Map<String, dynamic> json) =>
      BenefitConditionsModel(
        type: json["Type"],
        workDuration: json["WorkDuration"],
        dateToMatch: json["DateToMatch"],
        gender: json["Gender"],
        maritalStatus: json["MaritalStatus"],
        requiredDocuments: json["RequiredDocuments"],
        age: json["Age"],
        minParticipant: json["MinParticipant"],
        maxParticipant: json["MaxParticipant"],
        payrollArea: json["PayrollArea"],
      );
}

class BenefitApplicableModel extends BenefitApplicable {
  const BenefitApplicableModel({
    final bool? type,
    final bool? workDuration,
    final bool? dateToMatch,
    final bool? gender,
    final bool? maritalStatus,
    final bool? requiredDocuments,
    final bool? age,
    final bool? minParticipant,
    final bool? maxParticipant,
    final bool? payrollArea,
  }) : super(
            type: type,
            workDuration: workDuration,
            dateToMatch: dateToMatch,
            gender: gender,
            maritalStatus: maritalStatus,
            age: age,
            minParticipant: minParticipant,
            maxParticipant: maxParticipant,
            payrollArea: payrollArea);

  factory BenefitApplicableModel.fromJson(Map<String, dynamic> json) =>
      BenefitApplicableModel(
        type: json["Type"],
        workDuration: json["WorkDuration"],
        dateToMatch: json["DateToMatch"],
        gender: json["Gender"],
        maritalStatus: json["MaritalStatus"],
        requiredDocuments: json["RequiredDocuments"],
        age: json["Age"],
        minParticipant: json["MinParticipant"],
        maxParticipant: json["MaxParticipant"],
        payrollArea: json["PayrollArea"],
      );
}
//
// class BenefitTypeModel extends BenefitType {
//   BenefitTypeModel({required int id, required String name})
//       : super(id: id, name: name);
//
//   factory BenefitTypeModel.fromJson(Map<String, dynamic> json) {
//     return BenefitTypeModel(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }
