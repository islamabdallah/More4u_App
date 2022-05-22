import 'package:more4u/domain/entities/benefit.dart';

class BenefitModel extends Benefit {
  BenefitModel(
      {required int id,
      required String name,
      required int year,
      required String benefitCard,
      required bool employeeCanRedeem,
      required BenefitType benefitType})
      : super(
            id: id,
            name: name,
            year: year,
            benefitCard: benefitCard,
            employeeCanRedeem: employeeCanRedeem,
            benefitType: benefitType);

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      benefitCard: json['benefitCard'],
      employeeCanRedeem: json['employeeCanRedeem'],
      benefitType: BenefitTypeModel.fromJson(json['benefitType']),
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
