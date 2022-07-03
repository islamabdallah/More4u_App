part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class GetHomeDataLoadingState extends HomeState {}
class GetHomeDataSuccessState extends HomeState {}
class GetHomeDataErrorState extends HomeState {
 final String message;
  GetHomeDataErrorState(this.message);
}
