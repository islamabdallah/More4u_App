import 'package:more4u/domain/entities/benefit.dart';

class BenefitModel extends Benefit {
  BenefitModel({
    required int id,
    required String name,
    required int year,
    required String benefitCard,
    required bool employeeCanRedeem,
    required BenefitType benefitType,
    //detailed_screen
    String? description,
    List<String>? benefitWorkflow,
    List<String>? benefitConditions,
    //popupForm
    int? minParticipant,
    int? maxParticipant,
  }) : super(
          id: id,
          name: name,
          year: year,
          benefitCard: benefitCard,
          employeeCanRedeem: employeeCanRedeem,
          benefitType: benefitType,
          description: description,
          benefitConditions: benefitConditions,
          benefitWorkflow: benefitWorkflow,
          minParticipant: minParticipant,
          maxParticipant: maxParticipant,
        );

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      benefitCard: json['benefitCard'],
      employeeCanRedeem: json['employeeCanRedeem'],
      benefitType: BenefitTypeModel.fromJson(json['benefitType']),
      description: json['description'],
      benefitConditions: json['benefitConditions']?.cast<String>(),
      benefitWorkflow: json['benefitWorkflow']?.cast<String>(),
      minParticipant: json['minParticipant'],
      maxParticipant: json['maxParticipant'],
    );
  }
}

class BenefitTypeModel extends BenefitType {
  BenefitTypeModel({required int id, required String name})
      : super(id: id, name: name);

  factory BenefitTypeModel.fromJson(Map<String, dynamic> json) {
    return BenefitTypeModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
