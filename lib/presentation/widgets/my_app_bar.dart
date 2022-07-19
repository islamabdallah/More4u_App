import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../home/cubits/home_cubit.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(builder: (context) {
          return Material(
            borderRadius: BorderRadius.circular(100),
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              iconSize: 45.w,
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/cadeau.png'),
                  Padding(
                    padding: EdgeInsets.only(top:24.0.h),
                    child: SvgPicture.asset(
                      'assets/images/menu.svg',
                      // fit: BoxFit.cover,
                      width: 25.h,
                      height: 25.h,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    return Badge(
      showBadge: HomeCubit.get(context).userUnSeenNotificationCount!=0,
          ignorePointer: true,
          position: BadgePosition(bottom: -2, end: 3),
          badgeColor: redColor,
          // badgeContent: SizedBox(
          //   width: 12.h,
          //   height: 12.h,
          // ),
          padding: EdgeInsets.all(8.r),
          badgeContent: Text(
            HomeCubit.get(context).userUnSeenNotificationCount.toString(),
            style: TextStyle(color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.bold),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(150.r),
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
    if (ModalRoute.of(context)?.settings.name ==
    HomeScreen.routeName) {
      final completer = Completer();
      final result = Navigator.pushNamedAndRemoveUntil(
          context, NotificationScreen.routeName,
          ModalRoute.withName(HomeScreen.routeName)).whenComplete(() =>
          HomeCubit.get(context).getHomeData());
      completer.complete(result);
    } else{
      final completer = Completer();
      final result = Navigator.pushReplacementNamed(
          context, NotificationScreen.routeName,
          result: completer.future);
      completer.complete(result);
    }
              },
              iconSize: 30.w,
              icon: SimpleShadow(
                  offset: Offset(0, 4),
                  color: Colors.black.withOpacity(0.25),
                  child: Icon(
                    CustomIcons.bell,
                    color: mainColor,
                  )),
            ),
          ),
        );
  },
),
      ],
    );
  }
}
