import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../gallery_screen.dart';
import '../my_benefits/cubits/my_benefits_cubit.dart';
import '../my_benefits/my_benefits_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../widgets/banner.dart';
import '../widgets/benifit_card.dart';
import '../widgets/custom_switch.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/helpers.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/utils/loading_dialog.dart';
import 'cubits/manage_requests_cubit.dart';

class ManageRequestsScreen extends StatefulWidget {
  static const routeName = 'ManageRequestsScreen';
  final int requestNumber;

  const ManageRequestsScreen({Key? key,this.requestNumber=-1}) : super(key: key);

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen>
    with TickerProviderStateMixin {
  late ManageRequestsCubit _cubit;

  @override
  void initState() {
    _cubit = sl<ManageRequestsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getBenefitsToManage(requestNumber: widget.requestNumber);
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
        if (state is GetRequestsToManageLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is GetRequestsToManageSuccessState) {
          Navigator.pop(context);
        }
        if (state is GetRequestsToManageErrorState) {
          showMessageDialog(
              context: context,
              isSucceeded: false,
              message: state.message,
              onPressedOk: () {
                Navigator.pop(context);
              });
        }

        if (state is AddRequestResponseLoadingState) {
          loadingAlertDialog(context);
        }
        if (state is AddRequestResponseSuccessState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: state.message,
              onPressedOk: () {});
        }
        if (state is AddRequestResponseErrorState) {
          Navigator.pop(context);
          showMessageDialog(
              context: context,
              isSucceeded: false,
              message: state.message,
              onPressedOk: () {});
        }
      },
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
                const MyAppBar(),
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
                          controller: _cubit.employeeNumberSearch,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          decoration: InputDecoration(
                            hintText: "Search by employee number",
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
                      onTap: () {
                        _cubit.search();
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
                Expanded(
                  child: _cubit.benefitRequests.isNotEmpty
                      ? ListView.builder(
                    padding: EdgeInsets.zero,
                          // shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              requestCard(_cubit.benefitRequests[index]),
                          itemCount: _cubit.benefitRequests.length,
                        )
                      : const Center(child: Text('No Requests To Manage')),
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
                    SizedBox(
                      height: 12.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 51.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xffd9d9d9),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Filtration',
                        style: TextStyle(
                            color: mainColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Benefit Has Warning',
                          style: TextStyle(
                            color: Color(0xff7f7f7f),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ), //Text

                        Spacer(),
                        CustomSwitch(
                          value: _cubit.hasWarning,
                          onChanged: (bool? value) {
                            _cubit.changeContainWarning(value!);
                          },
                          activeColor: mainColor,
                        ), //Checkbox
                      ], //<Widget>[]
                    ),
                    Text(
                      "Action",
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
                            label: 'Holding',
                            index: 1,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                        SelectionChip(
                            label: 'Approved',
                            index: 3,
                            selectedIndex: _cubit.statusCurrentIndex,
                            selectIndex: _cubit.selectStatus),
                        SelectionChip(
                            label: 'Rejected',
                            index: 4,
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
                            index: 2,
                            selectedIndex: _cubit.typeCurrentIndex,
                            selectIndex: _cubit.selectType),
                        SelectionChip(
                            label: 'Group',
                            index: 3,
                            selectedIndex: _cubit.typeCurrentIndex,
                            selectIndex: _cubit.selectType),
                      ],
                    ),
                    Text(
                      "Date",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff7f7f7f),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    DateTimeField(
                      controller: _cubit.fromText,
                      // validator: (value) => deliverDate == null ? translator.translate('required') : null,

                      decoration: InputDecoration(
                          label: Text('From'),
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          contentPadding: EdgeInsets.all(3.0),
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              _cubit.changeFromDate(null);
                            },
                          )),

                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) async {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 1)
                              .add(Duration(days: -1)),
                        );
                      },
                      onChanged: (date) {
                        _cubit.changeFromDate(date);
                      },
                    ),
                    SizedBox(height: 16.h),
                    DateTimeField(
                      controller: _cubit.toText,
                      enabled: _cubit.fromDate != null,
                      decoration: InputDecoration(
                        label: Text('To'),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.all(3.0),
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                        ),
                      ),
                      format: DateFormat("yyyy-MM-dd"),
                      resetIcon: null,
                      onShowPicker: (context, currentValue) async {
                        return showDatePicker(
                            context: context,
                            firstDate: _cubit.fromDate ?? DateTime.now(),
                            initialDate: _cubit.toDate ?? DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1)
                                .add(Duration(days: -1)));
                      },
                      onChanged: (date) {
                        _cubit.changeToDate(date);
                      },
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
                            _cubit.search();
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
          _cubit.isBottomSheetOpened = true;
          print(_cubit.isBottomSheetOpened);
          buildShowDetailedModalBottomSheet(request);
          _cubit.getRequestProfileAndDocuments(request.requestNumber!);
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
                    IntrinsicHeight(
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
                                  child: Image.network(
                                    request.benefitCard??'',
                                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/more4u_card.png',fit: BoxFit.fill),

                                    fit: BoxFit.fill,
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                if (request.warningMessage != null || (request.hasDocuments!=null&&request.hasDocuments!))
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                    timeago.format(DateTime.parse(
                                        request.requestedat ?? '')),
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
                                        text: request.requestNumber.toString(),
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
                      child:
                      request.status =='Canceled'?
                         Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                softWrap: true,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'The Request has been ',
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text: 'Canceled ',
                    style: TextStyle(
                      color: redColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  TextSpan(
                    text: timeago.format(DateTime.parse(
                        request.myAction?.replayDate ??
                            '')),
                    style: TextStyle(
                        color: greyColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ])),
          ),
        ):
                      request.myAction == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 72.w,
                                  height: 40.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: redColor,
                                    ),
                                    onPressed: () => acceptOrReject(
                                        false, request.requestNumber!),
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
                                    onPressed: () => acceptOrReject(
                                        true, request.requestNumber!),
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
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                    softWrap: true,
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: 'You ',
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: request.myAction?.action ?? '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: getBenefitStatusColor(
                                              request.myAction?.action ?? ''),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' this request ',
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: timeago.format(DateTime.parse(
                                            request.myAction?.replayDate ??
                                                '')),
                                        style: TextStyle(
                                            color: greyColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ])),
                              ),
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
    void openGallery({int index = 0}) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GalleryScreen(
            base64Images: _cubit.profileAndDocuments!.documents!,
            index: index,
          )));
    }
    return showFlexibleBottomSheet(
        minHeight: 0,
        initHeight: 1.0-MediaQuery.of(context).viewPadding.top/MediaQuery.of(context).size.height,
        maxHeight: 1.0-MediaQuery.of(context).viewPadding.top/MediaQuery.of(context).size.height,
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
          return BlocBuilder(
            bloc: _cubit,
  builder: (context, state) {
    return ClipRRect(
            child: MyBanner(
              message: '${request.status}',
              textStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
              location: BannerLocation.topEnd,
              color: getBenefitStatusColor(request.status ?? ''),
              child: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      controller: scrollController,
                      children: [
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
                                  //todo fix this
                                  child: Image.network(request.benefitName!,
                                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/more4u_card.png'),

                                  ),
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
                            if (request.message != null&&request.message!.trim().isNotEmpty)

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
                                      fontSize: 14.sp,
                                      color: greyColor,
                                    ),
                                  ),
                                ]),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Divider(),
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
                            if (request.requestedat != null)
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'At ',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: greyColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        '${DateFormat('yyyy-MM-dd hh:mm aaa').format(DateTime.parse(request.requestedat ?? ''))}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: greyColor,
                                    ),
                                  ),
                                ]),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
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
                                    child:
                                    state is GetRequestProfileAndDocumentsLoadingState?
                                    Center(child: CircularProgressIndicator()):
                                    Image.memory(
                                      base64Decode(
                                          _cubit.profileAndDocuments?.profilePicture??''),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                      errorBuilder: (context, error,
                                          stackTrace) =>
                                          Image.asset(
                                              'assets/images/profile_avatar_placeholder.png',
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ProfileScreen.routeName,
                                        arguments: {'user':request.createdBy});
                                  },
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
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            request.createdBy?.departmentName ?? '',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: greyColor,
                                            ),
                                          ),
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
                          height: 8.h,
                        ),

                        if(request.sendToModel!=null)...[
                          Divider(),
                          Row(
                            children: [
                              Text(
                                "Gifted To",
                                style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14.sp,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: SelectionChip(
                                    label: request.sendToModel?.employeeName ?? '',
                                    index: 0,
                                    selectedIndex: 1,
                                    selectIndex: (_) {
                                      Navigator.pushNamed(
                                          context, ProfileScreen.routeName,
                                          arguments: {'user':request.sendToModel} );
                                    }),
                              ),
                            ],
                          ),


                        ],

                        if (request.fullParticipantsData != null) ...[
                          Divider(),
                          Text(
                            "Participants",
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 14.sp,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h,),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                ...request.fullParticipantsData!
                                    .map((participant) => SelectionChip(
                                        label: participant.employeeName ?? '',
                                        index: 0,
                                        selectedIndex: 1,
                                        selectIndex: (_) {
                                          Navigator.pushNamed(
                                              context, ProfileScreen.routeName,
                                              arguments: {'user':participant} );
                                        }))
                                    .toList()
                              ],
                            ),
                          ),
                        ],

                        if(request.hasDocuments!=null&&request.hasDocuments!)
                          ...[
                              Divider(),
                          Text(
                            "Documents",
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 14.sp,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h,),
                          state is GetRequestProfileAndDocumentsLoadingState?
                            SizedBox(height: 120.h,child: Center(child: CircularProgressIndicator())):
                            SizedBox(
                            height: 120.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    openGallery(index: 0);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: mainColor, width: 2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Image.memory(
                                        base64Decode(_cubit.profileAndDocuments!.documents![index]),
                                        width: 120.h,
                                        height: 120.h,
                                        fit: BoxFit.fill,
                                        gaplessPlayback: true),
                                  ),
                                );
                              },
                              itemCount: _cubit.profileAndDocuments!.documents!.length,
                            ),
                          ),
                        ],
                        if (request.warningMessage != null)
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
                                text: request.warningMessage ?? '',
                                style: TextStyle(color: redColor, fontFamily: 'Roboto'),
                              ),
                            ]),
                          ),
                        SizedBox(
                          height: 16.h,
                        ),
                        request.myAction == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 130.w,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: redColor,
                                      ),
                                      onPressed: () =>
                                          acceptOrReject(false, request.requestNumber!),
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
                                      onPressed: () =>
                                          acceptOrReject(true, request.requestNumber!),
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
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    RichText(
                                        softWrap: true,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: 'You ',
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: request.myAction?.action ?? '',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: getBenefitStatusColor(
                                                  request.myAction?.action ?? ''),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' this request ',
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: timeago.format(DateTime.parse(
                                                request.myAction?.replayDate ?? '')),
                                            style: TextStyle(
                                                color: greyColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ])),
                                    if (request.myAction?.notes != null)
                                      RichText(
                                          softWrap: true,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: 'Notes: ',
                                              style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: request.myAction?.notes ?? 'test',
                                              style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 14.sp,),
                                            ),
                                          ])),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  },
);
        }).whenComplete(() => _cubit.isBottomSheetOpened = false);
  }

  acceptOrReject(bool isAccepted, int requestNumber) {
    showDialog(
      context: context,
      builder: (_) {
        TextEditingController _textController = TextEditingController();
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
          child: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 300.h,
                    width: 500.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isAccepted
                              ? 'Approve and send your note'
                              : 'Reject and send your note',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isAccepted ? mainColor : redColor,
                            fontSize: 18.sp,
                            fontFamily: "Cairo",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        TextFormField(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto'),
                          decoration: InputDecoration(
                            isDense: true,
                            // contentPadding: EdgeInsets.symmetric(vertical: 0),
                            suffixIconConstraints:
                                BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                            prefixIconConstraints:
                                BoxConstraints(maxHeight: 80.h, minWidth: 50.w),
                            prefixIcon: Column(
                              children: [
                                Icon(CustomIcons.clipboard_regular),
                              ],
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Notes',
                            hintText: 'Enter Your Notes',
                            hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 300.h / 1.4,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 500.0.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: DottedLine(
                              dashLength: 8.w,
                              dashGapLength: 7.w,
                              lineThickness: 2,
                              dashColor: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 50.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.r),
                                      ),
                                      side: BorderSide(
                                        width: 2.0.w,
                                        color:
                                            isAccepted ? mainColor : redColor,
                                      ),
                                      primary: Colors.white,
                                      onPrimary:
                                          isAccepted ? mainColor : redColor,
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    print(_cubit.isBottomSheetOpened);
                                    if (_cubit.isBottomSheetOpened) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                    var b = await _cubit.acceptOrRejectRequest(
                                        requestNumber,
                                        isAccepted ? 1 : 2,
                                        _textController.text);
                                    print('hello');
                                    if (b ?? false) {
                                      print('hello');
                                      print(b);
                                      _cubit.removeRequest(requestNumber);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    side: BorderSide(
                                      width: 2.0.w,
                                      color: isAccepted ? mainColor : redColor,
                                    ),
                                    primary: isAccepted ? mainColor : redColor,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text(
                                    isAccepted ? 'Accept' : 'Reject',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      //     Dialog(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8),
      //   child: ClipPath(
      //     clipper: MyClipper(),
      //     child: Container(
      //       decoration: BoxDecoration(
      //       color: Colors.white,
      //         borderRadius: BorderRadius.circular(6.r),
      //       ),
      //       padding: const EdgeInsets.all(8.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Text(
      //             isAccepted?'Approve and send your note':'Reject and send your note',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //               color:  isAccepted?mainColor:redColor,
      //               fontSize: 18.sp,
      //               fontFamily: "Cairo",
      //               fontWeight: FontWeight.w700,
      //             ),
      //           ),
      //           TextFormField(
      //             keyboardType: TextInputType.multiline,
      //             maxLines: 3,
      //             style: const TextStyle(
      //                 fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
      //             decoration:
      //             InputDecoration(
      //               isDense: true,
      //               // contentPadding: EdgeInsets.symmetric(vertical: 0),
      //               suffixIconConstraints:
      //               BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
      //               prefixIconConstraints: BoxConstraints(maxHeight: 103.h, minWidth: 50.w) ,
      //               prefixIcon: Column(
      //                 children: [
      //                   Icon(CustomIcons.clipboard_regular),
      //                 ],
      //               ),
      //               border: OutlineInputBorder(),
      //               labelText: 'Notes',
      //               hintText: 'Enter Your Notes',
      //               hintStyle: TextStyle(color: Color(0xffc1c1c1)),
      //               floatingLabelBehavior: FloatingLabelBehavior.always,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 8,
      //           ),
      //           SizedBox(
      //             width: double.infinity,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 showMessageDialog(
      //                   context: context,
      //                   isSucceeded: true,
      //                   message: isAccepted
      //                       ? 'Request Accepted!'
      //                       : 'Request Rejected!',
      //                   onPressedOk: () {
      //                     Navigator.popUntil(
      //                         context, ModalRoute.withName(HomeScreen.routeName));
      //                   },
      //                 );
      //               },
      //               child: const Text('Confirm'),
      //               style: ElevatedButton.styleFrom(primary: mainColor),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
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
        Rect.fromCircle(center: Offset(0.0, size.height / 1.4), radius: 15.0.w));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 1.4), radius: 15.0.w));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
