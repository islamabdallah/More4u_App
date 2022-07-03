import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../benefit_details/beneifit_detailed_screen.dart';
import '../benefit_redeem/BenefitRedeemScreen.dart';
import '../home/cubits/home_cubit.dart';

class BenefitCard extends StatelessWidget {
  final Benefit benefit;

  const BenefitCard({Key? key, required this.benefit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
      child: Container(
        // padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 2),
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8.r),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, BenefitDetailedScreen.routeName,
                arguments: benefit).whenComplete(() => HomeCubit.get(context).getHomeData());
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 9.0.w, color: mainColor),
              ),

              color: Colors.white,
              // borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r)),
                  child: Hero(
                    tag: benefit.id,
                    child: Image.asset(
                      'assets/images/hbd.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 9.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0),
                  child: Row(
                    children: [
                      Text(
                        benefit.name,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            color: greyColor),
                      ),
                      Spacer(),
                      benefit.benefitType == 'Group'
                          ? Icon(
                              CustomIcons.users_alt,
                            )
                          : Icon(
                              CustomIcons.individual,
                            ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        benefit.benefitType,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xff6d6d6d),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  indent: 16.w,
                  endIndent: 16.w,
                  color: Colors.black38,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 0),
                  child: Row(
                    children: [
                      Icon(CustomIcons.ph_arrows_counter_clockwise_duotone),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '${benefit.timesEmployeeReceiveThisBenefit}/${benefit.times}',
                        style: TextStyle(fontSize: 14.sp, color: greyColor, fontFamily: 'Roboto',),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 50.h,
                        width: 88.w,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: mainColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: benefit != null
                              ? (benefit.employeeCanRedeem
                                  ? () {
                                      Navigator.pushNamed(context,
                                          BenefitRedeemScreen.routeName,
                                          arguments: benefit).whenComplete(() => HomeCubit.get(context).getHomeData());
                                    }
                                  : null)
                              : null,
                          child: Text(
                            'Redeem',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 11.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
