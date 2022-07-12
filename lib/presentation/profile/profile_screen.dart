import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/profile/cubits/profile_cubit.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/user.dart';
import '../../injection_container.dart';
import '../notification/notification_screen.dart';
import '../widgets/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';

  final User user;
  final bool? isProfile;


  const ProfileScreen({Key? key,required this.user, this.isProfile=false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit _cubit;


  @override
  void initState() {
    _cubit = sl<ProfileCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h,),
                  (widget.isProfile!=null&&widget.isProfile!)?
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
                  ):
                  Container(
                    height: 50.h,
                    padding: EdgeInsets.only(top: 8.h),
                    margin: EdgeInsets.only(top: 14.h,bottom: 8.h),
                    child: IconButton(
                      splashRadius: 20.w,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      iconSize: 40.w,
                      icon:SvgPicture.asset(
                        'assets/images/back.svg',
                        fit: BoxFit.cover,
                        height: 50.w,
                        width: 50.w,
                        clipBehavior: Clip.none,
                        color: mainColor,
                      ),
                    ),
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

                  Row(
                    children: [
                      Column(
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
                          if(widget.isProfile!)
                          ElevatedButton(
                            onPressed: () {
                              showDialog(context: context, builder:(context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      width: 500.0.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 14.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "Edit Profile",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: mainColor,
                                              fontSize: 20.sp,
                                              fontFamily: "Cairo",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            "Change your profile picture",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: redColor,
                                              fontSize: 14.sp,
                                              fontFamily: "Cairo",
                                              fontWeight: FontWeight.w500,
                                            ),
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
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(),
                                          Text(
                                            "Change your Password",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: redColor,
                                              fontSize: 14.sp,
                                              fontFamily: "Cairo",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 16.h,),
                                          TextFormField(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400, color: mainColor),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                                              // suffixIconConstraints:
                                              //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                              prefixIcon: Icon(CustomIcons.lock2),
                                              suffixIcon: Material(
                                                color: Colors.transparent,
                                                type: MaterialType.circle,
                                                clipBehavior: Clip.antiAlias,
                                                borderOnForeground: true,
                                                elevation: 0,
                                                child: IconButton(

                                                  onPressed: () {
                                                    // _cubit.changeTextVisibility(
                                                    //     !_cubit.isTextVisible);
                                                  },
                                                  icon: true
                                                      ? Icon(
                                                    Icons.visibility_off_outlined,
                                                    size: 30.r,
                                                  )
                                                      : Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 30.r,
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                              hintText: 'Enter Your Password',
                                              hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            validator:  (String? value) {
                                              if (value!.isEmpty) return 'required';
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 25.h,),
                                          TextFormField(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400, color: mainColor),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                                              // suffixIconConstraints:
                                              //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                              prefixIcon: Icon(CustomIcons.lock2),
                                              suffixIcon: Material(
                                                color: Colors.transparent,
                                                type: MaterialType.circle,
                                                clipBehavior: Clip.antiAlias,
                                                borderOnForeground: true,
                                                elevation: 0,
                                                child: IconButton(

                                                  onPressed: () {
                                                    // _cubit.changeTextVisibility(
                                                    //     !_cubit.isTextVisible);
                                                  },
                                                  icon: true
                                                      ? Icon(
                                                    Icons.visibility_off_outlined,
                                                    size: 30.r,
                                                  )
                                                      : Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 30.r,
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                              hintText: 'Enter Your Password',
                                              hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            validator:  (String? value) {
                                              if (value!.isEmpty) return 'required';
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 25.h,),
                                          TextFormField(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400, color: mainColor),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                                              // suffixIconConstraints:
                                              //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                              prefixIcon: Icon(CustomIcons.lock2),
                                              suffixIcon: Material(
                                                color: Colors.transparent,
                                                type: MaterialType.circle,
                                                clipBehavior: Clip.antiAlias,
                                                borderOnForeground: true,
                                                elevation: 0,
                                                child: IconButton(

                                                  onPressed: () {
                                                    // _cubit.changeTextVisibility(
                                                    //     !_cubit.isTextVisible);
                                                  },
                                                  icon: true
                                                      ? Icon(
                                                    Icons.visibility_off_outlined,
                                                    size: 30.r,
                                                  )
                                                      : Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 30.r,
                                                  ),
                                                ),
                                              ),
                                              border: OutlineInputBorder(),
                                              labelText: 'Password',
                                              hintText: 'Enter Your Password',
                                              hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                              floatingLabelBehavior: FloatingLabelBehavior.always,
                                            ),
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            validator:  (String? value) {
                                              if (value!.isEmpty) return 'required';
                                              return null;
                                            },
                                          ),
                                          SizedBox(height: 50.h,),
                                          Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                              height: 55.h,
                                              width: 200.w,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // _cubit.loginUser(User(
                                                  //     username: 'nabeh', pass: '123'));
                                                  // _cubit.login();
                                                  // if (_formKey.currentState!.validate()) {
                                                  //   _cubit.login();
                                                  // }
                                                },
                                                child: Text(
                                                  'Save Changes',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 18.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 40.h,),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              );
                            },
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
                              widget.user.employeeName??'',
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
                                  widget.user.email??'',
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
                                 widget.user.phoneNumber??'',
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
                                  widget.user.employeeNumber.toString(),
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
                        widget.user.birthDate??'',
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
                        widget.user.gender??'',
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
                        widget.user.workDuration??'',
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
                        widget.user.maritalStatus??'',
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
                        widget.user.departmentName??'',
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
                        widget.user.collar??'',
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
                        widget.user.sapNumber.toString(),
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
                        widget.user.company??'',
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
                        widget.user.joinDate??'',
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
                        widget.user.address??'',
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
                        widget.user.nationality??'',
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
                        widget.user.supervisorName??'',
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
      ),
    );
  }
}
