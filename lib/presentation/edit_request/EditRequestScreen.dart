import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:more4u/core/constants/constants.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/domain/usecases/get_participants.dart';
import '../benefit_redeem/cubits/redeem_cubit.dart';

import '../../core/utils/flutter_chips/src/chips_input.dart';
import '../../domain/entities/benefit.dart';
import '../../injection_container.dart';

class EditRequestScreen extends StatefulWidget {
  static const routeName = 'EditRequestScreen';

  final BenefitRequest request;

  const EditRequestScreen({Key? key, required this.request})
      : super(key: key);

  @override
  _EditRequestScreenState createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {

  late RedeemCubit _cubit;

  @override
  void initState() {
    // _cubit = sl<RedeemCubit>()..initRedeem(widget.request);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RedeemCubit, RedeemState>(
      bloc: _cubit,
      listener: (context, state) {},
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
                  if (_cubit.showParticipantsField)
                    ...[
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
                          onDeleted: (){
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
                      label: Text('To',style: TextStyle(color: Colors.black54),),
                      border: InputBorder.none,
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black45)
                      ),
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
