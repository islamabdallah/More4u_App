import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../../core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
import '../../core/utils/app_lifecycle.dart';
import '../../custom_icons.dart';
import '../notification/notification_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/privilege_card.dart';
import '../widgets/utils/loading_dialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if(state == AppLifecycleState.resumed && ModalRoute.of(context)?.isCurrent!=null&&ModalRoute.of(context)!.isCurrent){
    //   print(ModalRoute.of(context)?.isCurrent);
    //   print(ModalRoute.of(context)?.settings.name);
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        Future.delayed(
            Duration(milliseconds: 800), () => HomeCubit.get(context).getHomeData());
      }
    }
  }


  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async {
          // HomeCubit.get(context).getHomeData();
        },
        suspendingCallBack: () async {}));
    PushNotificationService.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    var _cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
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
                const MyAppBar(),
                Padding(
                  padding: EdgeInsets.only(right: 50.w),
                  child: AutoSizeText(
                    userData!.employeeName ?? '',
                    maxLines: 1,
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
                      onTap: (index) {
                        if (index == 2) {
                          _cubit.getPrivileges();
                        }
                      },
                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("All (${_cubit.benefitModels.length})"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Available (${_cubit.availableBenefitModels?.length??'0'})"),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Privileges (${_cubit.priviligesCount})"),
                            ),
                          ),
                        ),
                      ]),
                ),


                  Padding(
                    padding: EdgeInsets.only( top: 8.h,bottom: 16.h,left: 8.w,right: 8.w),
                    child:
                    Center(
                        child:

                     state is GetHomeDataLoadingState?
                     LinearProgressIndicator(
                          minHeight: 2.h,
                          backgroundColor: mainColor.withOpacity(0.4),
                        ):SizedBox(
                       height: 2.h,
                     ),
          ),
                  ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) =>
                          BenefitCard(benefit: _cubit.benefitModels[index]),
                      itemCount: _cubit.benefitModels.length,
                    ),
                    _cubit.availableBenefitModels != null &&
                        _cubit.availableBenefitModels?.length != 0
                        ? ListView.builder(
                      itemBuilder: (context, index) =>
                          BenefitCard(
                              benefit: _cubit.availableBenefitModels![index]),
                      itemCount: _cubit.availableBenefitModels?.length,
                    )
                        : Center(child: Text('No Benefits available')),
                    _cubit.privileges.isNotEmpty
                        ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) =>
                          PrivilegeCard(
                              privilege: _cubit.privileges[index]),
                      itemCount: _cubit.privileges.length,
                    ):
                    state is GetPrivilegesLoadingState?
                    Center(child: CircularProgressIndicator())
                        : Center(child: Text('No Privileges available')),
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
