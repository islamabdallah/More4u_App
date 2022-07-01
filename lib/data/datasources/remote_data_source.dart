import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/errors/exceptions.dart';
import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/filtered_search.dart';
import '../models/benefit_model.dart';
import '../models/benefit_request_model.dart';
import '../models/login_response_model.dart';
import '../models/noitification_model.dart';
import '../models/participant_model.dart';

abstract class RemoteDataSource {
  Future<LoginResponseModel> loginUser({
    required String employeeNumber,
    required String pass,
  });

  Future<BenefitModel> getBenefitDetails({required int benefitId});

  Future<List<BenefitModel>> getMyBenefits({required int employeeNumber});

  Future<List<BenefitRequest>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
  });

  Future<List<BenefitRequest>> getBenefitsToManage({
    required int employeeNumber,
    FilteredSearch? search,
  });

  Future<List<ParticipantModel>> getParticipants();

  Future<void> redeemCard({required BenefitRequestModel requestModel});

  Future<List<NotificationModel>> getNotifications({required int employeeNumber});
}

// class RemoteDataSourceImpl extends RemoteDataSource {
//   final http.Client client;
//
//   RemoteDataSourceImpl({required this.client});
//
//   @override
//   Future<LoginResponseModel> loginUser(
//       {required String username, required String pass}) async {
//     var url = Uri.parse('http://20.86.97.165/hazard/api/checkpoints/User');
//     var response = await client.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"username": username, "pass": pass}),
//     );
//     if (response.statusCode == 200) {
//       // print('Response status: ${response.statusCode}');
//       // print('Response body: ${response.body}');
//       Map<String, dynamic> result = jsonDecode(response.body);
//
//       print(result);
//       LoginResponseModel loginResponseModel =
//           LoginResponseModel.fromJson(result);
//       return loginResponseModel;
//     } else {
//       // print(response.statusCode);
//       // throw ServerException('');
//       Map<String, dynamic> result = jsonDecode(response.body);
//       if (result.isNotEmpty && result['message'] != null) {
//         throw ServerException(result['message']);
//       } else {
//         throw ServerException('Something went wrong!');
//       }
//     }
//   }
// }

class FakeRemoteDataSourceImpl extends RemoteDataSource {
  @override
  Future<LoginResponseModel> loginUser({
    required String employeeNumber,
    required String pass,
  }) async {
    // String response = await rootBundle.loadString('assets/response3.json');
    String response =
        await rootBundle.loadString('assets/endpoints/loginEndPoint.json');

    return LoginResponseModel.fromJson(jsonDecode(response));
  }

  @override
  Future<BenefitModel> getBenefitDetails({required int benefitId}) async {
    String response =
        await rootBundle.loadString('assets/benefit_details.json');
    var json = jsonDecode(response);
    return BenefitModel.fromJson(json['data']);
  }

  @override
  Future<List<BenefitModel>> getMyBenefits(
      {required int employeeNumber}) async {
    // String response =
    //     await rootBundle.loadString('assets/mybenefits_response.json');
    String response = await rootBundle
        .loadString('assets/endpoints/Benefits_I_requested.json');
    var json = jsonDecode(response);
    List<BenefitModel> myBenefits = [];
    for (Map<String, dynamic> benefit in json['data']) {
      print(benefit);
      myBenefits.add(BenefitModel.fromJson(benefit));
    }
    print(myBenefits);
    return myBenefits;
  }

  @override
  Future<List<BenefitRequest>> getMyBenefitRequests(
      {required int employeeNumber, required int benefitId}) async {
    // String response =
    //     await rootBundle.loadString('assets/my_benefit_requests.json');

    String response =
        await rootBundle.loadString('assets/endpoints/BenefitRequests.json');
    var json = jsonDecode(response);
    List<BenefitRequestModel> myBenefitRequests = [];
    for (Map<String, dynamic> myBenefitRequest in json['data']) {
      myBenefitRequests.add(BenefitRequestModel.fromJson(myBenefitRequest));
    }
    print(myBenefitRequests);
    return myBenefitRequests;
  }

  @override
  Future<List<BenefitRequest>> getBenefitsToManage(
      {required int employeeNumber, FilteredSearch? search}) async {
    // String response =
    // await rootBundle.loadString('assets/manage_request_response.json');
    String response = await rootBundle
        .loadString('assets/endpoints/ManageRequestsDefault.json');
    var json = jsonDecode(response);
    List<BenefitRequestModel> benefitRequests = [];
    for (Map<String, dynamic> benefitRequest in json['data']['requests']) {
      benefitRequests.add(BenefitRequestModel.fromJson(benefitRequest));
    }
    print(benefitRequests);
    return benefitRequests;
  }

  @override
  Future<List<ParticipantModel>> getParticipants() async {
    // String response = await rootBundle.loadString('assets/participants.json');
    String response = await rootBundle
        .loadString('assets/endpoints/WhoCanIGiveThisBenefit.json');
    var json = jsonDecode(response);
    List<ParticipantModel> participants = [];
    for (Map<String, dynamic> participant in json['data']) {
      participants.add(ParticipantModel.fromJson(participant));
    }
    print(participants);
    return participants;

    // return LoginResponseModel.fromJson(jsonDecode(response));
  }

  @override
  Future<void> redeemCard({required BenefitRequestModel requestModel}) async {
    print(requestModel.toJson());
  }

  @override
  Future<List<NotificationModel>> getNotifications({required int employeeNumber}) async {
    // String response = await rootBundle.loadString('assets/participants.json');
    String response = await rootBundle
        .loadString('assets/endpoints/NotificationEndPoint.json');
    var json = jsonDecode(response);
    List<NotificationModel> notifications = [];
    for (Map<String, dynamic> notification in json['data']) {
      notifications.add(NotificationModel.fromJson(notification));
    }
    print(notifications);
    return notifications;

    // return LoginResponseModel.fromJson(jsonDecode(response));
  }
}