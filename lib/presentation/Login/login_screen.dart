import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:more4u/injection_container.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../home/home_screen.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(
                child:
                    Container(child: Image.asset('assets/images/more4u.png')),
              ),
            ),
            BlocConsumer(
              bloc: _cubit,
              listener: (context, state) {
                if (state is LoginLoadingState) loadingAlertDialog(context);
                if (state is LoginErrorState) {
                  Navigator.pop(context);
                  showMessageDialog(
                      context: context,
                      message: state.message,
                      isSucceeded: false,
                      onPressedRetry: () {
                        print('ha');
                      });
                }
                if (state is LoginSuccessState) {
                  Navigator.pop(context);
                  print(state.loginResponse);
                  var homeCubit = HomeCubit.get(context);
                  homeCubit.benefitModels = state.loginResponse.benefitModels;
                  homeCubit.availableBenefitModels =
                      state.loginResponse.availableBenefitModels;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName, (Route<dynamic> route) => false);
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ID',
                            hintText: 'ID',
                            labelStyle: TextStyle(fontWeight: FontWeight.w600)),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.blue),
                        keyboardType: TextInputType.emailAddress,
                        controller: _cubit.userNameController,
                        validator: validateEmail,
                        // onChanged: (String val) {
                        //   // user.email = emailController.text.toString();
                        // },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'password',
                            hintText: 'password',
                            labelStyle: TextStyle(fontWeight: FontWeight.w600)),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.blue),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: _cubit.passwordController,
                        validator: validatePassword,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 45),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 30.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          // _cubit.loginUser(User(
                          //     username: 'nabeh', pass: '123'));

                          _cubit.login();

                          // if (_formKey.currentState!.validate()) {
                          //   _cubit.login();
                          // }

                        },
                        child: Text(
                          'login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
