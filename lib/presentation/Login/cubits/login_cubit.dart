import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/usecases/login_user.dart';

import '../../../../../core/utils/services/local_storage/local_storage_service.dart';

import '../../../domain/entities/login_response.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  static LoginCubit get(context) => BlocProvider.of(context);
  final LoginUserUsecase loginUser;

  LoginCubit({required this.loginUser}) : super(InitialLoginState());

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isTextVisible = false;

  LoginResponse? loginResponse = null;

// hide or visible password text
  void changeTextVisibility(bool value) {
    isTextVisible = value;
    emit(ChangePasswordVisibilityState());
  }

  void login() async {
    emit(LoginLoadingState());
    final result = await loginUser(
        username: userNameController.text, pass: passwordController.text);

    result.fold((failure) {
      emit(LoginErrorState(failure.message));
    }, (loginResponse) {
      userData = loginResponse.user;
      emit(LoginSuccessState(loginResponse));
    });
  }
}
