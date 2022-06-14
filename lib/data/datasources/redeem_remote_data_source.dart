import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/participant_model.dart';

abstract class RedeemRemoteDataSource {
  Future<List<ParticipantModel>> getParticipants();
}

class FakeRedeemRemoteDataSourceImpl extends RedeemRemoteDataSource {
  @override
  Future<List<ParticipantModel>> getParticipants() async {
    // String response = await rootBundle.loadString('assets/participants.json');
    String response = await rootBundle.loadString('assets/endpoints/WhoCanIGiveThisBenefit.json');
    var json = jsonDecode(response);
    List<ParticipantModel> participants = [];
    for (Map<String, dynamic> participant in json['data']) {
      participants.add(ParticipantModel.fromJson(participant));
    }
    print(participants);
    return participants;

    // return LoginResponseModel.fromJson(jsonDecode(response));
  }
}
