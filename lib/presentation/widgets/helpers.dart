import 'package:flutter/material.dart';
import 'package:more4u/core/constants/constants.dart';

Color getBenefitStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.indigo;
    case 'InProgress':
      return yellowColor;
    case 'Approved':
      return greenColor;

    default:
      return redColor;
  }
}