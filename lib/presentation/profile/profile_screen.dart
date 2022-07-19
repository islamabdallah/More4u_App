import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/profile/cubits/profile_cubit.dart';
import 'package:more4u/presentation/widgets/utils/loading_dialog.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../core/utils/validators.dart';
import '../../custom_icons.dart';
import '../../domain/entities/user.dart';
import '../../injection_container.dart';
import '../notification/notification_screen.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';

  final User user;
  final bool? isProfile;

  const ProfileScreen({Key? key, required this.user, this.isProfile = false})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit _cubit;

  @override
  void initState() {
    _cubit = sl<ProfileCubit>()
      ..user = widget.user;
    if (!widget.isProfile!){
      _cubit.getProfileImage();
  }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is UpdatePictureLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is UpdatePictureSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: 'profile picture updated Successfully',
              onPressedOk: () {
                _cubit.clearPickedImage();
              });
        }
        if (state is UpdatePictureErrorState) {
          Navigator.pop(context);
          showMessageDialog(
            context: context,
            isSucceeded: false,
            message: state.message,
          );
        }

        if (state is ChangePasswordLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is ChangePasswordSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: state.message,
              onPressedOk: () {
                logOut(context);
              });
        }
        if (state is ChangePasswordErrorState) {
          Navigator.pop(context);
          showMessageDialog(
            context: context,
            isSucceeded: false,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
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
                      SizedBox(
                        height: 16.h,
                      ),
                      (widget.isProfile != null && widget.isProfile!)
                          ? const MyAppBar()
                          : Container(
                              height: 50.h,
                              padding: EdgeInsets.only(top: 8.h),
                              margin: EdgeInsets.only(top: 14.h, bottom: 8.h),
                              child: IconButton(
                                splashRadius: 20.w,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                iconSize: 40.w,
                                icon: SvgPicture.asset(
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
                                  border:
                                      Border.all(color: mainColor, width: 2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                height: 130.h,
                                width: 132.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child:

                                  widget.isProfile != null && widget.isProfile!?
                                  Image.memory(
                                    decodeImage(
                                        _cubit.user?.profilePicture ?? ''),
                                    errorBuilder: (context, error,
                                        stackTrace) =>
                                        Image.asset(
                                            'assets/images/profile_avatar_placeholder.png',
                                            fit: BoxFit.cover),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ):
                                  state is GetProfilePictureLoadingState?
                                    Center(child: CircularProgressIndicator())
                                        :
                                  Image.memory(

                                    decodeImage(
                                        _cubit.profileImage?? ''
                                    )

                                  ,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            'assets/images/profile_avatar_placeholder.png',
                                            fit: BoxFit.cover),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                              ),
                              if (widget.isProfile!)
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                            context: context,
                                            builder: (context) {
                                              return BlocBuilder(
                                                bloc: _cubit,
                                                builder: (context, state) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Scaffold(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      body: Dialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        insetPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.w,
                                                                vertical: 0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            width: 500.0.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        12.h,
                                                                    horizontal:
                                                                        14.w),
                                                            child: Form(
                                                              key: _cubit
                                                                  .formKey,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Edit Profile",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainColor,
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontFamily:
                                                                          "Cairo",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Text(
                                                                    "Change your profile picture",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainColor,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontFamily:
                                                                          "Cairo",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _cubit
                                                                          .pickImage();
                                                                    },
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              color: mainColor,
                                                                              width: 2),
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.r),
                                                                        ),
                                                                        height:
                                                                            130.h,
                                                                        width:
                                                                            132.h,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.r),
                                                                          child: _cubit.pickedImage != null
                                                                              ? Image.memory(
                                                                            decodeImage(_cubit.pickedImage!),
                                                                                  fit: BoxFit.cover,
                                                                            gaplessPlayback: true,
                                                                          )
                                                                              : Image.memory(
                                                                            decodeImage(
                                                                                _cubit.user?.profilePicture ?? ''),
                                                                            errorBuilder: (context, error,
                                                                                stackTrace) =>
                                                                                Image.asset(
                                                                                    'assets/images/profile_avatar_placeholder.png',
                                                                                    fit: BoxFit.cover),
                                                                                  fit: BoxFit.cover,
                                                                                  gaplessPlayback: true,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (_cubit
                                                                          .pickedImage !=
                                                                      null) ...[
                                                                    SizedBox(
                                                                      height:
                                                                          16.h,
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            55.h,
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            _cubit.updateProfileImage();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Save Image',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 14.sp),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  Divider(),
                                                                  Text(
                                                                    "Change your Password",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          mainColor,
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontFamily:
                                                                          "Cairo",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  TextFormField(
                                                                      controller:
                                                                          _cubit
                                                                              .currentPasswordController,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              mainColor),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(vertical: 0),
                                                                        // suffixIconConstraints:
                                                                        //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                                                        prefixIcon:
                                                                            Icon(CustomIcons.lock2),
                                                                        suffixIcon:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          type:
                                                                              MaterialType.circle,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          borderOnForeground:
                                                                              true,
                                                                          elevation:
                                                                              0,
                                                                          child:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                _cubit.currentPassword = !_cubit.currentPassword;
                                                                              });
                                                                            },
                                                                            icon: !_cubit.currentPassword
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
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        labelText:
                                                                            'Current Password',
                                                                        hintText:
                                                                            'Enter Your Current Password',
                                                                        errorMaxLines:
                                                                            3,
                                                                        hintStyle:
                                                                            TextStyle(color: Color(0xffc1c1c1)),
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.always,
                                                                      ),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .visiblePassword,
                                                                      obscureText:
                                                                          !_cubit
                                                                              .currentPassword,
                                                                      validator:
                                                                          validatePassword),
                                                                  SizedBox(
                                                                    height:
                                                                        25.h,
                                                                  ),
                                                                  TextFormField(
                                                                      controller:
                                                                          _cubit
                                                                              .newPasswordController,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              mainColor),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(vertical: 0),
                                                                        // suffixIconConstraints:
                                                                        //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                                                        prefixIcon:
                                                                            Icon(CustomIcons.lock2),
                                                                        suffixIcon:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          type:
                                                                              MaterialType.circle,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          borderOnForeground:
                                                                              true,
                                                                          elevation:
                                                                              0,
                                                                          child:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                _cubit.newPassword = !_cubit.newPassword;
                                                                              });
                                                                            },
                                                                            icon: !_cubit.newPassword
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
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        labelText:
                                                                            'New Password',
                                                                        hintText:
                                                                            'Enter Your New Password',
                                                                        errorMaxLines:
                                                                            3,
                                                                        hintStyle:
                                                                            TextStyle(color: Color(0xffc1c1c1)),
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.always,
                                                                      ),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .visiblePassword,
                                                                      obscureText:
                                                                          !_cubit
                                                                              .newPassword,
                                                                      validator:
                                                                          validatePassword),
                                                                  SizedBox(
                                                                    height:
                                                                        25.h,
                                                                  ),
                                                                  TextFormField(
                                                                      controller:
                                                                          _cubit
                                                                              .confirmNewPasswordController,
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              mainColor),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(vertical: 0),
                                                                        // suffixIconConstraints:
                                                                        //     BoxConstraints(maxHeight: 50.h, minWidth: 50.w),
                                                                        prefixIcon:
                                                                            Icon(CustomIcons.lock2),
                                                                        suffixIcon:
                                                                            Material(
                                                                          color:
                                                                              Colors.transparent,
                                                                          type:
                                                                              MaterialType.circle,
                                                                          clipBehavior:
                                                                              Clip.antiAlias,
                                                                          borderOnForeground:
                                                                              true,
                                                                          elevation:
                                                                              0,
                                                                          child:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                _cubit.confirmNewPassword = !_cubit.confirmNewPassword;
                                                                              });
                                                                            },
                                                                            icon: !_cubit.confirmNewPassword
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
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        labelText:
                                                                            'Confirm New Password',
                                                                        hintText:
                                                                            'ReEnter Your New Password',
                                                                        errorMaxLines:
                                                                            3,
                                                                        hintStyle:
                                                                            TextStyle(color: Color(0xffc1c1c1)),
                                                                        floatingLabelBehavior:
                                                                            FloatingLabelBehavior.always,
                                                                      ),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .visiblePassword,
                                                                      obscureText:
                                                                          !_cubit
                                                                              .confirmNewPassword,
                                                                      validator:
                                                                          (text) {
                                                                        if (text ==
                                                                                null ||
                                                                            text.isEmpty) {
                                                                          return 'Please enter password';
                                                                        } else if (text !=
                                                                            _cubit.newPasswordController.text) {
                                                                          return 'Confirmation password does not match with new password';
                                                                        } else {
                                                                          return null;
                                                                        }
                                                                      }),
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          55.h,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (_cubit
                                                                              .formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            _cubit.changePassword();
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Save Password',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 14.sp),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                },
                                              );
                                            })
                                        .whenComplete(
                                            () => _cubit.clearDialog());
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
                                  _cubit.user?.employeeName ?? '',
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
                                      _cubit.user?.email ?? '',
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
                                      _cubit.user?.phoneNumber ?? '',
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
                                      _cubit.user?.employeeNumber.toString() ??
                                          '',
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
                            _cubit.user?.birthDate ?? '',
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
                            _cubit.user?.gender ?? '',
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
                            _cubit.user?.workDuration ?? '',
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
                            _cubit.user?.maritalStatus ?? '',
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
                            _cubit.user?.departmentName ?? '',
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
                            _cubit.user?.collar ?? '',
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
                            _cubit.user?.sapNumber.toString() ?? '',
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
                            _cubit.user?.company ?? '',
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
                            _cubit.user?.joinDate ?? '',
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
                            _cubit.user?.address ?? '',
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
                            _cubit.user?.nationality ?? '',
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
                            _cubit.user?.supervisorName ?? '',
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
      },
    );
  }
}
