import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more4u/custom_icons.dart';

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

class _BenefitDetailedScreenState extends State<BenefitDetailedScreen>
    with TickerProviderStateMixin {
  late BenefitDetailsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<BenefitDetailsCubit>()..benefit = widget.benefit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return BlocConsumer<BenefitDetailsCubit, BenefitDetailsState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is BenefitDetailsSuccessState) {
          print(_cubit.benefit);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                height: 1.sh,
                width: 1.sw,
                color: Colors.transparent,
              ),
              Hero(
                  tag: widget.benefit.id,
                  child: Image.asset('assets/images/hbd.png')),
              Positioned(
                top: 280.h,
                child: Container(
                  width: 1.sw,
                  height: 1.sh - 280.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            widget.benefit.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: mainColor),
                          ),
                          Spacer(),
                          Icon(CustomIcons.ph_arrows_counter_clockwise_duotone),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            '${widget.benefit.timesEmployeeReceiveThisBenefit}/${widget.benefit.times}',
                            style: TextStyle(fontSize: 14.sp, color: greyColor, fontFamily: 'Roboto',),
                          ),
                        ],
                      ),
                      Text(
                        _cubit.benefit?.description ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: mainColor),
                      ),
                      Theme(
                        data: ThemeData(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          unselectedLabelColor: Color(0xFF6D6D6D),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorPadding:
                              EdgeInsets.symmetric(vertical: 14.h),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: redColor),
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Conditions"),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Work Flow"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: false,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(right: 8.w),
                                  children: [
                                    conditionItem(
                                        prefix: _cubit.benefit?.benefitConditions
                                                    ?.type! ==
                                                'Individual'
                                            ? CustomIcons.user
                                            : CustomIcons.users_alt,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.type ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Type',
                                        value: _cubit
                                            .benefit?.benefitConditions?.type),
                                    conditionItem(
                                        prefix: CustomIcons.stats,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.age ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Age',
                                        value:
                                            _cubit.benefit?.benefitConditions?.age),
                                    conditionItem(
                                        prefix: CustomIcons.clock,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.workDuration ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'WorkDuration',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.workDuration),
                                    conditionItem(
                                        prefix: Icons.event_available,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.dateToMatch ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Date To Match',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.dateToMatch),
                                    conditionItem(
                                        prefix: CustomIcons.venus_mars,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.gender ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Gender',
                                        value: _cubit
                                            .benefit?.benefitConditions?.gender),
                                    conditionItem(
                                        prefix: CustomIcons.bitmap,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.maritalStatus ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Marital Status',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.maritalStatus),
                                    conditionItem(
                                        prefix: Icons.trending_down,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.minParticipant ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'Min Participants',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.minParticipant),
                                    conditionItem(
                                        prefix: Icons.trending_up,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.maxParticipant ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'maxParticipant',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.maxParticipant),
                                    conditionItem(
                                        prefix: CustomIcons.person_solid,
                                        suffix: _cubit.benefit?.benefitApplicable
                                                    ?.payrollArea ==
                                                true
                                            ? CustomIcons.circle_check_regular
                                            : CustomIcons.circle_xmark_regular,
                                        label: 'payrollArea',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.payrollArea),
                                    conditionItem(
                                        prefix: CustomIcons.document,
                                        suffix: CustomIcons.loading,
                                        label: 'Required Documents',
                                        value: _cubit.benefit?.benefitConditions
                                            ?.requiredDocuments),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.white,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return IntrinsicHeight(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 30,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: whiteGreyColor,
                                                  width: 3.0,
                                                ),
                                              ),
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: whiteGreyColor),
                                              ),
                                            ),
                                            if (index <
                                                _cubit
                                                        .benefit!
                                                        .benefitWorkflows!
                                                        .length -
                                                    1)
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2.h),
                                                  height: 30.h,
                                                  width: 2.w,
                                                  color: whiteGreyColor,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_cubit.benefit!
                                                .benefitWorkflows![index]),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount:
                                    _cubit.benefit!.benefitWorkflows!.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //todo add && widget.benefit.isInProggress
                      if(widget.benefit.times==widget.benefit.timesEmployeeReceiveThisBenefit)
                      Row(
                      mainAxisAlignment: MainAxisAlignment.center
                      ,children: [
                        Icon(CustomIcons.exclamation,color: redColor,),
                        SizedBox(width: 3.w,),
                        Text(
                          "You did used this card before",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: redColor,
                            fontSize: 12.sp,
                          ),
                        )
                      ],),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: 187.w,
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
                                child: Text('Redeem')),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget conditionItem(
      {required String label,
      String? value,
      required IconData prefix,
      required IconData suffix}) {
    return value != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(prefix, color: mainColor, size: 18),
                SizedBox(
                  width: 4.w,
                ),
                Expanded(
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '$label   ',
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: greyColor,
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Icon(
                  suffix,
                  size: 18,
                  color: suffix == CustomIcons.circle_check_regular
                      ? Colors.green
                      : suffix == CustomIcons.loading
                          ? Colors.orange
                          : redColor,
                )
              ],
            ),
          )
        : const SizedBox();
  }

  Widget horizontalWorkStepper(int index) {
    return IntrinsicWidth(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
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
