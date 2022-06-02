part of 'manage_requests_cubit.dart';

@immutable
abstract class ManageRequestsState {}

class ManageRequestsInitial extends ManageRequestsState {}

class GetRequestsToManageLoadingState extends ManageRequestsState {}

class GetRequestsToManageSuccessState extends ManageRequestsState {}

class GetRequestsToManageFailedState extends ManageRequestsState {
  final String message;

  GetRequestsToManageFailedState(this.message);
}
