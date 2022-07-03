import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/benefit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/datasources/local_data_source.dart';
import '../../../domain/usecases/login_user.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LoginUserUsecase loginUser;

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Benefit> benefitModels = [];
  List<Benefit>? availableBenefitModels = [];

  HomeCubit({required this.loginUser}) : super(HomeInitial());

  String? user;

  void getHomeData() async {
    emit(GetHomeDataLoadingState());
    await _getUserData();
    var json = jsonDecode(user!);

    final result = await loginUser(employeeNumber: json['employeeNumber'],pass: json['pass']);

    result.fold((failure) {
      emit(GetHomeDataErrorState(failure.message));
    }, (loginResponse) {
      userData = loginResponse.user;
      benefitModels = loginResponse.benefitModels;
      availableBenefitModels = loginResponse.availableBenefitModels;
      emit(GetHomeDataSuccessState());
    });
  }

  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedUser = prefs.getString(CACHED_USER);
    user = cachedUser;
  }
}
