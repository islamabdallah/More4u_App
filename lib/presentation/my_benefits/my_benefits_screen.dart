import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
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
    _cubit = sl<MyBenefitsCubit>()..getMyBenefits();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);

    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {},
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
                              // Navigator.pushNamed(context,
                              //     NotificationScreen.routeName);
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
                          text: 'Pending',
                        ),
                        Tab(
                          text: 'InProgress',
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
                          itemBuilder: (context, index) => MyBenefitRequestCard(
                              benefit: _cubit.myAllBenefits[index]),
                          itemCount: _cubit.myAllBenefits.length,
                        )
                            : const Center(
                            child: Text('No Benefit available')),
                        _cubit.myPendingBenefits.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) => MyBenefitRequestCard(
                                    benefit: _cubit.myPendingBenefits[index]),
                                itemCount: _cubit.myPendingBenefits.length,
                              )
                            : const Center(
                                child: Text('No Pending Benefit available')),
                        _cubit.myInProgressBenefits.isNotEmpty
                            ? ListView.builder(
                          itemBuilder: (context, index) => MyBenefitRequestCard(
                              benefit: _cubit.myInProgressBenefits[index]),
                          itemCount: _cubit.myInProgressBenefits.length,
                        )
                            : const Center(
                            child: Text('No InProgress Benefit available')),
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
          ),
        );
      },
    );
  }

  Card MyBenefitRequestCard({required Benefit benefit}) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 5.0,
                  color: getBenefitStatusColor(benefit.lastStatus ?? '')),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            benefit.name,
                            style: TextStyle(
                              fontSize: 18,
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '(${benefit.lastStatus})',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: getBenefitStatusColor(
                                  benefit.lastStatus ?? ''),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.token,
                            size: 18,
                            color: mainColor,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            // benefit.benefitType,
                            benefit.benefitType,
                            style: TextStyle(color: mainColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${benefit.timesEmployeeReceiveThisBenefit}/${benefit.times}',
                        style: TextStyle(fontSize: 18, color: mainColor),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.visibility,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color getBenefitStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.indigo;
    case 'InProgress':
      return Colors.green;

    default:
      return Colors.red;
  }
}
