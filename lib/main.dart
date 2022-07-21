import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/data/models/user_model.dart';
import 'package:more4u/presentation/Login/login_screen.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/profile/profile_screen.dart';

import 'core/constants/constants.dart';
import 'core/firebase/push_notification_service.dart';
import 'injection_container.dart';
import 'presentation/benefit_redeem/BenefitRedeemScreen.dart';
import 'presentation/home/home_screen.dart';
import 'core/config/bloc_observer.dart';
import 'core/config/routes/routes.dart';
import 'core/utils/services/local_storage/local_storage_service.dart';
import 'injection_container.dart' as di;
import 'presentation/manage_requests/manage_requests_screen.dart';
import 'presentation/my_benefits/my_benefits_screen.dart';
import 'presentation/notification/cubits/notification_cubit.dart';
import 'presentation/splash/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
        minTextAdapt: false,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>(
                create: (context) => sl<HomeCubit>(),
              ),
              BlocProvider<NotificationCubit>(
                create: (context) => sl<NotificationCubit>(),
              ),
            ],
            child: MaterialApp(
              color: mainColor,

              theme: ThemeData(
                primaryColor: mainColor,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: mainColor,
                ),
                iconTheme: IconThemeData(color: greyColor, size: 20.r),
                fontFamily: 'Cairo',
                drawerTheme:
                    DrawerThemeData(scrimColor: Colors.black.withOpacity(0.2))
                // textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
                ,
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                    // Apply this to every platforms you need.
                  },
                ),
              ),
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              onGenerateRoute: AppRoutes.onGenerateRoutes,
              initialRoute: SplashScreen.routeName,
              // initialRoute: ProfileScreen.routeName,
              // initialRoute: LoginScreen.routeName,
              // initialRoute: ManageRequestsScreen.routeName,
              // initialRoute: MyBenefitsScreen.routeName,
              // initialRoute: HomeScreen.routeName,
              // initialRoute: BenefitDetailedScreen.routeName,
              // initialRoute: BenefitRedeemScreen.routeName,
            ),
          );
        });
  }
}
