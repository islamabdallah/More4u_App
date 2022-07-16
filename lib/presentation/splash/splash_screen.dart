import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/data/datasources/local_data_source.dart';
import 'package:more4u/presentation/Login/login_screen.dart';
import 'package:more4u/presentation/widgets/helpers.dart';
import 'package:more4u/presentation/widgets/powered_by_cemex.dart';
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
    Timer(const Duration(seconds: 1), _goNext);
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
      final result = await login(employeeNumber: json['employeeNumber'],pass: json['pass']);
      result.fold((failure) {
        showMessageDialog(context: context, isSucceeded: false,message: failure.message,onPressedOk: (){
          if(failure.message != 'No internet Connection'){
            logOut(context);
          }
        });
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
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/decoration.png',
                    fit: BoxFit.fitWidth,
                  )),
            ),

            Spacer(),
            Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/more4u_new.png',
                      height: 209.h,
                      width: 275.w,
                    ),
                  ),

            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                ),
              ),
            ),
            Spacer(),
            PoweredByCemex(),
            SizedBox(height: 40.h,)
          ],
        ),
      ),
    );
  }
}
