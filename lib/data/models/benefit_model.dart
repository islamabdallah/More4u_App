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
    List<String>? benefitConditions,
    //Data to use in Redeem
    required bool isAgift,
    required int minParticipant,
    required int maxParticipant,
    String? requiredDocuments,
    int? numberOfDays,
    String? dateToMatch,
    String? certainDate,
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
          isAgift: isAgift,
          minParticipant: minParticipant,
          maxParticipant: maxParticipant,
          requiredDocuments: requiredDocuments,
          numberOfDays: numberOfDays,
          dateToMatch: dateToMatch,
          certainDate: certainDate,
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
      benefitConditions: json['benefitConditions']?.cast<String>(),
      isAgift: json['isAgift'],
      minParticipant: json['minParticipant'],
      maxParticipant: json['maxParticipant'],
      requiredDocuments: json['requiredDocuments'],
      numberOfDays: json['numberOfDays'],
      dateToMatch: json['dateToMatch'],
      certainDate: json['certainDate'],
    );
  }
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
