import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/benefit.dart';
import 'cubits/benefit_details_cubit.dart';
import '../../core/constants/constants.dart';
import '../../injection_container.dart';
import '../benefit_redeem/BenefitRedeemScreen.dart';

class BenefitDetailedScreen extends StatefulWidget {
  static const routeName = 'BenefitDetailedScreen';
  final Benefit benefit;

  const BenefitDetailedScreen({Key? key, required this.benefit})
      : super(key: key);

  @override
  _BenefitDetailedScreenState createState() => _BenefitDetailedScreenState();
}

class _BenefitDetailedScreenState extends State<BenefitDetailedScreen> {
  late BenefitDetailsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<BenefitDetailsCubit>()..benefit = widget.benefit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BenefitDetailsCubit, BenefitDetailsState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is BenefitDetailsSuccessState) {
          print(_cubit.benefit);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/hbd.png'),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: mainColor),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Text(
                      _cubit.benefit?.description ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: mainColor),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Text(
                      'Conditions',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: mainColor),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_cubit.benefit?.benefitConditions != null)
                          for (var item in _cubit.benefit!.benefitConditions!)
                            Text(
                              item,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: mainColor),
                            ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Text(
                      'Work Flow',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: mainColor),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_cubit.benefit?.benefitWorkflows != null)
                          for (var item in _cubit.benefit!.benefitWorkflows!)
                            Text(
                              item,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: mainColor),
                            ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: _cubit.benefit != null
                              ? (_cubit.benefit!.employeeCanRedeem
                                  ? () {
                                      Navigator.pushNamed(context,
                                          BenefitRedeemScreen.routeName,arguments: widget.benefit);
                                    }
                                  : null)
                              : null,
                          child: Text('Redeem')))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
