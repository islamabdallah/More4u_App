import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more4u/custom_icons.dart';
import 'package:more4u/presentation/home/home_screen.dart';
import 'package:more4u/presentation/manage_requests/manage_requests_screen.dart';
import 'package:more4u/presentation/my_benefits/my_benefits_screen.dart';
import 'package:more4u/presentation/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
import '../../data/datasources/local_data_source.dart';
import '../Login/login_screen.dart';
import '../home/cubits/home_cubit.dart';
import '../notification/notification_screen.dart';
import 'powered_by_cemex.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 273.w,
      child: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.white.withOpacity(0.8),
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 25.h),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 16.h,
                  ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColor, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      height: 130.h,
                      width: 132.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                            'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Image.asset('assets/images/banner.png'),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            userData!.email??'',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildListTile(
                    context,
                    title: 'Home',
                    leading: CustomIcons.home__2_,
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(HomeScreen.routeName));
                    },
                  ),
                  buildListTile(
                    context,
                    title: 'My Requests',
                    leading: CustomIcons.ticket,
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name ==
                          HomeScreen.routeName) {
                        Navigator.pushNamed(
                            context, MyBenefitsScreen.routeName).whenComplete(() => HomeCubit.get(context).getHomeData());
                        print('hhhhh');
                      } else {
                        Navigator.pushReplacementNamed(
                            context, MyBenefitsScreen.routeName);
                        print('nnnnnn');
                      }
                      // Navigator.pushNamedAndRemoveUntil(context, MyQuestions.routeName, ModalRoute.withName(SearchScreen.routeName));
                    },
                  ),
                  buildListTile(
                    context,
                    title: 'Notifications',
                    leading: CustomIcons.bell,
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name ==
                          HomeScreen.routeName) {
                        Navigator.pushNamed(
                            context, NotificationScreen.routeName);
                        print('hhhhh');
                      } else {
                        Navigator.pushReplacementNamed(
                            context, NotificationScreen.routeName);
                        print('nnnnnn');
                      }
                    },
                  ),
                  buildListTile(
                    context,
                    title: 'Profile',
                    leading: CustomIcons.user,
                    onTap: () {
                      if(ModalRoute.of(context)?.settings.name!=ProfileScreen.routeName)
                      Navigator.pushNamed(context, ProfileScreen.routeName,arguments: userData);
                    },
                  ),
                  Divider(),

                  Visibility(
                    visible: userData!.hasRequests!,
                    child: buildListTile(
                      context,
                      title: 'Manage Requests',
                      leading: CustomIcons.business_time,
                      onTap: () {
                        if (ModalRoute.of(context)?.settings.name ==
                            HomeScreen.routeName) {
                          Navigator.pushNamed(
                              context, ManageRequestsScreen.routeName).whenComplete(() => HomeCubit.get(context).getHomeData());
                        } else {
                          Navigator.pushReplacementNamed(
                              context, ManageRequestsScreen.routeName);
                        }
                      },
                    ),
                  ),
                  buildListTile(
                    context,
                    title: 'Logout',
                    leading: CustomIcons.sign_out_alt,
                    onTap: ()  {
                        PushNotificationService.deleteDeviceToken();
                        SharedPreferences.getInstance()
                            .then((value) => value.remove(CACHED_USER));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.routeName, (Route<dynamic> route) => false);
                      },
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PoweredByCemex()
                  ),
                  // ListTile(
                  //   dense: true,
                  //   minLeadingWidth: 0,
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  //   leading: Icon(Icons.insert_chart),
                  //   title: Text(
                  //     "My Benefits",
                  //     style: style,
                  //   ),
                  //   onTap: () {
                  //     if (ModalRoute.of(context)?.settings.name ==
                  //         HomeScreen.routeName) {
                  //       Navigator.pushNamed(context, MyBenefitsScreen.routeName);
                  //       print('hhhhh');
                  //     } else {
                  //       Navigator.pushReplacementNamed(
                  //           context, MyBenefitsScreen.routeName);
                  //       print('nnnnnn');
                  //     }
                  //     // Navigator.pushNamedAndRemoveUntil(context, MyQuestions.routeName, ModalRoute.withName(SearchScreen.routeName));
                  //   },
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   minLeadingWidth: 0,
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  //   leading: Badge(
                  //       position: BadgePosition(top: -7, end: -6),
                  //       badgeColor: red,
                  //       badgeContent: Text('5',
                  //           style: TextStyle(fontSize: 12, color: Colors.white)),
                  //       child: Icon(Icons.notifications)),
                  //   title: Text(
                  //     "Notifications",
                  //     style: style,
                  //   ),
                  //   onTap: () {
                  //     // if (ModalRoute.of(context)?.settings.name ==
                  //     //     SearchScreen.routeName) {
                  //     //   Navigator.pushNamed(context, NotificationScreen.routeName);
                  //     //   print('hhhhh');
                  //     // } else {
                  //     //   Navigator.pushReplacementNamed(
                  //     //       context, NotificationScreen.routeName);
                  //     //   print('nnnnnn');
                  //     // }
                  //   },
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   minLeadingWidth: 0,
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  //   leading: const Icon(Icons.person),
                  //   title: Text(
                  //     'Profile',
                  //     style: style,
                  //   ),
                  //   onTap: () {
                  //     // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     //     LoginScreen.routeName, (Route<dynamic> route) => false);
                  //   },
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   minLeadingWidth: 0,
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  //   leading: const Icon(Icons.event_note),
                  //   title: Text(
                  //     'Manage Requests',
                  //     style: style,
                  //   ),
                  //   onTap: () {
                  //     if (ModalRoute.of(context)?.settings.name ==
                  //         HomeScreen.routeName) {
                  //       Navigator.pushNamed(
                  //           context, ManageRequestsScreen.routeName);
                  //     } else {
                  //       Navigator.pushReplacementNamed(
                  //           context, ManageRequestsScreen.routeName);
                  //     }
                  //   },
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   minLeadingWidth: 0,
                  //   contentPadding:
                  //       EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
                  //   leading: RotatedBox(
                  //       quarterTurns: 2, child: const Icon(Icons.logout)),
                  //   title: Text(
                  //     'Logout',
                  //     style: style,
                  //   ),
                  //   onTap: () {
                  //     PushNotificationService.deleteDeviceToken();
                  //     SharedPreferences.getInstance()
                  //         .then((value) => value.remove(CACHED_USER));
                  //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //         LoginScreen.routeName, (Route<dynamic> route) => false);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context,
      {required IconData leading,
      required String title,
      void Function()? onTap}) {
    return SizedBox(
      // height: 50.h,
      child: ListTile(
        dense: true,
        minLeadingWidth: 0,
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 12.w),
        leading: SimpleShadow(
            offset: Offset(0, 4),
            color: Colors.black,
            child: Icon(leading, color: mainColor, size: 25.r)),
        title: Text(
          title,
          style: TextStyle(
            color: greyColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.0.sp,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
