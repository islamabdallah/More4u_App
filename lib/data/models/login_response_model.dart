import 'package:equatable/equatable.dart';
import 'package:more4u/domain/entities/benefit.dart';

import 'package:more4u/domain/entities/user.dart';

import './user_model.dart';
import '../../domain/entities/login_response.dart';
import '../../../../../core/models/base_model.dart';
import 'benefit_model.dart';

class LoginResponseModel extends LoginResponse {
  LoginResponseModel(
      {required String message,
      required User user,
      required List<Benefit> benefitModels,
      required List<Benefit>? availableBenefitModels})
      : super(
            message: message,
            user: user,
            benefitModels: benefitModels,
            availableBenefitModels: availableBenefitModels);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        message: json['message'],
        user: UserModel.fromJson(json['data']['user']),
        benefitModels: List<BenefitModel>.from(json['data']['allBenefitModels']
            .map((x) => BenefitModel.fromJson(x))
            .toList()),
        availableBenefitModels: json['data']['availableBenefitModels'] != null
            ? List<BenefitModel>.from(json['data']['availableBenefitModels']
                .map((x) => BenefitModel.fromJson(x))
                .toList())
            : null);
  }
}
