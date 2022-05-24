import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int id;
  final String name;
  final int year;
  final String benefitCard;
  final bool employeeCanRedeem;
  final BenefitType benefitType;

  //detailed_screen
  String? description;
  List<String>? benefitWorkflow;
  List<String>? benefitConditions;

  //popupForm
  int? minParticipant;
  int? maxParticipant;

  Benefit(
      {required this.id,
      required this.name,
      required this.year,
      required this.benefitCard,
      required this.employeeCanRedeem,
      required this.benefitType,
      this.description,
      this.benefitConditions,
      this.benefitWorkflow,
      this.minParticipant,
      this.maxParticipant});

  @override
  List<Object?> get props => [
        id,
        name,
        year,
        benefitCard,
        employeeCanRedeem,
        benefitType,
        description,
        benefitWorkflow,
        benefitConditions,
        minParticipant,
        maxParticipant
      ];
}

class BenefitType extends Equatable {
  final int id;
  final String name;

  const BenefitType({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
