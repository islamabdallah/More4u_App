import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int id;
  final String name;
  final String benefitCard;
  final int times;
  final int timesEmployeeReceiveThisBenefit;
  final String benefitType;
  final bool employeeCanRedeem;

  //Data to use in details screen
  final String? description;
  final List<String>? benefitConditions;
  final List<String>? benefitWorkflows;

  //Data to use in Redeem
  final bool isAgift;
  final int minParticipant;
  final int maxParticipant;
  final String? requiredDocuments;
  final int? numberOfDays;
  final String? dateToMatch;
  final String? certainDate;

  //other
  final String? lastStatus;
  //todo add benefitStatses to count requests

  const Benefit({
    required this.id,
    required this.name,
    required this.benefitCard,
    required this.times,
    required this.timesEmployeeReceiveThisBenefit,
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
    this.lastStatus,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        benefitCard,
        times,
        timesEmployeeReceiveThisBenefit,
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
        lastStatus,
      ];
}
//
// class BenefitType extends Equatable {
//   final int id;
//   final String name;
//
//   const BenefitType({required this.id, required this.name});
//
//   @override
//   List<Object?> get props => [id, name];
// }
