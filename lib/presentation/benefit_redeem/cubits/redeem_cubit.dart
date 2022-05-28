import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:more4u/domain/usecases/get_participants.dart';

import '../../../core/constants/constants.dart';
import '../../../domain/entities/benefit.dart';
import '../../../domain/entities/participant.dart';
import '../../../domain/usecases/redeem_card.dart';

part 'redeem_state.dart';

class RedeemCubit extends Cubit<RedeemState> {
  static RedeemCubit get(context) => BlocProvider.of(context);
  final GetParticipantsUsecase getParticipantsUsecase;

  RedeemCubit({required this.getParticipantsUsecase}) : super(RedeemInitial());

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

  redeemCard() {
    _validateInputs();
    var request = RedeemRequest(
      participants: benefit.benefitType == 'Group' ? participantsIds : null,
      sendTo: benefit.isAgift ? participantsIds.first : null,
      from: startDate.text,
      to: endDate.text,
      benefitId: benefit.id,
      employeeNumber: userData!.employeeNumber,
      groupName: groupName.text,
      message: message.text,
    );

    print(request);
  }

  String? lowParticipantError;

  _validateInputs() {
    if(participantsIds.length<benefit.minParticipant){
    lowParticipantError = 'Participants should be between ${benefit.minParticipant} and ${benefit.maxParticipant}';
    } else{
      lowParticipantError = null;
    }
    emit(ErrorValidationState());
  }
}
