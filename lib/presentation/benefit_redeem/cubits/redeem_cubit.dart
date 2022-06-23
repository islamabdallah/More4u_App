import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/entities/benefit_request.dart';
import 'package:more4u/domain/usecases/get_participants.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/benefit.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/usecases/redeem_card.dart';

part 'redeem_state.dart';

class RedeemCubit extends Cubit<RedeemState> {
  static RedeemCubit get(context) => BlocProvider.of(context);
  final GetParticipantsUsecase getParticipantsUsecase;
  final RedeemCardUsecase redeemCardUsecase;

  RedeemCubit(
      {required this.getParticipantsUsecase, required this.redeemCardUsecase})
      : super(RedeemInitial());

  late Benefit benefit;
  List<Participant> participants = [];
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController message = TextEditingController();
  late DateTime date, start, end;

  late bool showParticipantsField;
  late bool enableParticipantsField = true;

  initRedeem(Benefit benefit) {
    this.benefit = benefit;
    _configureDate(benefit);
    startDate.text = _formatDate(start);
    endDate.text = _formatDate(end);
    if (benefit.benefitType == 'Group' || benefit.isAgift) {
      showParticipantsField = true;
      getParticipants();
    } else {
      showParticipantsField = false;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  _configureDate(Benefit benefit) {
    switch (benefit.dateToMatch) {
      case 'Birth Date':
        date = DateTime.parse(userData!.birthDate);
        break;
      case 'join Date':
        date = DateTime.parse(userData!.joinDate);
        break;
      case 'Certain Date':
        date = DateTime.parse(benefit.certainDate!);
        break;
      default:
        date = DateTime.now();
        break;
    }
    start = DateTime(DateTime.now().year, date.month, date.day);
    end = start.add(Duration(days: benefit.numberOfDays! - 1));
    if (start.compareTo(DateTime.now()) == -1) {
      start = DateTime.now();
      end = start.add(Duration(days: benefit.numberOfDays! - 1));
    }
  }

  changeStartDate(DateTime? dateTime) {
    if (dateTime != null) {
      start = dateTime;
      end = start.add(Duration(days: benefit.numberOfDays! - 1));
      endDate.text = _formatDate(end);
      emit(DateChangeState());
    }
  }

  void getParticipants() async {
    emit(RedeemLoadingState());
    final result = await getParticipantsUsecase();

    result.fold((failure) {
      emit(RedeemGetParticipantsErrorState(failure.message));
    }, (participants) {
      print(participants);
      this.participants = participants;
      emit(RedeemGetParticipantsSuccessState());
    });
  }

  List<int> participantsIds = [];

  participantsOnChange(List<Participant> selectedParticipants) {
    if (selectedParticipants.length == benefit.maxParticipant) {
      enableParticipantsField = false;
      emit(ParticipantsChangedState());
    }
    List<int> participantsIds = [];

    for (Participant participant in selectedParticipants) {
      participantsIds.add(participant.employeeNumber);
    }
    this.participantsIds = participantsIds;
  }

  participantOnRemove(Participant profile) {
    participantsIds
        .removeWhere((participant) => participant == profile.employeeNumber);
    if (participantsIds.length < benefit.maxParticipant) {
      enableParticipantsField = true;
    }
    print(enableParticipantsField);
    emit(ParticipantsChangedState());
  }

  redeemCard() async {
    if (_validateParticipants()) {
      var request = BenefitRequest(
        participants: benefit.benefitType == 'Group' ? participantsIds : null,
        sendToID: benefit.isAgift && participantsIds.isNotEmpty
            ? participantsIds.first
            : null,
        from: startDate.text,
        to: endDate.text,
        benefitId: benefit.id,
        employeeNumber: userData!.employeeNumber,
        groupName: groupName.text,
        message: message.text,
      );
      print(request);
      final result = await redeemCardUsecase(request: request);
      result.fold((failure) {
        emit(RedeemErrorState(failure.message));
      }, (success) {
        emit(RedeemSuccessState());
      });
    }
  }

  String? lowParticipantError;

  bool _validateParticipants() {
    if ((benefit.benefitType == 'Group' || benefit.isAgift) &&
        participantsIds.length < benefit.minParticipant) {
      lowParticipantError =
          'Participants should be between ${benefit.minParticipant} and ${benefit.maxParticipant}';
      emit(ErrorValidationState());
      return false;
    } else {
      lowParticipantError = null;
      emit(ErrorValidationState());
    }
    return true;
  }

  List<File> images = [];
  static List<String> requiredDocs = ['d1','d2'];

  Map<String,String?> myDocs = {
    for(var doc in requiredDocs)
      doc:null,
  };


  pickImage(String key) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery      // maxHeight: 200,
      // maxWidth: 200,
    );
    if (image != null) {

      File imageFile =File(image.path);
      Uint8List bytes = imageFile.readAsBytesSync();
      String img64 = base64Encode(bytes);
      myDocs[key] = img64;
        // images.add(File(image.path));

      emit(ImagePickedSuccessState());
    }
  }

  removeImage(index){
    myDocs[myDocs.keys.elementAt(index)]=null;
    emit(ImageRemoveSuccessState());

  }

}
