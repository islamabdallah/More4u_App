import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoweredByCemex extends StatelessWidget {
  const PoweredByCemex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Powered by",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontFamily: "Roboto",
          ),
        ),
        Image.asset(
          'assets/images/cemex.jpg',
          width: 100.w,
          height: 35.h,
          fit: BoxFit.fitWidth,
        )
      ],
    );
  }
}
