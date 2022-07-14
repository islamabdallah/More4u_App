import 'package:flutter/material.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/firebase/push_notification_service.dart';
import '../../data/datasources/local_data_source.dart';
import '../Login/login_screen.dart';

Color getBenefitStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.indigo;
    case 'InProgress':
      return yellowColor;
    case 'Approved':
      return greenColor;

    default:
      return redColor;
  }

}
  void logOut(BuildContext context){
    PushNotificationService.deleteDeviceToken();
    SharedPreferences.getInstance()
        .then((value) => value.remove(CACHED_USER));
    Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
            (Route<dynamic> route) => false);
  }
