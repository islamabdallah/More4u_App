import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/my_benefit_requests/cubits/my_benefit_requests_cubit.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/benefit.dart';
import '../../domain/entities/benefit_request.dart';
import '../../injection_container.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';

class MyBenefitRequestsScreen extends StatefulWidget {
  static const routeName = 'MyBenefitRequestsScreen';

  final int benefitId;

  const MyBenefitRequestsScreen({Key? key, required this.benefitId})
      : super(key: key);

  @override
  State<MyBenefitRequestsScreen> createState() =>
      _MyBenefitRequestsScreenState();
}

class _MyBenefitRequestsScreenState extends State<MyBenefitRequestsScreen> {
  late MyBenefitRequestsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyBenefitRequestsCubit>()
      ..getMyBenefitRequests(widget.benefitId);
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => myBenefitRequestCard(
                        myBenefitRequest: _cubit.myBenefitRequests[index]),
                    itemCount: _cubit.myBenefitRequests.length,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Card myBenefitRequestCard({required BenefitRequest myBenefitRequest}) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          color: Colors.blue[900],
                          child: const Center(
                            child: Text(
                              'Request Information',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                dense: true,
                                leading: Icon(Icons.hourglass_bottom),
                                title: Text(myBenefitRequest.from??''),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(Icons.calendar_today_outlined),
                                title: Text(myBenefitRequest.to??''),
                              ),
                              ListTile(
                                dense: true,
                                leading: Icon(Icons.messenger),
                                title: Text(myBenefitRequest.message ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (myBenefitRequest.requestWorkFlowAPIs != null &&
                          myBenefitRequest.requestWorkFlowAPIs!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          color: Colors.blue[900],
                          child: const Center(
                            child: Text(
                              'Request WorkFlow',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        for (var x in myBenefitRequest.requestWorkFlowAPIs!)
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(x.employeeName!),
                                Text(x.statusString),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 5.0,
                  color: getBenefitStatusColor(myBenefitRequest.statusString)),
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
                            'Number',
                            style: TextStyle(
                              fontSize: 18,
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '100',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
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
                            myBenefitRequest.statusString,
                            style: TextStyle(color: mainColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    if (myBenefitRequest.canEdit != null &&
                        myBenefitRequest.canEdit!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {},
                              splashRadius: 22,
                              icon: Icon(
                                Icons.edit,
                                size: 22,
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (myBenefitRequest.canCancel != null &&
                        myBenefitRequest.canCancel!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                AlertDialog alert = AlertDialog(
                                  title: Text("Cancel Request"),
                                  content: Text("Are you sure you want to cancel this request?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Ok"),
                                      onPressed: () {},
                                    ),
                                  ],
                                );

                                // show the dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                              splashRadius: 22,
                              icon: Icon(
                                Icons.delete,
                                size: 22,
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
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
    case 'Approved':
      return Colors.green;

    default:
      return Colors.red;
  }
}
