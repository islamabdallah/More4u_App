import 'dart:convert';
import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:more4u/data/models/benefit_model.dart';
import 'package:more4u/data/models/login_response_model.dart';
import 'package:more4u/data/models/user_model.dart';

import 'helpers/json_reader.dart';

main() {

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('from json', () {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_responses/response.json'),
    );

    test(
      'test UserModel',
      () {
        final result = UserModel.fromJson(jsonMap['user']);
        print(result);
      },
    );

    test(
      'test BenefitModel',
      () {
        final result = BenefitModel.fromJson(jsonMap['benefitModels'][0]);
        print(result);
      },
    );

    test(
      'test LoginResponseModel',
          () {
        final result = LoginResponseModel.fromJson(jsonMap);
        print(result);
      },
    );

    test('string to date',(){
      String birthday = "2021-12-01T00:00:00";
      print(DateTime.parse(birthday).toString());

    },
    );

  });
}
