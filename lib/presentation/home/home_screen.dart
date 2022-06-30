import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../../core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
import '../../custom_icons.dart';
import '../notification/notification_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    PushNotificationService.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          drawer: const DrawerWidget(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h,),
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
                                padding: EdgeInsets.only(top:24.0.h),
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
                        style: TextStyle(color: Colors.white,fontSize: 14.sp,fontWeight: FontWeight.bold),
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
                    userData!.employeeName??'',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Joti',
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Chose your benefit card',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: greyColor,
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
                              child: Text("Available"),
                            ),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) =>
                          BenefitCard(benefit: cubit.benefitModels[index]),
                      itemCount: cubit.benefitModels.length,
                    ),
                    cubit.availableBenefitModels != null &&
                            cubit.availableBenefitModels?.length != 0
                        ? ListView.builder(
                            itemBuilder: (context, index) => BenefitCard(
                                benefit:
                                    cubit.availableBenefitModels![index]),
                            itemCount: cubit.availableBenefitModels?.length,
                          )
                        : Center(child: Text('No Benefits available')),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
