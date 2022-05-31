import 'package:more4u/domain/entities/participant.dart';

import '../../domain/entities/my_benefit_request.dart';

class MyBenefitRequestModel extends MyBenefitRequest {
  MyBenefitRequestModel({
    String? message,
    String? groupName,
    List<int>? participants,
    int? sendTo,
    required int benefitId,
    required int employeeNumber,
    required String from,
    required String to,
    List<Participant>? participantsData,
    String? benefitName,
    int? requestStatusId,
    bool? canCancel,
    bool? canEdit,
    List<RequestWorkFlowAPIs>? requestWorkFlowAPIs,
  }) : super(
          message: message,
          groupName: groupName,
          participants: participants,
          sendTo: sendTo,
          benefitId: benefitId,
          employeeNumber: employeeNumber,
          from: from,
          to: to,
          participantsData: participantsData,
          benefitName: benefitName,
          requestStatusId: requestStatusId,
          canCancel: canCancel,
          canEdit: canEdit,
          requestWorkFlowAPIs: requestWorkFlowAPIs,
        );

  factory MyBenefitRequestModel.fromJson(Map<String, dynamic> json) =>
      MyBenefitRequestModel(
        message: json['message'],
        groupName: json['groupName'],
        participants: json['participants'],
        sendTo: json['sendTo'],
        benefitId: json['benefitId'],
        employeeNumber: json['employeeNumber'],
        from: json['from'],
        to: json['to'],
        participantsData: List<Participant>.from(json['participantsData']
            .map((x) => RequestWorkFlowAPIsModel.fromJson(x))
            .toList()),
        benefitName: json['benefitName'],
        requestStatusId: json['requestStatusId'],
        canCancel: json['canCancel'],
        canEdit: json['canEdit'],
        requestWorkFlowAPIs: List<RequestWorkFlowAPIsModel>.from(
            json['requestWorkFlowAPIs']
                .map((x) => RequestWorkFlowAPIsModel.fromJson(x))
                .toList()),
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

  factory MyBenefitRequestModel.fromEntity(
          MyBenefitRequestModel myBenefitRequestModel) =>
      MyBenefitRequestModel(
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
