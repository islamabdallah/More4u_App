import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';
import 'package:more4u/presentation/widgets/banner.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../manage_requests/manage_requests_screen.dart';
import '../notification/notification_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/utils/loading_dialog.dart';
import 'cubits/my_benefits_cubit.dart';

class MyBenefitsScreen extends StatefulWidget {
  static const routeName = 'MyBenefitsScreen';

  const MyBenefitsScreen({Key? key}) : super(key: key);

  @override
  State<MyBenefitsScreen> createState() => _MyBenefitsScreenState();
}

class _MyBenefitsScreenState extends State<MyBenefitsScreen>
    with TickerProviderStateMixin {
  late MyBenefitsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyBenefitsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getMyBenefits();
    });

    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 5, vsync: this);

    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {

        if(state is GetMyBenefitsLoadingState){
          loadingAlertDialog(context);
        }
        if(state is GetMyBenefitsSuccessState){
          Navigator.pop(context);
        }

      },
      builder: (context, state) {
        return Scaffold(
          drawer: const DrawerWidget(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(builder: (context) {
                      return Material(
                        borderRadius: BorderRadius.circular(100),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          iconSize: 45.w,
                          icon: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/images/cadeau.png'),
                              Padding(
                                padding: EdgeInsets.only(top: 24.0.h),
                                child: SvgPicture.asset(
                                  'assets/images/menu.svg',
                                  // fit: BoxFit.cover,
                                  width: 25.h,
                                  height: 25.h,
                                  color: mainColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Badge(
                      position: BadgePosition(bottom: -2, end: 3),
                      badgeColor: redColor,
                      // badgeContent: SizedBox(
                      //   width: 12.h,
                      //   height: 12.h,
                      // ),
                      padding: EdgeInsets.all(8.r),
                      badgeContent: Text(
                        '3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(150.r),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, NotificationScreen.routeName);
                          },
                          iconSize: 30.w,
                          icon: SimpleShadow(
                              offset: Offset(0, 4),
                              color: Colors.black.withOpacity(0.25),
                              child: Icon(
                                CustomIcons.bell,
                                color: mainColor,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'My Requests',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Joti',
                        color: redColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 25.h),
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
                    indicatorPadding: EdgeInsets.symmetric(vertical: 14.h),
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
                            child: Text("All"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Pending"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("InProgress"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Approved"),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Rejected"),
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
                      _cubit.myAllBenefits.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => myBenefitCard(
                                  benefit: _cubit.myAllBenefits[index]),
                              itemCount: _cubit.myAllBenefits.length,
                            )
                          : const Center(child: Text('No Benefit available')),
                      _cubit.myPendingBenefits.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => myBenefitCard(
                                  benefit: _cubit.myPendingBenefits[index]),
                              itemCount: _cubit.myPendingBenefits.length,
                            )
                          : const Center(
                              child: Text('No Benefit available')),
                      _cubit.myInProgressBenefits.isNotEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => myBenefitCard(
                                  benefit: _cubit.myInProgressBenefits[index]),
                              itemCount: _cubit.myInProgressBenefits.length,
                            )
                          : const Center(
                              child: Text('No Benefit available')),

                      _cubit.myApprovedBenefits.isNotEmpty
                          ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => myBenefitCard(
                            benefit: _cubit.myApprovedBenefits[index]),
                        itemCount: _cubit.myApprovedBenefits.length,
                      )
                          : const Center(
                          child: Text('No Benefit available')),

                      _cubit.myRejectedBenefits.isNotEmpty
                          ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => myBenefitCard(
                            benefit: _cubit.myRejectedBenefits[index]),
                        itemCount: _cubit.myRejectedBenefits.length,
                      )
                          : const Center(
                          child: Text('No Benefit available')),


                    ],
                  ),
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) =>
                //       MyBenefitRequestCard(_cubit.myAllBenefits[index]),
                //   itemCount: _cubit.myAllBenefits.length,
                // )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myBenefitCard({required Benefit benefit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, MyBenefitRequestsScreen.routeName,
                arguments: benefit).whenComplete(() =>
                _cubit.getMyBenefits()
            );
          },
          child: MyBanner(
            message: '${benefit.lastStatus}',
            textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
            location: BannerLocation.topEnd,
            color: getBenefitStatusColor(benefit.lastStatus ?? ''),
            child: Stack(
              children: [
                Positioned(
                    right: 5,
                    top: 2,
                    child: Icon(benefit.benefitType == 'Group'
                        ? CustomIcons.users_alt
                        : CustomIcons.user)),
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 5.0,
                        color: getBenefitStatusColor(benefit.lastStatus ?? ''),
                      ),
                      right: BorderSide(
                        width: 2.0,
                        color:Color(0xFFE7E7E7),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              // border: Border.all()
                              ),
                          child: Image.asset(
                            'assets/images/hbd.png',
                            fit: BoxFit.fill,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  benefit.name,
                                  style: TextStyle(
                                    color: mainColor,
                                    fontSize: 14.sp,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.token,
                              //       size: 18,
                              //       color: mainColor,
                              //     ),
                              //     SizedBox(
                              //       width: 4,
                              //     ),
                              //     Text(
                              //       // benefit.benefitType,
                              //       benefit.benefitType,
                              //       style: TextStyle(color: mainColor),
                              //     ),
                              //   ],
                              // ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(CustomIcons
                                        .ph_arrows_counter_clockwise_duotone),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      '${benefit.timesEmployeeReceiveThisBenefit}/${benefit.times}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Roboto",
                                          color: greyColor),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      '7 Requests',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: "Roboto",
                                          color: greyColor),
                                    ),
                                    Spacer(),
                                    Icon(Icons.arrow_circle_right, size: 30.r),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
