part of 'my_benefit_requests_cubit.dart';

@immutable
abstract class MyBenefitRequestsState {}

class MyBenefitRequestsInitial extends MyBenefitRequestsState {}

class MyBenefitRequestsLoadingState extends MyBenefitRequestsState {}

class MyBenefitRequestsErrorState extends MyBenefitRequestsState {
  final String message;

  MyBenefitRequestsErrorState(this.message);
}

class MyBenefitRequestsSuccessState extends MyBenefitRequestsState {}

class ChangeSizeState extends MyBenefitRequestsState {}
