part of 'manage_requests_cubit.dart';

@immutable
abstract class ManageRequestsState {}

class ManageRequestsInitial extends ManageRequestsState {}

class GetRequestsToManageLoadingState extends ManageRequestsState {}

class GetRequestsToManageSuccessState extends ManageRequestsState {}

class RemoveRequestSuccessState extends ManageRequestsState {}

class GetRequestsToManageFailedState extends ManageRequestsState {
  final String message;

  GetRequestsToManageFailedState(this.message);
}

class AddRequestResponseLoadingState extends ManageRequestsState {}

class AddRequestResponseSuccessState extends ManageRequestsState {
  final String message;

  AddRequestResponseSuccessState(this.message);
}

class AddRequestResponseErrorState extends ManageRequestsState {
  final String message;

  AddRequestResponseErrorState(this.message);
}

class ChangeFiltration extends ManageRequestsState {}
