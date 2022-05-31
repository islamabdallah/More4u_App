import 'dart:convert';
import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:more4u/data/models/benefit_model.dart';
import 'package:more4u/data/models/login_response_model.dart';
import 'package:more4u/data/models/my_benefit_request_model.dart';
import 'package:more4u/data/models/user_model.dart';

import 'helpers/json_reader.dart';

main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });


    test(
      'test MyBenefitRequestModel',
      () {
        final Map<String, dynamic> jsonMap = json.decode(
            readJson('helpers/dummy_responses/my_benefit_requests.json'));
        final result = MyBenefitRequestModel.fromJson(jsonMap['data'][0]);
        print(result);
        var j = result.toJson();
        print(j);
      },
    );

  test(
    'string to date',
    () {
      String birthday = "2021-12-01T00:00:00";
      print(DateTime.parse(birthday).toString());
    },
  );
}
