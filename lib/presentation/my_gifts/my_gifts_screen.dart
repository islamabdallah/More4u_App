import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';
import 'package:more4u/presentation/widgets/banner.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../domain/entities/gift.dart';
import '../../injection_container.dart';
import '../manage_requests/manage_requests_screen.dart';
import '../notification/notification_screen.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import 'cubits/my_gifts_cubit.dart';

class MyGiftsScreen extends StatefulWidget {
  static const routeName = 'MyGiftsScreen';
  final int requestNumber;

  const MyGiftsScreen({Key? key,this.requestNumber=-1}) : super(key: key);

  @override
  State<MyGiftsScreen> createState() => _MyGiftsScreenState();
}

class _MyGiftsScreenState extends State<MyGiftsScreen> {
  late MyGiftsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<MyGiftsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getMyGifts(requestNumber: widget.requestNumber);
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
    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {
        if (state is GetMyGiftsLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetMyGiftsSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetMyGiftsErrorState) {
          Navigator.pop(context);
          showMessageDialog(context: context, isSucceeded: false,message: state.message);
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
                const MyAppBar(),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'My Gifts',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Joti',
                        color: redColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 25.h),

                Expanded(
                  child: _cubit.myGifts.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              myGiftCard(gift: _cubit.myGifts[index]),
                          itemCount: _cubit.myGifts.length,
                        )
                      : const Center(child: Text('No Gifts')),
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

  Widget myGiftCard({required Gift gift}) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
      child: Container(
        // height: 150.h,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 5.0, color: mainColor),
            right: BorderSide(
              width: 2.0,
              color: Color(0xFFE7E7E7),
            ),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // border: Border.all()
                          ),
                      child: Image.network(
                        gift.benefitCard!,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/more4u_card.png',
                                fit: BoxFit.fill),
                        fit: BoxFit.fill,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 9,
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gift.benefitName ?? '',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 14.sp,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timeago.format(DateTime.parse(gift.date ?? '')),
                        style: TextStyle(
                          color: greyColor,
                          fontSize: 12.sp,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'From   ',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: greyColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: gift.employeeName ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: greyColor,
                            ),
                          ),
                        ]),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Department   ',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: greyColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: gift.employeeDepartment.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: greyColor,
                            ),
                          ),
                        ]),
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

// Widget myGiftCard({required Gift gift}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 2),
//     child: Card(
//       elevation: 5,
//       clipBehavior: Clip.antiAlias,
//       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
//       child: Container(
//         height: 150.h,
//         decoration: BoxDecoration(
//           border: Border(
//             left: BorderSide(
//               width: 5.0,
//               color: mainColor,
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           // crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Container(
//                 decoration: BoxDecoration(
//                     // border: Border.all()
//                     ),
//                 child: Image.asset(
//                   'assets/images/hbd.png',
//                   fit: BoxFit.fill,
//                   alignment: Alignment.centerLeft,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         gift.benefitName ?? '',
//                         style: TextStyle(
//                           color: mainColor,
//                           fontSize: 14.sp,
//                           fontFamily: "Roboto",
//                           fontWeight: FontWeight.w600,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Expanded(
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'From: ',
//                               style: TextStyle(
//                                   color: greyColor,
//                                   fontSize: 14.sp,
//                                   fontFamily: 'Roboto',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             TextSpan(
//                               text: gift.employeeName ?? '',
//                               style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontFamily: "Roboto",
//                                   color: greyColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Department: ',
//                               style: TextStyle(
//                                   color: greyColor,
//                                   fontSize: 14.sp,
//                                   fontFamily: 'Roboto',
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             TextSpan(
//                               text: gift.employeeDepartment ?? '',
//                               style: TextStyle(
//                                   fontSize: 14.sp,
//                                   fontFamily: "Roboto",
//                                   color: greyColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(CustomIcons.clock),
//                         SizedBox(
//                           width: 4.w,
//                         ),
//                         Text(
//                           timeago.format(DateTime.parse(gift.date ?? '')),
//                           style: TextStyle(
//                               color: greyColor,
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
