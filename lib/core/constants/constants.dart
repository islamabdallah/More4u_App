import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/user.dart';

// import '../features/auth/models/user.dart';


var scaffoldKey = GlobalKey<ScaffoldState>();

const Color mainColor = Color(0xFF293064);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color defaultColor = Color(0xFF212121);
const Color greyColor = Color(0xFF707070);
const Color redColor = Color(0xFFDF343D);

// text styles
const appBarsTextStyle = TextStyle(
  color: Colors.white,
);


User? userData;
