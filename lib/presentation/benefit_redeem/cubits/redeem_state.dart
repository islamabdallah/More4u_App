part of 'redeem_cubit.dart';

@immutable
abstract class RedeemState {}

class RedeemInitial extends RedeemState {}

class RedeemLoadingState extends RedeemState {}

class RedeemGetParticipantsSuccessState extends RedeemState {}

class RedeemGetParticipantsErrorState extends RedeemState {
  final String? message;

  RedeemGetParticipantsErrorState(this.message);
}

class DateChangeState extends RedeemState {}

class ParticipantsChangedState extends RedeemState {}

