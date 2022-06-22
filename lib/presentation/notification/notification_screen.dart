import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = 'NotificationScreen';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('Notifications'),),
      body:Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  horizontalOffset: 100.0,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 16.w),
                      child: Material(
                        borderRadius:  BorderRadius.circular(16.0.r),
                        elevation: 4.r,
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0.r)),
                          tileColor: Colors.white,
                          title: Text("العنوان"),
                          subtitle: Text('الرسالة'),
                          leading: Icon(Icons.circle_notifications,size: 70.r,),
                          trailing: Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.alarm,size: 22.r,),SizedBox(width: 5.w,),Text(' منذ 2 أيام')],),
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
  }
}
