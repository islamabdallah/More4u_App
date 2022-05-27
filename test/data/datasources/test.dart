import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more4u/data/datasources/benefit_remote_data_source.dart';
import 'package:more4u/data/datasources/login_remote_data_source.dart';
import 'package:more4u/data/datasources/redeem_remote_data_source.dart';
import 'package:more4u/data/models/benefit_model.dart';
import 'package:more4u/data/models/login_response_model.dart';
import 'package:more4u/data/models/user_model.dart';


main() {

    test(
      'test FakeRemoteDataSource',
      () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
        LoginRemoteDataSource remoteDataSource = FakeLoginRemoteDataSourceImpl();
        //act
       final result = await remoteDataSource.loginUser(username: 'test', pass: 'test');
        //assert
        print(result);
      },
    );


    test(
      'test FakeBenefitRemoteDataSource',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
        BenefitRemoteDataSource remoteDataSource = FakeBenefitRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getBenefitDetails(benefitId: 42);
        //assert
        print(result);
      },
    );

    test(
      'test FakeRedeemRemoteDataSource',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
        RedeemRemoteDataSource remoteDataSource = FakeRedeemRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getParticipants();
        //assert
        print(result);
      },
    );

}
