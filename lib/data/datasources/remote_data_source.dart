import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:more4u/data/models/gift_model.dart';
import 'package:more4u/data/models/profile_and_docuemnts_model.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../core/constants/api_path.dart';
import '../../domain/entities/benefit_request.dart';
import '../../domain/entities/filtered_search.dart';
import '../models/benefit_model.dart';
import '../models/benefit_request_model.dart';
import '../models/login_response_model.dart';
import '../models/manage_requests_response_model.dart';
import '../models/noitification_model.dart';
import '../models/participant_model.dart';
import '../models/privilege_model.dart';
import '../models/user_model.dart';

abstract class RemoteDataSource {
  Future<LoginResponseModel> loginUser({
    required String employeeNumber,
    required String pass,
  });

  Future<String> updateToken({
    required int employeeNumber,
    required String token,
  });

  Future<String> getEmployeeProfilePicture({
    required int employeeNumber,
  });

  Future<UserModel> updateProfilePicture(
      {required int employeeNumber, required String photo});

  Future<String> changePassword({
    required int employeeNumber,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<BenefitModel> getBenefitDetails({required int benefitId});

  Future<List<BenefitModel>> getMyBenefits({required int employeeNumber});

  Future<List<GiftModel>> getMyGifts(
      {required int employeeNumber, required int requestNumber});

  Future<List<PrivilegeModel>> getPrivileges();

  Future<List<BenefitRequest>> getMyBenefitRequests({
    required int employeeNumber,
    required int benefitId,
    int? requestNumber,
  });

  Future<String> cancelRequest({
    required int employeeNumber,
    required int benefitId,
    required int requestNumber,
  });

  Future<String> addResponse({
    required int employeeNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
  });

  Future<ManageRequestsResponseModel> getBenefitsToManage({
    required int employeeNumber,
    FilteredSearch? search,
    int? requestNumber,
  });

  Future<ProfileAndDocumentsModel> getRequestProfileAndDocuments({
    required int employeeNumber,
    required int requestNumber,
  });

  Future<List<ParticipantModel>> getParticipants({
    required int employeeNumber,
    required int benefitId,
    required bool isGift,
  });

  Future<void> redeemCard({required BenefitRequestModel requestModel});

  Future<List<NotificationModel>> getNotifications(
      {required int employeeNumber});
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

class RemoteDataSourceImpl extends RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<BenefitModel> getBenefitDetails({required int benefitId}) {
    throw UnimplementedError();
  }

  @override
  Future<ManageRequestsResponseModel> getBenefitsToManage({
    required int employeeNumber,
    FilteredSearch? search,
    int? requestNumber,
  }) async {
    if (search != null) {
      print(jsonEncode({
        "selectedBenefitType": search.selectedBenefitType,
        "selectedRequestStatus": search.selectedRequestStatus,
        "employeeNumberSearch": search.employeeNumberSearch,
        "selectedDepartmentId": search.selectedDepartmentId,
        "selectedTimingId": search.selectedTimingId,
        "hasWarningMessage": search.hasWarningMessage,
        "searchDateFrom": search.searchDateFrom,
        "searchDateTo": search.searchDateTo,
        "selectedAll": false,
        "employeeNumber": employeeNumber,
      }));
    }
    final response = search != null
        ? await client.post(Uri.parse(showRequests),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "selectedBenefitType": search.selectedBenefitType,
              "selectedRequestStatus": search.selectedRequestStatus,
              "employeeNumberSearch": search.employeeNumberSearch,
              "selectedDepartmentId": search.selectedDepartmentId,
              "selectedTimingId": search.selectedTimingId,
              "hasWarningMessage": search.hasWarningMessage,
              "searchDateFrom": search.searchDateFrom,
              "searchDateTo": search.searchDateTo,
              "selectedAll": false,
              "employeeNumber": employeeNumber,
            }))
        : await client.post(
            Uri.parse(showRequestsDefault).replace(queryParameters: {
              "employeeNumber": employeeNumber.toString(),
              "requestNumber": requestNumber.toString(),
            }),
            headers: {
              'Content-Type': 'application/json',
            },
          );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      ManageRequestsResponseModel manageRequestsResponseModel =
          ManageRequestsResponseModel.fromJson(result);

      return manageRequestsResponseModel;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<ProfileAndDocumentsModel> getRequestProfileAndDocuments(
      {required int employeeNumber, required int requestNumber}) async {
    final response = await client.post(
      Uri.parse(getProfilePictureAndRequestDocuments).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
        "requestNumber": requestNumber.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return ProfileAndDocumentsModel.fromJson(result['data']);
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<BenefitRequest>> getMyBenefitRequests(
      {required int employeeNumber,
      required int benefitId,
      int? requestNumber}) async {
    final response = await client.post(
      Uri.parse(showMyBenefitRequests).replace(queryParameters: {
        "EmployeeNumber": employeeNumber.toString(),
        "BenefitId": benefitId.toString(),
        "requestNumber": requestNumber.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<BenefitRequestModel> myBenefitRequests = [];
      for (Map<String, dynamic> myBenefitRequest in result['data']) {
        myBenefitRequests.add(BenefitRequestModel.fromJson(myBenefitRequest));
      }
      return myBenefitRequests;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<PrivilegeModel>> getPrivileges() async {
    final response = await client.get(
      Uri.parse(getPrivilegesEndPoint),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<PrivilegeModel> privileges = [];
      for (Map<String, dynamic> privilege in result['data']) {
        privileges.add(PrivilegeModel.fromJson(privilege));
      }
      return privileges;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<BenefitModel>> getMyBenefits(
      {required int employeeNumber}) async {
    final response = await client.post(
      Uri.parse(showMyBenefits).replace(queryParameters: {
        "EmployeeNumber": employeeNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<BenefitModel> myBenefits = [];

      for (var benefit in result['data']) {
        myBenefits.add(BenefitModel.fromJson(benefit));
      }
      return myBenefits;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<GiftModel>> getMyGifts(
      {required int employeeNumber, int? requestNumber}) async {
    final response = await client.post(
      Uri.parse(showMyGifts).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
        "requestNumber": requestNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<GiftModel> myGifts = [];

      for (var gift in result['data']) {
        myGifts.add(GiftModel.fromJson(gift));
      }
      return myGifts;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications(
      {required int employeeNumber}) async {
    final response = await client.post(
      Uri.parse(showNotifications).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<NotificationModel> notifications = [];
      if (result['data'] != null) {
        for (var notification in result['data']) {
          notifications.add(NotificationModel.fromJson(notification));
        }
      }
      return notifications;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<List<ParticipantModel>> getParticipants(
      {required int employeeNumber,
      required int benefitId,
      required bool isGift}) async {
    final response = await client.post(
      Uri.parse(isGift ? whoCanIGiveThisBenefit : whoCanRedeemThisGroupBenefit)
          .replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
        "benefitId": benefitId.toString()
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      List<ParticipantModel> participants = [];

      for (var participant in result['data']) {
        participants.add(ParticipantModel.fromJson(participant));
      }
      return participants;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<LoginResponseModel> loginUser(
      {required String employeeNumber, required String pass}) async {
    final response = await client.post(Uri.parse(userLogin),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "employeeNumber": int.parse(employeeNumber),
            "password": pass,
            "rememberMe": true,
            "email": "string"
          },
        ));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);

      print(result);
      LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(result);
      return loginResponseModel;
    } else {
      print('nooooooooooooooo');
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<void> redeemCard({required BenefitRequestModel requestModel}) async {
    print(jsonEncode(requestModel.toJson()));

    final response = await client.post(Uri.parse(confirmRequest),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestModel.toJson()));

    if (response.statusCode == 200) {
      return;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<String> getEmployeeProfilePicture({
    required int employeeNumber,
  }) async {
    final response = await client.post(
      Uri.parse(getEmployeeProfilePictureEndPoint).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['data'];
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<String> updateToken({
    required int employeeNumber,
    required String token,
  }) async {
    final response = await client.post(
      Uri.parse(refreshTokenAPI).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
        "newToken": token,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      return result['message'];
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<String> cancelRequest({
    required int employeeNumber,
    required int benefitId,
    required int requestNumber,
  }) async {
    final response = await client.post(
      Uri.parse(requestCancel).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
        "benefitId": benefitId.toString(),
        "id": requestNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);

      return result['message'];
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<String> addResponse({
    required int employeeNumber,
    required int status,
    required int requestWorkflowId,
    required String message,
  }) async {
    print({
      "requestWorkflowId": requestWorkflowId.toString(),
      "status": status.toString(),
      "message": message,
      "employeeNumber": employeeNumber.toString(),
    });

    final response = await client.post(
      Uri.parse(addRequestResponse).replace(queryParameters: {
        "requestWorkflowId": requestWorkflowId.toString(),
        "status": status.toString(),
        "message": message,
        "employeeNumber": employeeNumber.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);

      return result['message'];
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<UserModel> updateProfilePicture(
      {required int employeeNumber, required String photo}) async {
    final response = await client.post(
      Uri.parse(updateProfilePictureEndPoint).replace(queryParameters: {
        "employeeNumber": employeeNumber.toString(),
      }),
      body: jsonEncode({'photo': photo}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);

      UserModel user = UserModel.fromJson(result['data']);
      return user;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }

  @override
  Future<String> changePassword(
      {required int employeeNumber,
      required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    final response = await client.post(
      Uri.parse(changePasswordEndPoint),
      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "employeeNumber": employeeNumber
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);

      return result['message'];
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      print(result);
      if (result.isNotEmpty && result['message'] != null) {
        throw ServerException(result['message']);
      } else {
        throw ServerException('Something went wrong!');
      }
    }
  }
}
//
// class FakeRemoteDataSourceImpl extends RemoteDataSource {
//   @override
//   Future<LoginResponseModel> loginUser({
//     required String employeeNumber,
//     required String pass,
//   }) async {
//     // String response = await rootBundle.loadString('assets/response3.json');
//     String response =
//         await rootBundle.loadString('assets/endpoints/loginEndPoint.json');
//
//     return LoginResponseModel.fromJson(jsonDecode(response));
//   }
//
//   @override
//   Future<BenefitModel> getBenefitDetails({required int benefitId}) async {
//     String response =
//         await rootBundle.loadString('assets/benefit_details.json');
//     var json = jsonDecode(response);
//     return BenefitModel.fromJson(json['data']);
//   }
//
//   @override
//   Future<List<BenefitModel>> getMyBenefits(
//       {required int employeeNumber}) async {
//     // String response =
//     //     await rootBundle.loadString('assets/mybenefits_response.json');
//     String response = await rootBundle
//         .loadString('assets/endpoints/Benefits_I_requested.json');
//     var json = jsonDecode(response);
//     List<BenefitModel> myBenefits = [];
//     for (Map<String, dynamic> benefit in json['data']) {
//       print(benefit);
//       myBenefits.add(BenefitModel.fromJson(benefit));
//     }
//     print(myBenefits);
//     return myBenefits;
//   }
//
//   @override
//   Future<List<BenefitRequest>> getMyBenefitRequests(
//       {required int employeeNumber, required int benefitId}) async {
//     // String response =
//     //     await rootBundle.loadString('assets/my_benefit_requests.json');
//
//     String response =
//         await rootBundle.loadString('assets/endpoints/BenefitRequests.json');
//     var json = jsonDecode(response);
//     List<BenefitRequestModel> myBenefitRequests = [];
//     for (Map<String, dynamic> myBenefitRequest in json['data']) {
//       myBenefitRequests.add(BenefitRequestModel.fromJson(myBenefitRequest));
//     }
//     print(myBenefitRequests);
//     return myBenefitRequests;
//   }
//
//   @override
//   Future<List<BenefitRequest>> getBenefitsToManage(
//       {required int employeeNumber, FilteredSearch? search}) async {
//     // String response =
//     // await rootBundle.loadString('assets/manage_request_response.json');
//     String response = await rootBundle
//         .loadString('assets/endpoints/ManageRequestsDefault.json');
//     var json = jsonDecode(response);
//     List<BenefitRequestModel> benefitRequests = [];
//     for (Map<String, dynamic> benefitRequest in json['data']['requests']) {
//       benefitRequests.add(BenefitRequestModel.fromJson(benefitRequest));
//     }
//     print(benefitRequests);
//     return benefitRequests;
//   }
//
//   @override
//   Future<List<ParticipantModel>> getParticipants(
//       {required int employeeNumber,
//       required int benefitId,
//       required bool isGift}) async {
//     // String response = await rootBundle.loadString('assets/participants.json');
//     String response = await rootBundle
//         .loadString('assets/endpoints/WhoCanIGiveThisBenefit.json');
//     var json = jsonDecode(response);
//     List<ParticipantModel> participants = [];
//     for (Map<String, dynamic> participant in json['data']) {
//       participants.add(ParticipantModel.fromJson(participant));
//     }
//     print(participants);
//     return participants;
//
//     // return LoginResponseModel.fromJson(jsonDecode(response));
//   }
//
//   @override
//   Future<void> redeemCard({required BenefitRequestModel requestModel}) async {
//     print(requestModel.toJson());
//   }
//
//   @override
//   Future<List<NotificationModel>> getNotifications(
//       {required int employeeNumber}) async {
//     // String response = await rootBundle.loadString('assets/participants.json');
//     String response = await rootBundle
//         .loadString('assets/endpoints/NotificationEndPoint.json');
//     var json = jsonDecode(response);
//     List<NotificationModel> notifications = [];
//     for (Map<String, dynamic> notification in json['data']) {
//       notifications.add(NotificationModel.fromJson(notification));
//     }
//     print(notifications);
//     return notifications;
//
//     // return LoginResponseModel.fromJson(jsonDecode(response));
//   }
//
//   @override
//   Future<String> cancelRequest(
//       {required int employeeNumber,
//       required int benefitId,
//       required int requestNumber}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String> addResponse(
//       {required int employeeNumber,
//       required int status,
//       required int requestNumber,
//       required String message}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<UserModel> updateProfilePicture(
//       {required int employeeNumber, required String photo}) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String> changePassword({required int employeeNumber, required String oldPassword, required String newPassword, required String confirmPassword}) {
//     throw UnimplementedError();
//   }
// }
