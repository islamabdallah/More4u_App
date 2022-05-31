import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:more4u/domain/entities/my_benefit_request.dart';

import '../../../../../core/errors/exceptions.dart';
import '../models/benefit_model.dart';
import '../models/login_response_model.dart';
import '../models/my_benefit_request_model.dart';

abstract class BenefitRemoteDataSource {
  Future<BenefitModel> getBenefitDetails({required int benefitId});

  Future<List<BenefitModel>> getMyBenefits({required int employeeNumber});

  Future<List<MyBenefitRequest>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
  });
}

// class BenefitRemoteDataSourceImpl extends BenefitRemoteDataSource {
//   final http.Client client;
//
//   BenefitRemoteDataSourceImpl({required this.client});
//
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

class FakeBenefitRemoteDataSourceImpl extends BenefitRemoteDataSource {
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
    String response =
        await rootBundle.loadString('assets/mybenefits_response.json');
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
  Future<List<MyBenefitRequest>> getMyBenefitRequests(
      {required int employeeNumber, required int benefitId}) async {
    String response =
        await rootBundle.loadString('assets/my_benefit_requests.json');
    var json = jsonDecode(response);
    List<MyBenefitRequestModel> myBenefitRequests = [];
    for (Map<String, dynamic> myBenefitRequest in json['data']) {
      myBenefitRequests.add(MyBenefitRequestModel.fromJson(myBenefitRequest));
    }
    print(myBenefitRequests);
    return myBenefitRequests;
  }
}
