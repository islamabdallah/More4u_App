import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/data/models/user_model.dart';
import 'package:more4u/presentation/Login/login_screen.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import 'data/datasources/benefit_remote_data_source.dart';
import 'presentation/benefit_redeem/BenefitRedeemScreen.dart';
import 'presentation/home/home_screen.dart';
import 'core/config/bloc_observer.dart';
import 'core/config/routes/routes.dart';
import 'core/utils/services/local_storage/local_storage_service.dart';
import 'injection_container.dart' as di;
import 'presentation/my_benefits/my_benefits_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  BlocOverrides.runZoned(
        () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
  CacheHelper.init();



 //  String test = await rootBundle.loadString('assets/mybenefits_response.json');
 // var json = jsonDecode(test);
 // print(json);
 //
 // UserModel user = UserModel.fromJson(json['data']['user']);
 // print(user.email);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
      builder: (child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (context) => HomeCubit(),
            ),
          ],
          child: const MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.onGenerateRoutes,
            initialRoute: LoginScreen.routeName,
            // initialRoute: MyBenefitsScreen.routeName,
            // initialRoute: HomeScreen.routeName,
            // initialRoute: BenefitDetailedScreen.routeName,
            // initialRoute: BenefitRedeemScreen.routeName,
          ),
        );
      }
    );
  }
}