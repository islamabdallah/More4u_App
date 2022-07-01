import 'package:badges/badges.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/entities/user.dart';
import 'package:more4u/presentation/home/cubits/home_cubit.dart';
import 'package:more4u/presentation/home/home_screen.dart';
import 'package:more4u/presentation/my_benefit_requests/my_benefit_requests_screen.dart';
import 'package:more4u/presentation/widgets/selection_chip.dart';
import 'package:more4u/presentation/widgets/utils/message_dialog.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../core/constants/constants.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';
import '../my_benefits/my_benefits_screen.dart';
import '../notification/notification_screen.dart';
import '../widgets/banner.dart';
import '../widgets/benifit_card.dart';
import '../widgets/drawer_widget.dart';
import 'cubits/manage_requests_cubit.dart';

class ManageRequestsScreen extends StatefulWidget {
  static const routeName = 'ManageRequestsScreen';

  const ManageRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen>
    with TickerProviderStateMixin {
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
    TabController _tabController = TabController(length: 3, vsync: this);

    return BlocConsumer(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: const DrawerWidget(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    'Manage Requests',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Joti',
                        color: redColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                  color: Colors.black26)
                            ]),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search by request number",
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 11.w),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteGreyColor),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteGreyColor),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      // overlayColor:MaterialStateProperty.all(Colors.transparent) ,
                      // focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Ink(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: mainColor,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Icon(
                          // Icons.filter_list_alt,
                          CustomIcons.search__1_,
                          size: 20.w,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      // overlayColor:MaterialStateProperty.all(Colors.transparent) ,
                      // focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        buildShowModalBottomSheet(context);
                      },
                      child: Ink(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: mainColor,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 10)
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Icon(
                          // Icons.filter_list_alt,
                          CustomIcons.settings_sliders,
                          size: 20.w,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ],
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
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        // shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            requestCard(_cubit.benefitRequests[index]),
                        itemCount: _cubit.benefitRequests.length,
                      ),
                      const Center(child: Text('No Benefit available')),
                      const Center(child: Text('No Benefit available')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder(
            bloc: _cubit,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 51,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Color(0xffd9d9d9),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Filteration',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Status",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff7f7f7f),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Wrap(
                      children: [
                        SelectionChip(
                            label: 'Pending',
                            index: 0,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                        SelectionChip(
                            label: 'Inprogress',
                            index: 1,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                        SelectionChip(
                            label: 'Approved',
                            index: 2,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                        SelectionChip(
                            label: 'Rejected',
                            index: 3,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                      ],
                    ),
                    Text(
                      "Benefit Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff7f7f7f),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Wrap(
                      children: [
                        SelectionChip(
                            label: 'Individual',
                            index: 0,
                            selectedIndex: _cubit.typeCurrentIndex,
                            selectIndex: _cubit.selectType),
                        SelectionChip(
                            label: 'Group',
                            index: 1,
                            selectedIndex: _cubit.typeCurrentIndex,
                            selectIndex: _cubit.selectType),
                      ],
                    ),
                    Text(
                      "Benefit Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff7f7f7f),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    DateTimeField(
                      // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                      decoration: InputDecoration(
                        label: Text('Date From'),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.all(3.0),
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      format: DateFormat("dd-MM-yyyy"),
                      onShowPicker: (context, currentValue) async {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now(),
                        );
                      },
                      onChanged: (date) {},
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // height: 42.h,
                        width: 187.w,
                        child: ElevatedButton(
                          onPressed: () {
                            // FlutterAppBadger.isAppBadgeSupported();
                            // FlutterAppBadger.updateBadgeCount(10);
                            // FlutterAppBadger.removeBadge();
                            Navigator.pop(context);
                          },
                          child: Text('Done'),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  Card requestCard(BenefitRequest request) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
      child: InkWell(
        onTap: () {
          buildShowDetailedModalBottomSheet(request);
        },
        child: MyBanner(
          message: request.status ?? '',
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
                // height: 150.h,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 5.0,
                      color: getBenefitStatusColor(request.status ?? ''),
                    ),
                    right: BorderSide(
                      width: 2.0,
                      color: Color(0xFFE7E7E7),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      // border: Border.all()
                                      ),
                                  child: Image.asset(
                                    'assets/images/hbd.png',
                                    fit: BoxFit.fill,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),

                                //todo add containt document flag for request
                                if (request.warningMessage != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 8.h),
                                    child: Icon(
                                      CustomIcons.shield_exclamation,
                                      size: 27.r,
                                      color: yellowColor,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Expanded(
                            flex: 9,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.benefitName ?? '',
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: 14.sp,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Name   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: request.createdBy?.employeeName ??
                                            '',
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
                                        text: 'Number   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text:
                                            request.requestNumber.toString() ??
                                                '',
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
                                        text: 'Required Date   ',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: request.from ?? '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: greyColor,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  if (request.requestedAt != null)
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Requested At   ',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: greyColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: request.requestedAt ?? '',
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
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 72.w,
                            height: 40.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: redColor,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          SizedBox(
                            width: 72.w,
                            height: 40.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: mainColor,
                              ),
                              onPressed: () {},
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Details',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Icon(Icons.arrow_circle_right, size: 30.r),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildShowDetailedModalBottomSheet(BenefitRequest request) {
    return showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 1.0,
        maxHeight: 1.0,
        isExpand: false,
        bottomSheetColor: Colors.transparent,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r))),
        // enableDrag: true,
        // isDismissible: false,
        // isScrollControlled: true,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(25.r),
        //     topRight: Radius.circular(25.r),
        //   ),
        // ),
        context: context,
        builder: (
          BuildContext context,
          ScrollController scrollController,
          double bottomSheetOffset,
        ) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              shrinkWrap: true,
              controller: scrollController,
              children: [
                SizedBox(height: 25.h),
                Text(
                  request.benefitName ?? '',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 20.sp,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
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
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name    ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.employeeName ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Number    ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${request.requestNumber}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Type    ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.benefitType ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Required Date    ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.from ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'To    ',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.to ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    if (request.message != null)
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Message: ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: greyColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: request.message ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: greyColor,
                            ),
                          ),
                        ]),
                      ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    Text(
                      "Created By",
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 14.sp,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    if (request.requestedAt != null)
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'At ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: greyColor,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: request.requestedAt ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: greyColor,
                            ),
                          ),
                        ]),
                      ),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          request.createdBy?.employeeName ?? '',
                          style: TextStyle(
                            color: greyColor,
                            fontSize: 14.sp,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: mainColor, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          height: 130.h,
                          width: 132.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "View Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(CustomIcons.hastag),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Employee Number    ',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.employeeNumber.toString() ??
                                    '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.seedling_solid__1_),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Sap Number    ',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.sapNumber.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.apps),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Department    ',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.departmentName ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.cake_birthday),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Birthday    ',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.birthDate ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(CustomIcons.person_solid),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                'Payroll Area    ',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                request.createdBy?.collar ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (request.fullParticipantsData != null) ...[
                  Text(
                    "Created By",
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 14.sp,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Wrap(
                    children: [
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                      SelectionChip(
                          label: 'Abanob Zakaria',
                          index: 0,
                          selectedIndex: 1,
                          selectIndex: (_) {}),
                    ],
                  ),
                ],

                if(request.warningMessage!=null)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Warning: ',
                      style: TextStyle(
                          color: redColor,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          request.warningMessage ?? '',
                      style: TextStyle(color: redColor, fontFamily: 'Roboto'),
                    ),
                  ]),
                ),
                SizedBox(height: 8.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: redColor,
                        ),
                        onPressed: () {},
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    SizedBox(
                      width: 130.w,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          );
        });
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
                    showMessageDialog(
                      context: context,
                      isSucceeded: true,
                      message: isAccepted
                          ? 'Request Accepted!'
                          : 'Request Rejected!',
                      onPressedOk: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName(HomeScreen.routeName));
                      },
                    );
                  },
                  child: const Text('Confirm'),
                  style: ElevatedButton.styleFrom(primary: mainColor),
                ),
              )
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
              title: Text('Name: ${user.employeeName ?? ''}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.pin),
              title: Text('Employee Number: ${user.employeeNumber}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.sell),
              title: Text('Sap Number: ${user.sapNumber}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.domain),
              title: Text('Department: ${user.departmentName ?? ''}'),
            ),
            // ListTile(
            //   dense: true,
            //   leading: Icon(Icons.person),
            //   title: Text('supervisorName: ${user.supervisorName ?? ''}'),
            // ),
            ListTile(
              dense: true,
              leading: Icon(Icons.cake),
              title: Text('Birth Date: ${user.birthDate}'),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.accessibility),
              title: Text('Payroll Area: ${user.collar}'),
            ),
          ]),
        );
      });
}
