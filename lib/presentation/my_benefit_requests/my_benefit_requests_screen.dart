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
import '../home/home_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';
import '../widgets/utils/message_dialog.dart';

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
                        request: _cubit.myBenefitRequests[index]),
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

  Card myBenefitRequestCard({required BenefitRequest request}) {
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
                  insetPadding:EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0) ,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            color: mainColor,
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
                                  title: Text(request.from ?? ''),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.calendar_today_outlined),
                                  title: Text(request.to ?? ''),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Icon(Icons.messenger),
                                  title: Text(request.message ?? ''),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (request.requestWorkFlowAPIs != null &&
                            request.requestWorkFlowAPIs!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            color: mainColor,
                            child: const Center(
                              child: Text(
                                'Request WorkFlow',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return IntrinsicHeight(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: getBenefitStatusColor(
                                                request.requestWorkFlowAPIs![index]
                                                    .statusString),
                                            radius: 15,
                                            child: request
                                                        .requestWorkFlowAPIs![index]
                                                        .statusString ==
                                                    'Pending'
                                                ? Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                  )
                                                : request
                                                            .requestWorkFlowAPIs![
                                                                index]
                                                            .statusString ==
                                                        'Approved'
                                                    ? const Icon(Icons.check)
                                                    : const Icon(Icons.close),
                                          ),
                                          if (index <
                                              request.requestWorkFlowAPIs!.length -
                                                  1)
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.symmetric(vertical: 8),
                                                height: 50,
                                                width: 0.5,
                                                color: Colors.black,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(request.requestWorkFlowAPIs![index]
                                                    .employeeName ??
                                                ''),
                                            Text(request.requestWorkFlowAPIs![index]
                                                    .statusString ??
                                                ''),
                                            SizedBox(height: 8,),
                                            Text(request.requestWorkFlowAPIs![index]
                                                    .notes ??
                                                ''),
                                            if(index==0)
                                            Text('asdasdasdasdasdadadsada')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: request.requestWorkFlowAPIs!.length,
                            ),
                          ),
                          // for (var x in request.requestWorkFlowAPIs!)
                          //   Container(
                          //     width: double.infinity,
                          //     color: Colors.white,
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(x.employeeName!),
                          //         Text(x.statusString),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      ],
                    ),
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 5.0,
                  color: getBenefitStatusColor(request.statusString)),
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
                            request.requestNumber.toString(),
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
                            request.benefitType ?? '',
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
                                color: mainColor, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            // benefit.benefitType,
                            request.statusString,
                            style: TextStyle(
                                color: getBenefitStatusColor(
                                    request.statusString)),
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
                    if (request.canEdit != null && request.canEdit!)
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
                    if (request.canCancel != null && request.canCancel!)
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
                                  content: Text(
                                      "Are you sure you want to cancel this request?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Ok"),
                                      onPressed: () {
                                        showMessageDialog(
                                          context: context,
                                          isSucceeded: true,
                                          message: 'Request Cancled!',
                                          onPressedOk: () {
                                            Navigator.popUntil(
                                                context,
                                                ModalRoute.withName(
                                                    HomeScreen.routeName));
                                          },
                                        );
                                      },
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

// Widget horizontalWorkStepper(int index) {
//   return IntrinsicWidth (
//     child: Column(
//       // mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//
//       children: [
//         Row(
//           // mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.green,
//               child: Text('${index + 1}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//               radius: 15,
//             ),
//             if (index < _cubit.myBenefitRequests[1].requestWorkFlowAPIs!.length)
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 8),
//                   height: 0.5,
//                   width: 50,
//                   color: Colors.black,
//                 ),
//               ),
//           ],
//         ),
//         SizedBox(
//           height: 8,
//         ),
//
//         Padding(
//           padding: const EdgeInsets.only(right: 16),
//           child: Text(_cubit.benefit!.benefitWorkflows![index]),
//         ),
//       ],
//     ),
//   );
// }

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
