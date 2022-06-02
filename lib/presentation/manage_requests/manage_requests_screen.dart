import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/entities/user.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import 'cubits/manage_requests_cubit.dart';

class ManageRequestsScreen extends StatefulWidget {
  static const routeName = 'ManageRequestsScreen';

  const ManageRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  late ManageRequestsCubit _cubit;

  @override
  void initState() {
    // _cubit = sl<ManageRequestsCubit>();
    _cubit = sl<ManageRequestsCubit>()..getBenefitsToManage();
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
          resizeToAvoidBottomInset: false,
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
                    'Requests',
                    style: TextStyle(
                        fontSize: 20,
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  // requestCard(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        requestCard(_cubit.benefitRequests[index]),
                    itemCount: _cubit.benefitRequests.length,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Card requestCard(BenefitRequest request) {
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
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        color: mainColor,
                        child: const Center(
                          child: Text(
                            'Request Information',
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
                              title: Text('From: ${request.from ?? ''}'),
                            ),
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.calendar_today_outlined),
                              title: Text('From: ${request.to ?? ''}'),
                            ),
                            ListTile(
                              dense: true,
                              leading: Icon(Icons.messenger),
                              title: Text('From: ${request.message ?? ''}'),
                            ),
                            ListTile(
                              onTap: () {
                                showInfo(context, request.createdBy!);
                              },
                              dense: true,
                              leading: const Icon(Icons.person),
                              title: Text(
                                  'created by: ${request.createdBy?.employeeName}'),
                            ),
                            if (request.fullParticipantsData != null)
                              ListTile(
                                onTap: () {
                                  List<User> participants =
                                      request.fullParticipantsData!;
                                  showDialog(
                                    barrierColor: Colors.transparent,
                                    context: _,
                                    builder: (_) {
                                      return Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(20),
                                              color: mainColor,
                                              child: const Center(
                                                child: Text(
                                                  'Participants',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: participants.length,
                                              itemBuilder: (_, index) =>
                                                  ListTile(
                                                onTap: () {
                                                  showInfo(context,
                                                      participants[index]);
                                                },
                                                dense: true,
                                                leading: Icon(Icons.person),
                                                title: Text(
                                                    'name: ${participants[index].employeeName ?? ''}'),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                dense: true,
                                leading: const Icon(Icons.group),
                                title: Text(
                                    'Participants: ${request.fullParticipantsData!.map((e) => e.employeeName)}'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Text(
                    'Number:',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${request.requestNumber}',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Requested at:',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    request.requestedAt ?? '',
                    style: TextStyle(color: mainColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    request.status ?? '',
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Required Date:',
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    request.from ?? '',
                    style: TextStyle(color: mainColor),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        acceptOrReject(false);
                      },
                      child: Text('Reject'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        acceptOrReject(true);
                      },
                      child: Text('Accept'),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  acceptOrReject(bool isAccepted) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  label: Text('notes'),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text('Confirm'),
                    style: ElevatedButton.styleFrom(primary: mainColor),
                  ))
            ],
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

showInfo(BuildContext context, User user) {
  showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Dialog(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: mainColor,
              child: const Center(
                child: Text(
                  'Employee Information',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('name: ${user.employeeName ?? ''}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('employeeNumber: ${user.employeeNumber}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('departmentName: ${user.departmentName ?? ''}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('supervisorName: ${user.supervisorName ?? ''}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.person),
              title: Text('Join date: ${user.joinDate}'),
            ),
          ]),
        );
      });
}
