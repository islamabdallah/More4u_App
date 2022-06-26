import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class LocalDataSource {
  Future<void> cacheUser(String employeeNumber, String pass);
}

const CACHED_USER = 'CACHED_USER';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(String employeeNumber, String pass) {
    Map<String,String> userToCache = {
      'employeeNumber':employeeNumber,
      'pass':pass
    };
    return sharedPreferences.setString(
      CACHED_USER,
      jsonEncode(userToCache),
    );
  }
}