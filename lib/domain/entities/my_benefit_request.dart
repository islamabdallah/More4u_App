import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/participant.dart';

class MyBenefitRequest extends Equatable {
  final String? message;
  final String? groupName;
  final List<int>? participants;
  final int? sendTo;
  final int benefitId;
  final int employeeNumber;
  final String from;
  final String to;
  final List<Participant>? participantsData;
  final String? benefitName;
  final int? requestStatusId;
  final bool? canCancel;
  final bool? canEdit;
  final List<RequestWorkFlowAPIs>? requestWorkFlowAPIs;

  const MyBenefitRequest(
      {this.message,
      this.groupName,
      this.participants,
      this.sendTo,
      required this.benefitId,
      required this.employeeNumber,
      required this.from,
      required this.to,
      this.participantsData,
      this.benefitName,
      this.requestStatusId,
      this.canCancel,
      this.canEdit,
      this.requestWorkFlowAPIs});

  @override
  List<Object?> get props => [
        benefitId,
        employeeNumber,
        message,
        groupName,
        participants,
        sendTo,
        from,
        to,
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
