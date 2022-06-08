import 'package:flutter/cupertino.dart';
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                      tag: widget.benefit.id,
                      child: Image.asset('assets/images/hbd.png')),
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
                  // SizedBox(
                  //   height: 100,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Stepper(
                  //       physics: ClampingScrollPhysics(),
                  //       margin: EdgeInsets.all(16),
                  //       currentStep: 1,
                  //       steps: [
                  //         Step(title: Text('test'), content: SizedBox()),
                  //         Step(title: Text('test'), content: SizedBox()),
                  //       ],
                  //       controlsBuilder: (context, _) {
                  //         return SizedBox();
                  //       },
                  //       type: StepperType.horizontal,
                  //       elevation: 0,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23.w),
                    child: SizedBox(
                      height: 75.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return horizontalWorkStepper(index);
                        },
                        itemCount: _cubit.benefit!.benefitWorkflows!.length,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 23.w),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (_cubit.benefit?.benefitWorkflows != null)
                  //         for (var item in _cubit.benefit!.benefitWorkflows!)
                  //           Text(
                  //             item,
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.normal,
                  //                 fontSize: 16,
                  //                 color: mainColor),
                  //           ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: _cubit.benefit != null
                              ? (_cubit.benefit!.employeeCanRedeem
                                  ? () {
                                      Navigator.pushNamed(context,
                                          BenefitRedeemScreen.routeName,
                                          arguments: widget.benefit);
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

  Widget horizontalWorkStepper(int index) {
    return IntrinsicWidth (
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text('${index + 1}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                radius: 15,
              ),
              if (index < _cubit.benefit!.benefitWorkflows!.length - 1)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    height: 0.5,
                    width: 50,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 8,
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(_cubit.benefit!.benefitWorkflows![index]),
          ),
        ],
      ),
    );
  }
}
