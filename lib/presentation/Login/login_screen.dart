import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/custom_icons.dart';
import 'package:more4u/injection_container.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../home/home_screen.dart';
import '../widgets/powered_by_cemex.dart';
import '../widgets/utils/loading_dialog.dart';
import '../widgets/utils/message_dialog.dart';
import 'cubits/login_cubit.dart';
import 'cubits/login_states.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late LoginCubit _cubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _cubit = sl<LoginCubit>();
    super.initState();
  }

// validate Email
//   String? validateEmail(String? value) {
//     String pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);
//     if (value != null) {
//       print(regex.hasMatch(value));
//       if (!regex.hasMatch(value)) return 'emailError';
//     } else
//       return null;
//   }

  String? validateEmail(String? value) {
    if (value != null && value.isEmpty)
      return 'emailError';
    else
      return null;
  }

//   validate Password
  String? validatePassword(String? value) {
    if (value != null && value.isEmpty)
      return 'passwordError';
    else
      return null;
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/decoration.png',
                    fit: BoxFit.fitWidth,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Container(
                    child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/more4u_new.png',
                    height: 170.h,
                    width: 180.w,
                  ),
                )),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BlocConsumer(
                bloc: _cubit,
                listener: (context, state) {
                  if (state is LoginLoadingState) loadingAlertDialog(context);
                  if (state is LoginErrorState) {
                    Navigator.pop(context);
                    showMessageDialog(
                        context: context,
                        message: state.message,
                        isSucceeded: false,
                        );
                  }
                  if (state is LoginSuccessState) {
                    Navigator.pop(context);
                    print(state.loginResponse);
                    var homeCubit = HomeCubit.get(context);
                    homeCubit.benefitModels = state.loginResponse.benefitModels;
                    homeCubit.availableBenefitModels =
                        state.loginResponse.availableBenefitModels;
                    homeCubit.userUnSeenNotificationCount = state.loginResponse.userUnSeenNotificationCount;
                    homeCubit.pendingRequestsCount = state.loginResponse.user.pendingRequestsCount!;
                    homeCubit.priviligesCount = state.loginResponse.priviligesCount;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName, (Route<dynamic> route) => false);
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(children: <Widget>[
                      TextFormField(
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: mainColor),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          suffixIconConstraints:
                              BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                          prefixIcon: Icon(CustomIcons.user_info),
                          border: OutlineInputBorder(),
                          labelText: 'Employee Number',
                          hintText: 'Enter Your Number',
                          hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.number,
                        controller: _cubit.employeeNumberController,
                        inputFormatters:
                         [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        validator:  (String? value) {
                          if (value!.isEmpty) return 'required';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      TextFormField(
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: mainColor),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          // suffixIconConstraints:
                          //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                          prefixIcon: Icon(CustomIcons.lock2),
                          suffixIcon: Material(
                            color: Colors.transparent,
                            type: MaterialType.circle,
                            clipBehavior: Clip.antiAlias,
                            borderOnForeground: true,
                            elevation: 0,
                            child: IconButton(

                                onPressed: () {
                                  _cubit.changeTextVisibility(
                                      !_cubit.isTextVisible);
                                },
                                icon: !_cubit.isTextVisible
                                    ? Icon(
                                        Icons.visibility_off_outlined,
                                        size: 30.r,
                                      )
                                    : Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 30.r,
                                      ),
                            ),
                          ),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter Your Password',
                          hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_cubit.isTextVisible,
                        controller: _cubit.passwordController,
                        validator:  (String? value) {
                          if (value!.isEmpty) return 'required';
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 55.h,
                      ),
                      SizedBox(
                        height: 55.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // _cubit.loginUser(User(
                            //     username: 'nabeh', pass: '123'));
                            // _cubit.login();
                            if (_formKey.currentState!.validate()) {
                              _cubit.login();
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      PoweredByCemex()
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
