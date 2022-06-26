import 'package:flutter/material.dart';
import 'package:more4u/data/datasources/local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String? user;

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedUser = prefs.getString('test');
print(cachedUser);
    setState(() {
      user = cachedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(user??'')),
    );
  }
}
