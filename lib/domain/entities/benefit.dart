import 'package:equatable/equatable.dart';

class Benefit extends Equatable {
  final int id;
  final String name;
  final int year;
  final String benefitCard;
  final bool employeeCanRedeem;
  final BenefitType benefitType;

  const Benefit(
      {required this.id,
      required this.name,
      required this.year,
      required this.benefitCard,
      required this.employeeCanRedeem,
      required this.benefitType});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, year, benefitCard, employeeCanRedeem, benefitType];
}

class BenefitType extends Equatable {
  final int id;
  final String name;

  const BenefitType({required this.id, required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [id, name];
}
