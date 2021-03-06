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
  String? dateToMatch;

  late bool showParticipantsField;
  late bool enableParticipantsField = true;

  initRedeem(Benefit benefit) {

    if(benefit.requiredDocumentsArray!=null){
      myDocs = {
        for (var doc in benefit.requiredDocumentsArray!) doc: null,
      };
    }
    this.benefit = benefit;
    _configureDate(benefit);
    startDate.text = _formatDate(start);
    endDate.text = _formatDate(end);
    if (benefit.benefitType == 'Group' || benefit.isAgift) {
      showParticipantsField = true;
      // getParticipants();
    } else {
      showParticipantsField = false;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  _configureDate(Benefit benefit) {
    switch (benefit.dateToMatch) {
      case 'Birth Date':
        date = DateTime.parse(userData!.birthDate);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
        break;
      case 'join Date':
        date = DateTime.parse(userData!.joinDate);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
        break;
      case 'Certain Date':
        date = DateTime.parse(benefit.certainDate!);
        dateToMatch =
            _formatDate(DateTime(DateTime.now().year, date.month, date.day));
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
    final result = await getParticipantsUsecase(
        employeeNumber: userData!.employeeNumber,
        benefitId: benefit.id,
        isGift: benefit.isAgift);

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
    if (  benefit.benefitType == 'Group'&& selectedParticipants.length == benefit.maxParticipant-1) {
      enableParticipantsField = false;
      emit(ParticipantsChangedState());
    }
    else if (benefit.isAgift && selectedParticipants.length == benefit.maxParticipant) {
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
    if (validateParticipants()) {
      emit(RedeemLoadingState());

      List<String> documents = [];
      for (var doc in myDocs.values) {
        if (doc != null) documents.add(doc);
      }

      var request = BenefitRequest(
        selectedEmployeeNumbers:
            benefit.benefitType == 'Group' ? participantsIds.join(';') : null,
        // participants: benefit.benefitType == 'Group' ? participantsIds : null,
        sendToID: benefit.isAgift && participantsIds.isNotEmpty
            ? participantsIds.first
            : 0,
        from: startDate.text,
        to: endDate.text,
        benefitId: benefit.id,
        employeeNumber: userData!.employeeNumber,
        groupName: groupName.text,
        message: message.text,
        documents: documents,
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

  bool validateParticipants() {
    if (benefit.benefitType == 'Group' &&
        participantsIds.length+1 < benefit.minParticipant) {
        lowParticipantError =
            'Participants should be between ${benefit.minParticipant} and ${benefit.maxParticipant} Including You';
        emit(ErrorValidationState());
        return false;
      } else if (benefit.isAgift&&participantsIds.length < benefit.minParticipant )
      {
        lowParticipantError = 'required';
        emit(ErrorValidationState());
        return false;
      }


     else {
      lowParticipantError = null;
      emit(ErrorValidationState());
    }
    return true;
  }

  //documents

  String? missingDocs;

  static List<String> requiredDocs = [];

  Map<String, String?> myDocs = {
  };

  pickImage(String key) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery // maxHeight: 200,
            );
    if (image != null) {
      File imageFile = File(image.path);
      Uint8List bytes = imageFile.readAsBytesSync();
      // Uint8List bytes = await imageFile.readAsBytes();

      String img64 = base64Encode(bytes);
      myDocs[key] = img64;
      // images.add(File(image.path));

      emit(ImagePickedSuccessState());
    }
  }

  removeImage(index) {
    myDocs[myDocs.keys.elementAt(index)] = null;
    emit(ImageRemoveSuccessState());
  }

  bool validateDocuments() {
    if (benefit.requiredDocumentsArray != null) {
      for (var img in myDocs.values) {
        if (img == null) {
          missingDocs = 'Missing Required Docs!';
          emit(ErrorValidationState());
          return false;
        }
      }
    } else {
      missingDocs = null;
      emit(ErrorValidationState());
    }
    return true;
  }
}
