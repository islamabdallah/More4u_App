import 'package:badges/badges.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/my_benefit_requests/cubits/my_benefit_requests_cubit.dart';
import 'package:more4u/presentation/widgets/banner.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../domain/entities/benefit_request.dart';
import '../../injection_container.dart';
import '../home/home_screen.dart';
import '../manage_requests/manage_requests_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';
import '../widgets/helpers.dart';
import '../widgets/selection_chip.dart';
import '../widgets/utils/message_dialog.dart';

class MyBenefitRequestsScreen extends StatefulWidget {
  static const routeName = 'MyBenefitRequestsScreen';

  final Benefit benefit;

  const MyBenefitRequestsScreen({Key? key, required this.benefit})
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
      ..getMyBenefitRequests(widget.benefit.id);
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/hbd.png'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.benefit.name,
                      style: TextStyle(
                          fontSize: 24,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return dialog(request);
              });
        },
        child: MyBanner(
          message: '${request.status}',
          textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
          location: BannerLocation.topEnd,
          color: getBenefitStatusColor(request.status ?? ''),
          child: Stack(
            children: [
              Positioned(
                  right: 5,
                  top: 2,
                  child: Icon(request.benefitType == 'Group'
                      ? CustomIcons.users_alt
                      : CustomIcons.user)),
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 5.0,
                        color: getBenefitStatusColor(request.status ?? '')),
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
                                    fontSize: 14.sp,
                                    color: greyColor,
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
                                    color: greyColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(CustomIcons.clock),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  //todo chahe to time ago
                                  '1 hour ago',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "Roboto",
                                      color: greyColor),
                                ),
                                Spacer(),
                                if (request.canCancel != null &&
                                    request.canCancel!)
                                  SizedBox(
                                    height: 30.h,
                                    width: 30.w,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: redColor,padding: EdgeInsets.zero),
                                      child: Center(child: Icon(CustomIcons.trash,size: 20.r,)),
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
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.arrow_circle_right, size: 30.r),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
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
      ),
    );
  }

  Widget dialog(BenefitRequest request) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
          child: SingleChildScrollView(
            child: MeasureSize(
              onChange: (Size size) {
                print('MeasuredSize: $size');
                _cubit.setChildSized(size);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: MyBanner(
                      message: '${request.status}',
                      textStyle: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w600),
                      location: BannerLocation.topEnd,
                      color: getBenefitStatusColor(request.status ?? ''),
                      child: Container(
                        width: 500.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 14.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: Color(0xFFE7E7E7),
                                  )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.asset('assets/images/hbd.png'),
                              ),
                            ),
                            Text(
                              widget.benefit.name,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.createdBy?.employeeName ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: greyColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Type: ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.benefitType ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'From: ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.from ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: greyColor,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'To: ',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: greyColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request.to ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: greyColor,
                                  ),
                                ),
                              ],
                            ),
                            if (request.message != null)
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Message: ',
                                    style: TextStyle(
                                        color: greyColor,
                                        fontSize: 16.sp,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: request.message,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: greyColor,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ]),
                              ),
                            SizedBox(
                              height: 4.h,
                            ),
                            if (request.participantsData?.isNotEmpty ??
                                false) ...[
                              Text(
                                'Participants: ',
                                style: TextStyle(
                                    color: greyColor,
                                    fontSize: 14.sp,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold),
                              ),
                              Center(
                                child: Wrap(
                                  children: [
                                    ...request.participantsData!
                                        .map((participant) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.w),
                                              child: Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  side: BorderSide(
                                                      color: Color(0xFFC1C1C1)),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                label:
                                                    Text(participant.fullName),
                                                labelStyle: TextStyle(
                                                    color: mainColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp),
                                              ),
                                            ))
                                        .toList()
                                  ],
                                ),
                              ),
                            ],
                            if (request.requestWorkFlowAPIs != null &&
                                request.requestWorkFlowAPIs!.isNotEmpty)
                              ListView.builder(
                                padding: EdgeInsets.only(top: 14.h),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
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
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: request
                                                          .requestWorkFlowAPIs![
                                                              index]
                                                          .status ==
                                                      'Pending'
                                                  ? Container(
                                                      width: 30,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: whiteGreyColor,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                      child: Icon(
                                                        CustomIcons
                                                            .hourglass_end,
                                                        color: whiteGreyColor,
                                                        size: 15,
                                                      ),
                                                    )
                                                  : request
                                                              .requestWorkFlowAPIs![
                                                                  index]
                                                              .status ==
                                                          'Approved'
                                                      ? Icon(
                                                          CustomIcons
                                                              .circle_check_regular,
                                                          color:
                                                              Color(0xFF00ED51),
                                                          size: 30,
                                                        )
                                                      : request
                                                                  .requestWorkFlowAPIs![
                                                                      index]
                                                                  .status ==
                                                              'Rejected'
                                                          ? const Icon(
                                                              CustomIcons
                                                                  .circle_xmark_regular,
                                                              color: Color(
                                                                  0xFFE01B2B),
                                                              size: 30,
                                                            )
                                                          : Container(
                                                              width: 30,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      whiteGreyColor,
                                                                  width: 3.0,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '${index + 1}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        whiteGreyColor),
                                                              ),
                                                            ),
                                            ),
                                            if (index <
                                                request.requestWorkFlowAPIs!
                                                        .length -
                                                    1)
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 2.h),
                                                  height: 30.h,
                                                  width: 2.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        request
                                                                    .requestWorkFlowAPIs![
                                                                        index]
                                                                    .status ==
                                                                'Approved'
                                                            ? Colors.green
                                                            : request
                                                                        .requestWorkFlowAPIs![
                                                                            index]
                                                                        .status ==
                                                                    'Rejected'
                                                                ? Colors.red
                                                                : whiteGreyColor,
                                                        request
                                                                    .requestWorkFlowAPIs![
                                                                        index +
                                                                            1]
                                                                    .status ==
                                                                'Approved'
                                                            ? Colors.green
                                                            : request
                                                                        .requestWorkFlowAPIs![
                                                                            index +
                                                                                1]
                                                                        .status ==
                                                                    'Rejected'
                                                                ? Colors.red
                                                                : whiteGreyColor,
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                request
                                                        .requestWorkFlowAPIs![
                                                            index]
                                                        .employeeName ??
                                                    '',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto'),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      request
                                                              .requestWorkFlowAPIs![
                                                                  index]
                                                              .status ??
                                                          '',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto')),
                                                  //todo fix this
                                                  // Text('at ${request.requestWorkFlowAPIs![index].replayDate}'),
                                                ],
                                              ),
                                              Text(
                                                  request
                                                          .requestWorkFlowAPIs![
                                                              index]
                                                          .notes ??
                                                      '',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: request.requestWorkFlowAPIs!.length,
                              ),
                            SizedBox(
                              height: 90.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: _cubit.myChildSize.height - 90.h,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 500.0,
                      height: 97.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300,
                              child: DottedLine(
                                dashLength: 10,
                                dashGapLength: 5,
                                lineThickness: 2,
                                dashColor: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Follow up your request to know if aproved or not, Good luck',
                                style: TextStyle(color: Colors.pinkAccent),
                                textAlign: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Dialog dialog(BenefitRequest request) {
//   return Dialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               insetPadding:
//                   EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     ...[
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(20),
//                         color: mainColor,
//                         child: const Center(
//                           child: Text(
//                             'Request Information',
//                             style: TextStyle(
//                                 color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         color: Colors.white,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ListTile(
//                               dense: true,
//                               leading: Icon(Icons.hourglass_bottom),
//                               title: Text(request.from ?? ''),
//                             ),
//                             ListTile(
//                               dense: true,
//                               leading: Icon(Icons.calendar_today_outlined),
//                               title: Text(request.to ?? ''),
//                             ),
//                             ListTile(
//                               dense: true,
//                               leading: Icon(Icons.messenger),
//                               title: Text(request.message ?? ''),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     if (request.requestWorkFlowAPIs != null &&
//                         request.requestWorkFlowAPIs!.isNotEmpty) ...[
//                       const SizedBox(height: 20),
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(16),
//                         color: mainColor,
//                         child: const Center(
//                           child: Text(
//                             'Request WorkFlow',
//                             style: TextStyle(
//                                 color: Colors.white, fontSize: 18),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(8),
//                         color: Colors.white,
//                         child: ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemBuilder: (context, index) {
//                             return IntrinsicHeight(
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 crossAxisAlignment:
//                                     CrossAxisAlignment.stretch,
//                                 children: [
//                                   Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       CircleAvatar(
//                                         backgroundColor:
//                                             getBenefitStatusColor(request
//                                                     .requestWorkFlowAPIs![
//                                                         index]
//                                                     .status ??
//                                                 ''),
//                                         radius: 15,
//                                         child: request
//                                                     .requestWorkFlowAPIs![
//                                                         index]
//                                                     .status ==
//                                                 'Pending'
//                                             ? Text(
//                                                 '${index + 1}',
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold,
//                                                     color: Colors.white),
//                                               )
//                                             : request
//                                                         .requestWorkFlowAPIs![
//                                                             index]
//                                                         .status ==
//                                                     'Approved'
//                                                 ? const Icon(Icons.check)
//                                                 : const Icon(Icons.close),
//                                       ),
//                                       if (index <
//                                           request.requestWorkFlowAPIs!
//                                                   .length -
//                                               1)
//                                         Expanded(
//                                           child: Container(
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: 8),
//                                             height: 50,
//                                             width: 0.5,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     width: 8,
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.only(bottom: 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(request
//                                                 .requestWorkFlowAPIs![index]
//                                                 .employeeName ??
//                                             ''),
//                                         Text(request
//                                                 .requestWorkFlowAPIs![index]
//                                                 .status ??
//                                             ''),
//                                         SizedBox(
//                                           height: 8,
//                                         ),
//                                         Text(request
//                                                 .requestWorkFlowAPIs![index]
//                                                 .notes ??
//                                             ''),
//                                         if (index == 0)
//                                           Text('asdasdasdasdasdadadsada')
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           itemCount: request.requestWorkFlowAPIs!.length,
//                         ),
//                       ),
//                       // for (var x in request.requestWorkFlowAPIs!)
//                       //   Container(
//                       //     width: double.infinity,
//                       //     color: Colors.white,
//                       //     child: Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Text(x.employeeName!),
//                       //         Text(x.statusString),
//                       //       ],
//                       //     ),
//                       //   ),
//                     ],
//                   ],
//                 ),
//               ),
//             );
// }

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

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(size.height);
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height - 90.h), radius: 15.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height - 90.h), radius: 15.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}
