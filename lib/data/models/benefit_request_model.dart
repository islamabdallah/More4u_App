import 'package:more4u/domain/entities/participant.dart';

import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/user.dart';
import 'participant_model.dart';
import 'user_model.dart';

class BenefitRequestModel extends BenefitRequest {
  const BenefitRequestModel({
    int? requestNumber,
    int? requestWorkflowId,
    String? from,
    String? to,
    String? message,
    String? groupName,
    String? selectedEmployeeNumbers,
    // List<int>? participants,
    List<Participant>? participantsData,
    List<User>? fullParticipantsData,
    int? sendToID,
    User? sendToModel,
    int? employeeNumber,
    String? requestedat,
    bool? hasDocuments,
    List<String>? documents,

    //benefit data
    int? benefitId,
    String? benefitName,
    String? benefitType,
    String? benefitCard,

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
    MyAction? myAction,
  }) : super(
          requestNumber: requestNumber,
          requestWorkflowId: requestWorkflowId,
          from: from,
          to: to,
          message: message,
          groupName: groupName,
          selectedEmployeeNumbers: selectedEmployeeNumbers,
          // participants: participants,
          participantsData: participantsData,
          fullParticipantsData: fullParticipantsData,
          sendToID: sendToID,
          sendToModel: sendToModel,
          employeeNumber: employeeNumber,
          requestedat: requestedat,
          hasDocuments: hasDocuments,
          documents: documents,
          benefitId: benefitId,
          benefitName: benefitName,
          benefitType: benefitType,
          benefitCard: benefitCard,
          status: status,
          requestStatusId: requestStatusId,
          canCancel: canCancel,
          canEdit: canEdit,
          requestWorkFlowAPIs: requestWorkFlowAPIs,
          createdBy: createdBy,
          warningMessage: warningMessage,
          employeeCanResponse: employeeCanResponse,
          myAction: myAction,
        );

  factory BenefitRequestModel.fromJson(Map<String, dynamic> json) =>
      BenefitRequestModel(
          requestNumber: json['requestNumber'],
          requestWorkflowId: json['requestWorkflowId'],
          from: json['from'],
          to: json['to'],
          message: json['message'],
          groupName: json['groupName'],
          selectedEmployeeNumbers: json['selectedEmployeeNumbers'],
          // participants: json['participants'],
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
          sendToID: json['sendToID'],
          sendToModel: json['sendToModel'] != null
              ? UserModel.fromJson(json['sendToModel'])
              : null,
          employeeNumber: json['employeeNumber'],
          requestedat: json['requestedat'],
          hasDocuments: json['hasDocuments'],
          documents: json['documents']?.cast<String>(),
          benefitId: json['benefitId'],
          benefitName: json['benefitName'],
          benefitType: json['benefitType'],
          benefitCard: json['benefitCard'],
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
          myAction: json['myAction'] != null
              ? MyActionModel.fromJson(json['myAction'])
              : null);

  Map<String, dynamic> toJson() {
    return {
      "employeeNumber": employeeNumber,
      'groupName': groupName,
      'selectedEmployeeNumbers': selectedEmployeeNumbers,
      // 'participants': participants,
      "sendToID": sendToID,
      "benefitId": benefitId,
      "from": from,
      "to": to,
      "message": message,
      'documents': documents,
    };
  }

  factory BenefitRequestModel.fromEntity(BenefitRequest myBenefitRequest) =>
      BenefitRequestModel(
        message: myBenefitRequest.message,
        groupName: myBenefitRequest.groupName,
        selectedEmployeeNumbers: myBenefitRequest.selectedEmployeeNumbers,
        // participants: myBenefitRequest.participants,
        sendToID: myBenefitRequest.sendToID,
        benefitId: myBenefitRequest.benefitId,
        employeeNumber: myBenefitRequest.employeeNumber,
        from: myBenefitRequest.from,
        to: myBenefitRequest.to,
        documents: myBenefitRequest.documents,
        participantsData: myBenefitRequest.participantsData,
        benefitName: myBenefitRequest.benefitName,
        requestStatusId: myBenefitRequest.requestStatusId,
        canCancel: myBenefitRequest.canCancel,
        canEdit: myBenefitRequest.canEdit,
        requestWorkFlowAPIs: myBenefitRequest.requestWorkFlowAPIs,
      );
}

class RequestWorkFlowAPIsModel extends RequestWorkFlowAPIs {
  RequestWorkFlowAPIsModel({
    int? employeeNumber,
    String? employeeName,
    String? status,
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

class MyActionModel extends MyAction {
  const MyActionModel({
    String? action,
    String? notes,
    String? replayDate,
    String? whoIsResponseName,
  }) : super(
          action: action,
          notes: notes,
          replayDate: replayDate,
          whoIsResponseName: whoIsResponseName,
        );

  factory MyActionModel.fromJson(Map<String, dynamic> json) => MyActionModel(
        action: json['action'],
        notes: json['notes'],
        replayDate: json['replayDate'],
        whoIsResponseName: json['whoIsResponseName'],
      );
}
