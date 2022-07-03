import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more4u/data/datasources/remote_data_source.dart';
import 'package:more4u/data/models/benefit_model.dart';
import 'package:more4u/data/models/login_response_model.dart';
import 'package:more4u/data/models/user_model.dart';


main() {

    test(
      'test FakeRemoteDataSource',
      () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
        RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
        //act
       final result = await remoteDataSource.loginUser(employeeNumber: 'test', pass: 'test');
        //assert
        print(result);
      },
    );


    test(
      'test FakeBenefitRemoteDataSource',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
       RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getBenefitDetails(benefitId: 42);
        //assert
        print(result);
      },
    );
    //
    // test(
    //   'test FakeRedeemRemoteDataSource',
    //       () async {
    //     //arrange
    //     TestWidgetsFlutterBinding.ensureInitialized();
    //     RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
    //     //act
    //     final result = await remoteDataSource.getParticipants();
    //     //assert
    //     print(result);
    //   },
    // );

    test(
      'test FakeMyBenefitsRemoteDataSourceImpl',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
     RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getMyBenefits(employeeNumber: 15);
        //assert
        print(result);
      },
    );

    test(
      'test FakeMyBenefitsRemoteDataSourceImpl2',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
      RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getMyBenefitRequests(employeeNumber: 15, benefitId: 18);
        //assert
        print(result);
      },
    );

    test(
      'test notifications',
          () async {
        //arrange
        TestWidgetsFlutterBinding.ensureInitialized();
        RemoteDataSource remoteDataSource = FakeRemoteDataSourceImpl();
        //act
        final result = await remoteDataSource.getNotifications(employeeNumber: 15);
        //assert
        print(result);
      },
    );

}
