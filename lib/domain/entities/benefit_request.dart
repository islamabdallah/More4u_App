import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/participant.dart';
import 'package:more4u/domain/entities/user.dart';

class BenefitRequest extends Equatable {
  final int? requestNumber;
  final String? from;
  final String? to;
  final String? message;
  final String? groupName;
  final List<int>? participants;
  final List<Participant>? participantsData;
  final List<User>? fullParticipantsData;
  final int? sendTo;
  final User? sendToModel;
  final int? employeeNumber;
  final String? requestedAt;

  //benefit data
  final int? benefitId;
  final String? benefitName;
  final String? benefitType;

  //my request
  final String? status;
  final int? requestStatusId;
  final bool? canCancel;
  final bool? canEdit;
  final List<RequestWorkFlowAPIs>? requestWorkFlowAPIs;

  //manage request
  final User? createdBy;
  final String? warningMessage;
  final bool? employeeCanResponse;

  const BenefitRequest(
      {this.requestNumber,
      this.from,
      this.to,
      this.message,
      this.groupName,
      this.participants,
      this.participantsData,
      this.fullParticipantsData,
      this.sendTo,
      this.sendToModel,
      this.employeeNumber,
      this.requestedAt,
      this.benefitId,
      this.benefitName,
      this.benefitType,
      this.status,
      this.requestStatusId,
      this.canCancel,
      this.canEdit,
      this.requestWorkFlowAPIs,
      this.createdBy,
      this.warningMessage,
      this.employeeCanResponse});

  @override
  List<Object?> get props => [
        requestNumber,
        from,
        to,
        message,
        groupName,
        participants,
        participantsData,
        fullParticipantsData,
        sendTo,
        sendToModel,
        employeeNumber,
        requestedAt,
        benefitId,
        benefitName,
        benefitType,
        status,
        requestStatusId,
        canCancel,
        canEdit,
        requestWorkFlowAPIs,
        createdBy,
    warningMessage,
        employeeCanResponse,
      ];

  String get statusString {
    switch (requestStatusId) {
      case 1:
        return 'Pending';
      case 2:
        return 'InProgress';
      case 3:
        return 'Approved';
      case 4:
        return 'Rejected';
      case 5:
        return 'Cancelled';
      case 6:
        return 'NotStartedYet';
      default:
        return 'Any';
    }
  }
}

class RequestWorkFlowAPIs {
  final int? employeeNumber;
  final String? employeeName;
  final int? status;
  final String? replayDate;
  final String? notes;

  RequestWorkFlowAPIs(
      {this.employeeNumber,
      this.employeeName,
      this.status,
      this.replayDate,
      this.notes});

  String get statusString {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'InProgress';
      case 3:
        return 'Approved';
      case 4:
        return 'Rejected';
      case 5:
        return 'Cancelled';
      case 6:
        return 'NotStartedYet';
      default:
        return 'Any';
    }
  }
}