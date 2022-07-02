import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/domain/usecases/get_participants.dart';
import 'package:more4u/presentation/benefit_redeem/cubits/redeem_cubit.dart';
import 'package:more4u/presentation/home/home_screen.dart';

import '../../core/utils/flutter_chips/src/chips_input.dart';
import '../../custom_icons.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';
import '../widgets/utils/message_dialog.dart';

class BenefitRedeemScreen extends StatefulWidget {
  static const routeName = 'BenefitRedeemScreen';

  final Benefit benefit;

  const BenefitRedeemScreen({Key? key, required this.benefit})
      : super(key: key);

  @override
  _BenefitRedeemScreenState createState() => _BenefitRedeemScreenState();
}

class _BenefitRedeemScreenState extends State<BenefitRedeemScreen> {
  late RedeemCubit _cubit;

  @override
  void initState() {
    _cubit = sl<RedeemCubit>()..initRedeem(widget.benefit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RedeemCubit, RedeemState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is RedeemSuccessState) {
          showMessageDialog(
              context: context,
              isSucceeded: true,
              message: 'Card Redeem succeeded!',
              onPressedOk: () => Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.routeName)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/hbd.png'),
                Transform.translate(
                  offset: Offset(0.0, -40.0.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r),
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 0),
                    padding: EdgeInsets.only(left: 20.w,right: 20.w, top: 26.h),
                    child: SingleChildScrollView(
                      child: Column(
//         mainAxisSize:MainAxisSize.min,
                        children: [
                          if (_cubit.benefit.benefitType == 'Group') ...[
                            TextFormField(
                              controller: _cubit.groupName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, color: mainColor),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                suffixIconConstraints:
                                BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                                prefixIcon: Icon(CustomIcons.users_alt),
                                border: OutlineInputBorder(),
                                labelText: 'Group Name',
                                hintText: 'Enter Your Group Name',
                                hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                          if (_cubit.showParticipantsField) ...[
                            ChipsInput<Participant>(
                              enabled: _cubit.enableParticipantsField,
                              // enabled: false,
                              allowChipEditing: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                suffixIconConstraints:
                                BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                                prefixIcon: Icon(CustomIcons.users_alt),
                                border: OutlineInputBorder(),
                                labelText: 'Group Participants',
                                hintText: 'Enter Your Group Participants',
                                hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                errorText: _cubit.lowParticipantError,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              maxChips: _cubit.benefit.maxParticipant,
                              findSuggestions: (String query) {
                                if (query.length > 1) {
                                  var lowercaseQuery = query.toLowerCase();
                                  return _cubit.participants.where((profile) {
                                    return profile.fullName
                                        .toLowerCase()
                                        .contains(query.toLowerCase()) ||
                                        profile.employeeNumber
                                            .toString()
                                            .toLowerCase()
                                            .contains(query.toLowerCase());
                                  }).toList(growable: false)
                                    ..sort((a, b) => a.fullName
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b.fullName
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)));
                                } else {
                                  return const <Participant>[];
                                }
                              },
                              onChanged: _cubit.participantsOnChange,
                              chipBuilder: (context, state, profile) {
                                return InputChip(
                                  padding: EdgeInsets.zero,
                                  deleteIconColor: mainColor,
                                  labelStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: mainColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: Color(0xFFC1C1C1)),
                                  ),
                                  backgroundColor: Color(0xFFE7E7E7),
                                  key: ObjectKey(profile),
                                  label: Text(profile.fullName),
                                  // avatar: CircleAvatar(
                                  //   backgroundImage: AssetImage(
                                  //       'assets/images/profile_avatar_placeholder.png'),
                                  // ),
                                  onDeleted: () {
                                    _cubit.participantOnRemove(profile);
                                    state.forceDeleteChip(profile);
                                  },
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                );
                              },
                              suggestionBuilder: (context, state, profile) {
                                return ListTile(
                                  key: ObjectKey(profile),
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_avatar_placeholder.png'),
                                  ),
                                  title: Text(profile.fullName),
                                  subtitle: Text(profile.employeeNumber.toString()),
                                  onTap: () => state.selectSuggestion(profile),
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                          DateTimeField(
                              resetIcon: Icon(Icons.close,size: 25,),
                              controller: _cubit.startDate,
                              // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                prefixIcon: Icon(CustomIcons.calendar_days_solid__1_),

                                border: OutlineInputBorder(),
                                labelText: 'Start From',
                                hintText: 'DD-MM-YYYY',
                                helperText:
                                'You are selected from ${_cubit.startDate.text} to ${_cubit.endDate.text}',
                                hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              format: DateFormat("dd-MM-yyyy"),
                              onShowPicker: (context, currentValue) async {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1).add(
                                        Duration(days: -1))); // if (date != null) {
                                //   final time = await showTimePicker(
                                //     context: context,
                                //     initialTime:
                                //     TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                //   );
                                //   return DateTimeField.combine(date, time);
                                // } else {
                                //   return currentValue;
                                // }
                              },
                              onChanged: _cubit.changeStartDate),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // DateTimeField(
                          //   enabled: false,
                          //   controller: _cubit.endDate,
                          //   // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                          //   decoration: InputDecoration(
                          //     label: Text(
                          //       'To',
                          //       style: TextStyle(color: Colors.black54),
                          //     ),
                          //     border: InputBorder.none,
                          //     disabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(color: Colors.black45)),
                          //     labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          //     contentPadding: EdgeInsets.all(3.0),
                          //     prefixIcon: const Icon(
                          //       Icons.calendar_today,
                          //     ),
                          //   ),
                          //   format: DateFormat("dd-MM-yyyy"),
                          //   onShowPicker: (context, currentValue) async {
                          //     // return showDatePicker(
                          //     //     context: context,
                          //     //     firstDate: DateTime.now(),
                          //     //     initialDate: DateTime.now(),
                          //     //     lastDate: DateTime(DateTime.now().year + 1));
                          //     // if (date != null) {
                          //     //   final time = await showTimePicker(
                          //     //     context: context,
                          //     //     initialTime:
                          //     //     TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                          //     //   );
                          //     //   return DateTimeField.combine(date, time);
                          //     // } else {
                          //     //   return currentValue;
                          //     // }
                          //   },
                          //   onChanged: (value) {
                          //     setState(() {
                          //       // deliverDate = value;
                          //     });
                          //   },
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _cubit.message,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontFamily: 'Roboto'),
                            decoration:
                              InputDecoration(
                                isDense: true,
                                // contentPadding: EdgeInsets.symmetric(vertical: 0),
                                suffixIconConstraints:
                                BoxConstraints(maxHeight: 20.h, minWidth: 50.w),
                                prefixIconConstraints: BoxConstraints(maxHeight: 103.h, minWidth: 50.w) ,
                                prefixIcon: Column(
                                  children: [
                                    Icon(CustomIcons.clipboard_regular),
                                  ],
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Message',
                                hintText: 'Enter Your Message',
                                hintStyle: TextStyle(color: Color(0xffc1c1c1)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // ListView.builder(
                          //     shrinkWrap: true,
                          //     itemBuilder: (_, index) {
                          //       return _cubit.myDocs.values.elementAt(index) == null
                          //           ? TextButton(
                          //               style: TextButton.styleFrom(
                          //                 side: BorderSide(color: Colors.red, width: 1),
                          //                 shape: const RoundedRectangleBorder(
                          //                     borderRadius:
                          //                         BorderRadius.all(Radius.circular(5))),
                          //               ),
                          //               onPressed: () async {
                          //                 _cubit.pickImage(
                          //                     _cubit.myDocs.keys.elementAt(index));
                          //               },
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 children: [
                          //                   const Icon(
                          //                     Icons.photo_library,
                          //                   ),
                          //                   const SizedBox(
                          //                     width: 5.0,
                          //                   ),
                          //                   Text(
                          //                     'addImage',
                          //                   ),
                          //                 ],
                          //               ),
                          //             )
                          //           : Stack(fit: StackFit.loose, children: <Widget>[
                          //               Image(
                          //                 image: MemoryImage(base64Decode(
                          //                     _cubit.myDocs.values.elementAt(index)!)),
                          //                 fit: BoxFit.cover,
                          //                 width: 200,
                          //                 height: 200,
                          //               ),
                          //               Positioned(
                          //                 right: 5,
                          //                 top: 5,
                          //                 child: Container(
                          //                   width: 25,
                          //                   height: 25,
                          //                   child: IconButton(
                          //                     iconSize: 20,
                          //                     padding: EdgeInsets.zero,
                          //                     icon: Icon(
                          //                       Icons.remove_circle,
                          //                       size: 20,
                          //                       color: Colors.red,
                          //                     ),
                          //                     onPressed: () {
                          //                       _cubit.removeImage(index);
                          //                     },
                          //                   ),
                          //                 ),
                          //               ),
                          //             ]);
                          //     },
                          //     itemCount: _cubit.myDocs.length),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Center(
                            child: SizedBox(
                              width: 187.w,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _cubit.redeemCard();
                                  },
                                  child: Text('Redeem')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppProfile {
  final String name;
  final String email;
  final String imageUrl;

  const AppProfile(this.name, this.email, this.imageUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppProfile &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
