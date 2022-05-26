import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int id;
  final String name;
  final String benefitCard;
  final int times;
  final bool employeeCanRedeem;
  final BenefitType benefitType;

  //Data to use in details screen
  String? description;
  List<String>? benefitConditions;
  List<String>? benefitWorkflows;

  //Data to use in Redeem
  final bool isAgift;
  final int minParticipant;
  final int maxParticipant;
  String? requiredDocuments;
  int? numberOfDays;
  String? dateToMatch;
  String? certainDate;

  Benefit({
    required this.id,
    required this.name,
    required this.benefitCard,
    required this.times,
    required this.employeeCanRedeem,
    required this.benefitType,
    this.description,
    this.benefitWorkflows,
    this.benefitConditions,
    required this.isAgift,
    required this.minParticipant,
    required this.maxParticipant,
    this.requiredDocuments,
    this.numberOfDays,
    this.dateToMatch,
    this.certainDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        benefitCard,
        times,
        employeeCanRedeem,
        benefitType,
        description,
        benefitWorkflows,
        benefitConditions,
        isAgift,
        minParticipant,
        maxParticipant,
        requiredDocuments,
        dateToMatch,
        certainDate,
      ];
}

class BenefitType extends Equatable {
  final int id;
  final String name;

  const BenefitType({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
