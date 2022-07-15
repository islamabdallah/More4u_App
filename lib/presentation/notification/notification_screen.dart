import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/manage_requests/manage_requests_screen.dart';
import 'package:more4u/presentation/widgets/utils/loading_dialog.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/constants.dart';
import '../../injection_container.dart';
import 'cubits/notification_cubit.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = 'NotificationScreen';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationCubit _cubit;

  @override
  void initState() {
    _cubit = sl<NotificationCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetNotificationsLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetNotificationsSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetNotificationsErrorState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context, isSucceeded: false, message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 60.h,),
                Container(
                  height: 50.h,
                  padding: EdgeInsets.only(top: 8.h),
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

                SizedBox(height: 8.h,),
                Text(
                  'Notifications',
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontFamily: 'Joti',
                      color: mainColor,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: _cubit.notifications.isNotEmpty ?
                  ListView.separated(
                    padding: EdgeInsets.only(top: 16.h),
                    itemCount: _cubit.notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          if (_cubit
                              .notifications[index].notificationType ==
                              'Request') {
                            final completer = Completer();

                            final result = await Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) =>
                                ManageRequestsScreen(requestNumber: _cubit
                                    .notifications[index].requestNumber!,),),result: completer.future);
                            completer.complete(result);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: mainColor, width: 2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 70.w,
                              width: 70.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_cubit
                                    .notifications[index].employeeFullName ??
                                    '', style: TextStyle(
                                    color: mainColor,
                                    fontSize: 13.sp,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold
                                ),
                                ),
                                Text(_cubit
                                    .notifications[index].message ??
                                    '', style: TextStyle(
                                  color: greyColor,
                                  fontSize: 13.sp,
                                  fontFamily: "Roboto",
                                ),
                                ),
                                Text(_cubit
                                    .notifications[index].requestNumber.toString() ??
                                    '', style: TextStyle(
                                  color: greyColor,
                                  fontSize: 13.sp,
                                  fontFamily: "Roboto",
                                ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        size: 22.r,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(timeago.format(DateTime.parse(
                                          _cubit.notifications[index].date!)))
                                    ],
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  )
                      :
                  const Center(child: Text('No Notifications')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
