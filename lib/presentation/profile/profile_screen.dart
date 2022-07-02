import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/user.dart';
import '../notification/notification_screen.dart';
import '../widgets/drawer_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = 'ProfileScreen';

  final User user;

  const ProfileScreen({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h,),
                Row(
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
                                padding: EdgeInsets.only(top: 24.0.h),
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
                    Badge(
                      position: BadgePosition(bottom: -2, end: 3),
                      badgeColor: redColor,
                      // badgeContent: SizedBox(
                      //   width: 12.h,
                      //   height: 12.h,
                      // ),
                      padding: EdgeInsets.all(8.r),
                      badgeContent: Text(
                        '3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(150.r),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, NotificationScreen.routeName);
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
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Joti',
                        color: redColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
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
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Edit Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.employeeName??'',
                            style: TextStyle(
                              color: Color(0xff182756),
                              fontSize: 20.sp,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.envelope),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                user.email??'',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.briefcase),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                              '',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.phone_call),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                               user.phoneNumber??'',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.fingerprint),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                user.employeeNumber.toString(),
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black26,
                ),
                Text(
                  "More Informations",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: redColor,
                    fontSize: 20.sp,
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    Icon(CustomIcons.cake_birthday),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Birthday    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.birthDate??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.venus_mars),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Gender    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.gender??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.clock),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Work Duration    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.workDuration??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.bitmap),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Marital Status    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.maritalStatus??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.apps),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Department    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.departmentName??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.person_solid),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Payroll Area    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.collar??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.seedling_solid__1_),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Sap Number    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.sapNumber.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.building__1_),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Company    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.company??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.cursor_finger_1),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Joined at    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.joinDate??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.address_book),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Address    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.address??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.flag),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Nationality    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.nationality??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(CustomIcons.cursor_finger),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'Supervisor    ',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.supervisorName??'',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
