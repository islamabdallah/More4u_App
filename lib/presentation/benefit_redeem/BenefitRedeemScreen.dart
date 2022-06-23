import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/domain/usecases/get_participants.dart';
import 'package:more4u/presentation/benefit_redeem/cubits/redeem_cubit.dart';
import 'package:more4u/presentation/home/home_screen.dart';

import '../../core/utils/flutter_chips/src/chips_input.dart';
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Redeem Card'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
//         mainAxisSize:MainAxisSize.min,
                children: [
                  if (_cubit.benefit.benefitType == 'Group') ...[
                    TextFormField(
                      controller: _cubit.groupName,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        label: Text('Group Name'),
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontWeight: FontWeight.w600),
                        contentPadding: EdgeInsets.all(3.0),
                        prefixIcon: const Icon(
                          Icons.group,
                        ),
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
                        labelText: "Select People",
                        border: OutlineInputBorder(),
                        errorText: _cubit.lowParticipantError,
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
                          key: ObjectKey(profile),
                          label: Text(profile.fullName),
                          avatar: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/profile_avatar_placeholder.png'),
                          ),
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
                  // if (_cubit.showParticipantsField)
                  //   ChipsInput<String>(
                  //     decoration: InputDecoration(
                  //         labelText: "Participants",
                  //         border: OutlineInputBorder()),
                  //     findSuggestions: (String query) {
                  //       if (query.length > 0) {
                  //         var lowercaseQuery = query.toLowerCase();
                  //         return list.where((name) {
                  //           return name
                  //               .toLowerCase()
                  //               .contains(query.toLowerCase());
                  //         }).toList(growable: false)
                  //           ..sort((a, b) => a
                  //               .toLowerCase()
                  //               .indexOf(lowercaseQuery)
                  //               .compareTo(
                  //                   b.toLowerCase().indexOf(lowercaseQuery)));
                  //       } else {
                  //         return [];
                  //       }
                  //     },
                  //     onChanged: (data) {
                  //       print(data);
                  //     },
                  //     chipBuilder: (context, state, name) {
                  //       return InputChip(
                  //         key: ObjectKey(name),
                  //         label: Text(name),
                  //         avatar: CircleAvatar(
                  //           backgroundImage: AssetImage(
                  //               'assets/images/profile_avatar_placeholder.png'),
                  //         ),
                  //         onDeleted: () => state.deleteChip(name),
                  //         materialTapTargetSize:
                  //             MaterialTapTargetSize.shrinkWrap,
                  //       );
                  //     },
                  //     suggestionBuilder: (context, state, name) {
                  //       return ListTile(
                  //         key: ObjectKey(name),
                  //         leading: CircleAvatar(
                  //           backgroundImage: AssetImage(
                  //               'assets/images/profile_avatar_placeholder.png'),
                  //         ),
                  //         title: Text(name),
                  //         onTap: () => state.selectSuggestion(name),
                  //       );
                  //     },
                  //   ),
                  DateTimeField(
                      controller: _cubit.startDate,
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
                  SizedBox(
                    height: 20,
                  ),
                  DateTimeField(
                    enabled: false,
                    controller: _cubit.endDate,
                    // validator: (value) => deliverDate == null ? translator.translate('required') : null,
                    decoration: InputDecoration(
                      label: Text(
                        'To',
                        style: TextStyle(color: Colors.black54),
                      ),
                      border: InputBorder.none,
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45)),
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      contentPadding: EdgeInsets.all(3.0),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                      ),
                    ),
                    format: DateFormat("dd-MM-yyyy"),
                    onShowPicker: (context, currentValue) async {
                      // return showDatePicker(
                      //     context: context,
                      //     firstDate: DateTime.now(),
                      //     initialDate: DateTime.now(),
                      //     lastDate: DateTime(DateTime.now().year + 1));
                      // if (date != null) {
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
                    onChanged: (value) {
                      setState(() {
                        // deliverDate = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _cubit.message,
                    maxLines: 4,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      label: Text('Message'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      // prefixText: 'Question: ',
                      prefixIcon: const Icon(
                        Icons.article,
                        size: 26,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(),
                      // focusedBorder: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                      itemBuilder: (_, index) {
                        return
                      _cubit.myDocs.values.elementAt(index)==null?
                         TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.red, width: 1),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: () async {
                            _cubit.pickImage(_cubit.myDocs.keys.elementAt(index));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_library,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                'addImage',
                              ),
                            ],
                          ),
                        ):
                      Stack(
                          fit: StackFit.loose,
                          children: <Widget>[
                      Image(
                      image: MemoryImage(base64Decode(
                          _cubit.myDocs.values.elementAt(index)!
                      )),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                        Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                        width: 25,
                        height: 25,
                        child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                        ),
                        onPressed: () {
                        _cubit.removeImage(index);
                        },
                        ),
                        ),
                        ),
                     ]   );
                      },
                      itemCount: _cubit.myDocs.length),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _cubit.redeemCard();
                      },
                      child: Text('submit'))
                ],
              ),
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
