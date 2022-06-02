import 'package:more4u/domain/entities/participant.dart';

import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/user.dart';
import 'participant_model.dart';
import 'user_model.dart';

class BenefitRequestModel extends BenefitRequest {
  const BenefitRequestModel({
    int? requestNumber,
    String? from,
    String? to,
    String? message,
    String? groupName,
    List<int>? participants,
    List<Participant>? participantsData,
    List<User>? fullParticipantsData,
    int? sendTo,
    User? sendToModel,
    int? employeeNumber,
    String? requestedAt,

    //benefit data
    int? benefitId,
    String? benefitName,
    String? benefitType,

    //my request
    String? status,
    int? requestStatusId,
    bool? canCancel,
    bool? canEdit,
    List<RequestWorkFlowAPIs>? requestWorkFlowAPIs,

    //manage request
    User? createdBy,
    String? warningMessage,
    bool? employeeCanResponse,
  }) : super(
          requestNumber: requestNumber,
          from: from,
          to: to,
          message: message,
          groupName: groupName,
          participants: participants,
          participantsData: participantsData,
          fullParticipantsData: fullParticipantsData,
          sendTo: sendTo,
          sendToModel: sendToModel,
          employeeNumber: employeeNumber,
          requestedAt: requestedAt,
          benefitId: benefitId,
          benefitName: benefitName,
          benefitType: benefitType,
          status: status,
          requestStatusId: requestStatusId,
          canCancel: canCancel,
          canEdit: canEdit,
          requestWorkFlowAPIs: requestWorkFlowAPIs,
          createdBy: createdBy,
          warningMessage: warningMessage,
          employeeCanResponse: employeeCanResponse,
        );

  factory BenefitRequestModel.fromJson(Map<String, dynamic> json) =>
      BenefitRequestModel(
        requestNumber: json['requestNumber'],
        from: json['from'],
        to: json['to'],
        message: json['message'],
        groupName: json['groupName'],
        participants: json['participants'],
        participantsData: json['participantsData'] != null
            ? List<Participant>.from(json['participantsData']
                .map((x) => ParticipantModel.fromJson(x))
                .toList())
            : null,
        fullParticipantsData: json['fullParticipantsData'] != null
            ? List<User>.from(json['fullParticipantsData']
                .map((x) => UserModel.fromJson(x))
                .toList())
            : null,
        sendTo: json['sendTo'],
        sendToModel: json['sendToModel'] != null
            ? UserModel.fromJson(json['sendToModel'])
            : null,
        employeeNumber: json['employeeNumber'],
        requestedAt: json['requestedAt'],
        benefitId: json['benefitId'],
        benefitName: json['benefitName'],
        benefitType: json['benefitType'],
        status: json['status'],
        requestStatusId: json['requestStatusId'],
        canCancel: json['canCancel'],
        canEdit: json['canEdit'],
        requestWorkFlowAPIs: json['requestWorkFlowAPIs'] != null
            ? List<RequestWorkFlowAPIsModel>.from(json['requestWorkFlowAPIs']
                .map((x) => RequestWorkFlowAPIsModel.fromJson(x))
                .toList())
            : null,
        createdBy: json['createdBy'] != null
            ? UserModel.fromJson(json['createdBy'])
            : null,
        warningMessage: json['warningMessage'],
        employeeCanResponse: json['employeeCanResponse'],
      );

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      'groupName': groupName,
      'participants': participants,
      "sendTo": sendTo,
      "benefitId": benefitId,
      "employeeNumber": employeeNumber,
      "from": from,
      "to": to,
    };
  }

  factory BenefitRequestModel.fromEntity(
          BenefitRequestModel myBenefitRequestModel) =>
      BenefitRequestModel(
        message: myBenefitRequestModel.message,
        groupName: myBenefitRequestModel.groupName,
        participants: myBenefitRequestModel.participants,
        sendTo: myBenefitRequestModel.sendTo,
        benefitId: myBenefitRequestModel.benefitId,
        employeeNumber: myBenefitRequestModel.employeeNumber,
        from: myBenefitRequestModel.from,
        to: myBenefitRequestModel.to,
        participantsData: myBenefitRequestModel.participantsData,
        benefitName: myBenefitRequestModel.benefitName,
        requestStatusId: myBenefitRequestModel.requestStatusId,
        canCancel: myBenefitRequestModel.canCancel,
        canEdit: myBenefitRequestModel.canEdit,
        requestWorkFlowAPIs: myBenefitRequestModel.requestWorkFlowAPIs,
      );
}

class RequestWorkFlowAPIsModel extends RequestWorkFlowAPIs {
  RequestWorkFlowAPIsModel({
    int? employeeNumber,
    String? employeeName,
    int? status,
    String? replayDate,
    String? notes,
  }) : super(
          employeeNumber: employeeNumber,
          employeeName: employeeName,
          status: status,
          replayDate: replayDate,
          notes: notes,
        );

  factory RequestWorkFlowAPIsModel.fromJson(Map<String, dynamic> json) =>
      RequestWorkFlowAPIsModel(
        employeeNumber: json['employeeNumber'],
        employeeName: json['employeeName'],
        status: json['status'],
        replayDate: json['replayDate'],
        notes: json['notes'],
      );
}
