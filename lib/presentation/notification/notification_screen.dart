import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    _cubit = sl<NotificationCubit>()..getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          // backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text('Notifications'),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: _cubit.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 100.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          child: Material(
                            borderRadius: BorderRadius.circular(16.0.r),
                            elevation: 4.r,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0.r)),
                              tileColor: Colors.white,
                              title: Text(_cubit
                                      .notifications[index].notificationType ??
                                  ''),
                              leading: Icon(
                                Icons.circle_notifications,
                                size: 70.r,
                              ),
                              trailing: Row(
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
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
