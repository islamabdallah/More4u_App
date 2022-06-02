import 'package:flutter/material.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';

import '../../../domain/entities/benefit.dart';
import '../../../presentation/Login/login_screen.dart';
import '../../../presentation/benefit_details/beneifit_detailed_screen.dart';
import '../../../presentation/benefit_redeem/BenefitRedeemScreen.dart';
import '../../../presentation/home/home_screen.dart';
import '../../../presentation/manage_requests/manage_requests_screen.dart';
import '../../../presentation/my_benefits/my_benefits_screen.dart';
import '../../../presentation/pages/profile.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return _materialRoute(const LoginScreen(), LoginScreen.routeName);

      case ProfileWidget.routeName:
        return _materialRoute(const ProfileWidget(), ProfileWidget.routeName);

      case HomeScreen.routeName:
        return _materialRoute(const HomeScreen(), HomeScreen.routeName);
      case MyBenefitsScreen.routeName:
        return _materialRoute(
            const MyBenefitsScreen(), MyBenefitsScreen.routeName);

      case ManageRequestsScreen.routeName:
        return _materialRoute(
            const ManageRequestsScreen(), ManageRequestsScreen.routeName);

      case MyBenefitRequestsScreen.routeName:
        return _materialRoute(
            MyBenefitRequestsScreen(
              benefitId: settings.arguments as int,
            ),
            MyBenefitRequestsScreen.routeName);

      case BenefitDetailedScreen.routeName:
        return _materialRoute(
            BenefitDetailedScreen(benefit: settings.arguments as Benefit),
            BenefitDetailedScreen.routeName);

      case BenefitRedeemScreen.routeName:
        return _materialRoute(
            BenefitRedeemScreen(
              benefit: settings.arguments as Benefit,
            ),
            BenefitRedeemScreen.routeName);

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _materialRoute(
            const Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text('Route Error'),
                ),
              ),
            ),
            '404');
    }
  }

  static Route<dynamic> _materialRoute(Widget view, String routeName) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => view,
    );
  }
}
