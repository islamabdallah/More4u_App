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
  final BenefitConditions? benefitConditions;
  final BenefitApplicable? benefitApplicable;
  final List<String>? benefitWorkflows;

  //Data to use in Redeem
  final bool isAgift;
  final int minParticipant;
  final int maxParticipant;
  final List<String>? requiredDocumentsArray;
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
    this.benefitApplicable,
    required this.isAgift,
    required this.minParticipant,
    required this.maxParticipant,
    this.requiredDocumentsArray,
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
        requiredDocumentsArray,
        dateToMatch,
        certainDate,
        lastStatus,
      ];
}

class BenefitConditions extends Equatable {
  final String? type;
  final String? workDuration;
  final String? dateToMatch;
  final String? gender;
  final String? maritalStatus;
  final String? requiredDocuments;
  final String? age;
  final String? minParticipant;
  final String? maxParticipant;
  final String? payrollArea;

  const BenefitConditions(
      {this.type,
      this.workDuration,
      this.dateToMatch,
      this.gender,
      this.maritalStatus,
      this.requiredDocuments,
      this.age,
      this.minParticipant,
      this.maxParticipant,
      this.payrollArea});

  @override
  List<Object?> get props => [
  type,
  workDuration,
  dateToMatch,
  gender,
  maritalStatus,
  requiredDocuments,
  age,
  minParticipant,
  maxParticipant,
  payrollArea,
  ];
}
class BenefitApplicable extends Equatable {
  final bool? type;
  final bool? workDuration;
  final bool? dateToMatch;
  final bool? gender;
  final bool? maritalStatus;
  final bool? requiredDocuments;
  final bool? age;
  final bool? minParticipant;
  final bool? maxParticipant;
  final bool? payrollArea;

  const BenefitApplicable(
      {this.type,
        this.workDuration,
        this.dateToMatch,
        this.gender,
        this.maritalStatus,
        this.requiredDocuments,
        this.age,
        this.minParticipant,
        this.maxParticipant,
        this.payrollArea});

  @override
  List<Object?> get props => [
    type,
    workDuration,
    dateToMatch,
    gender,
    maritalStatus,
    requiredDocuments,
    age,
    minParticipant,
    maxParticipant,
    payrollArea,
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
