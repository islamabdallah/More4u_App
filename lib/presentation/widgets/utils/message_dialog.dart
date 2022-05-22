import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showMessageDialog({
  required BuildContext context,
  String? message,
  required bool isSucceeded,
  VoidCallback? onPressedOk,
  VoidCallback? onPressedRetry,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0.r)),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 250.h,
                  width: 372.w,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 60.h, 10.w, 20.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            isSucceeded ? 'Succeeded' : 'Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color:
                                  isSucceeded ? Colors.lightGreen : Colors.red,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            message??'Something went wrong!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.sp),
                            maxLines: 3,
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isSucceeded) ...[
                                SizedBox(
                                  width: 130.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      onPressedRetry?.call();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24.w,
                                ),
                              ],
                              SizedBox(
                                width: 130.w,
                                height: 50.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    onPressedOk?.call();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: isSucceeded
                                        ? Colors.lightGreen
                                        : Colors.red,
                                  ),
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ),
                Positioned(
                    top: -50.h,
                    child: isSucceeded
                        ? CircleAvatar(
                            backgroundColor: Colors.lightGreen,
                            radius: 50.r,
                            child: Icon(
                              Icons.verified_user,
                              color: Colors.white,
                              size: 50.h,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 50.r,
                            child: Icon(
                              Icons.privacy_tip,
                              color: Colors.white,
                              size: 50.h,
                            ),
                          )),
              ],
            )),
      );
    },
  );
}
