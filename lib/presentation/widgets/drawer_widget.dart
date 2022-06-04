import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more4u/core/constants/app_constants.dart';
import 'package:more4u/presentation/home/home_screen.dart';
import 'package:more4u/presentation/manage_requests/manage_requests_screen.dart';
import 'package:more4u/presentation/my_benefits/my_benefits_screen.dart';

import '../../core/constants/constants.dart';
import '../Login/login_screen.dart';


class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
        color: const Color(0xff293064),
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: 20.0.sp);
    return SizedBox(
      width: 273.w,
      child: Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 25.h),
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 35.h,
                  width: 35.h,
                  padding: EdgeInsets.zero,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset(
                      'assets/images/close.svg',
                      height: 30.h,
                      width: 30.h,
                      color: mainColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Tire@cemex.com',
                  style: TextStyle(
                      color: const Color(0xff293064),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.normal,
                      fontSize: 22.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const Divider(
                  thickness: 1,
                  color: mainColor,
                ),
              ),
              ListTile(
                dense: true,
                  minLeadingWidth:0,
                  contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: Icon(Icons.home),
                title: Text(
                  "Home",
                  style: style,
                ),
                onTap: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(HomeScreen.routeName));
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth:0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: Icon(Icons.insert_chart),
                title: Text(
                  "My Benefits",
                  style: style,
                ),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name ==
                      HomeScreen.routeName) {
                    Navigator.pushNamed(context, MyBenefitsScreen.routeName);
                    print('hhhhh');
                  } else {
                    Navigator.pushReplacementNamed(
                        context, MyBenefitsScreen.routeName);
                    print('nnnnnn');
                  }
                  // Navigator.pushNamedAndRemoveUntil(context, MyQuestions.routeName, ModalRoute.withName(SearchScreen.routeName));
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth:0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: Badge(
                    position: BadgePosition(top: -7, end: -6),
                    badgeColor: red,
                    badgeContent: Text('5', style: TextStyle(fontSize: 12,color: Colors.white)),
                    child: Icon(Icons.notifications)),
                title: Text(
                  "Notifications",
                  style: style,
                ),
                onTap: () {
                  // if (ModalRoute.of(context)?.settings.name ==
                  //     SearchScreen.routeName) {
                  //   Navigator.pushNamed(context, NotificationScreen.routeName);
                  //   print('hhhhh');
                  // } else {
                  //   Navigator.pushReplacementNamed(
                  //       context, NotificationScreen.routeName);
                  //   print('nnnnnn');
                  // }
                },
              ),


              ListTile(
                dense: true,
                minLeadingWidth:0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: const Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: style,
                ),
                onTap: () {
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     LoginScreen.routeName, (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth:0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: const Icon(Icons.event_note),
                title: Text(
                  'Manage Requests',
                  style: style,
                ),
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name ==
                      HomeScreen.routeName) {
                    Navigator.pushNamed(context, ManageRequestsScreen.routeName);

                  } else {
                    Navigator.pushReplacementNamed(
                        context, ManageRequestsScreen.routeName);

                  }
                },
              ),
              ListTile(
                dense: true,
                minLeadingWidth:0,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                leading: RotatedBox(quarterTurns: 2,child: const Icon(Icons.logout)),
                title: Text(
                  'Logout',
                  style: style,
                ),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
