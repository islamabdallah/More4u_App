import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../../core/constants/constants.dart';
import '../../core/firebase/push_notification_service.dart';
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
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            iconSize: 35.h,
                            icon: SvgPicture.asset(
                              'assets/images/menu.svg',
                              // fit: BoxFit.cover,
                              width: 30.h,
                              height: 30.h,
                              color: mainColor,
                            ),
                          ),
                        );
                      }),
                      Badge(
                        position: BadgePosition(top: 10, end: 10),
                        badgeColor: redColor,
                        badgeContent: SizedBox(
                          width: 7.h,
                          height: 7.h,
                        ),
                        // badgeContent: Text('',style: TextStyle(fontSize: 12),),
                        child: Material(
                          borderRadius: BorderRadius.circular(100),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  NotificationScreen.routeName);
                            },
                            iconSize: 35,
                            icon: Icon(
                              Icons.notifications,
                              color: mainColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Hi Abanob',
                    style: TextStyle(
                        fontSize: 24,
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Chose your benifit card',
                    style: TextStyle(
                      fontSize: 16,
                      color: mainColor,
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
                      labelColor: mainColor,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      // indicatorPadding:  EdgeInsets.only(right: 20),
                      labelPadding: EdgeInsets.only(right: 25.w),
                      indicator: BoxDecoration(),
                      // indicator: CircleTabIndicator(color: Colors.black,radius:2.5),
                      tabs: [
                        Tab(
                          text: 'All',
                        ),
                        Tab(
                          text: 'Available',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      ListView.builder(
                        itemBuilder: (context, index) => BenefitCard(benefit: cubit.benefitModels[index]),
                        itemCount: cubit.benefitModels.length,
                      ),
                      cubit.availableBenefitModels != null &&
                              cubit.availableBenefitModels?.length != 0
                          ? ListView.builder(
                              itemBuilder: (context, index) => BenefitCard(benefit: cubit.availableBenefitModels![index]),
                              itemCount: cubit.availableBenefitModels?.length,
                            )
                          : Center(child: Text('No Benefits available')),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
