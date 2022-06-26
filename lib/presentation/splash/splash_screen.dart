import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:more4u/data/datasources/local_data_source.dart';
import 'package:more4u/presentation/Login/login_screen.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/constants.dart';
import '../../domain/usecases/login_user.dart';
import '../../injection_container.dart';
import '../home/cubits/home_cubit.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user;

  _startDelay() {
    Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    await _getUserData();
    if(user==null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
    } else {
      var json = jsonDecode(user!);
      LoginUserUsecase login = sl<LoginUserUsecase>();
      final result = await login(username: json['employeeNumber'],pass: json['pass']);
      result.fold((failure) {
        showMessageDialog(context: context, isSucceeded: false);
      }, (loginResponse) {
        userData = loginResponse.user;
        var homeCubit = HomeCubit.get(context);
        homeCubit.benefitModels = loginResponse.benefitModels;
        homeCubit.availableBenefitModels =
            loginResponse.availableBenefitModels;
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomeScreen.routeName, (Route<dynamic> route) => false);
      });
    }

  }

  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedUser = prefs.getString(CACHED_USER);
    print(cachedUser);
    setState(() {
      user = cachedUser;
    });
  }

  @override
  void initState() {
    _startDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
