import 'package:equatable/equatable.dart';

import 'user.dart';
import 'benefit.dart';

class LoginResponse extends Equatable {
  final String message;
  final User user;
  final List<Benefit> benefitModels;
  final List<Benefit>? availableBenefitModels;
  final int userUnSeenNotificationCount;

  const LoginResponse(
      {required this.message,
      required this.user,
      required this.benefitModels,
      required this.availableBenefitModels,
      required this.userUnSeenNotificationCount,
      });

  @override
  List<Object?> get props =>
      [message, user, benefitModels, availableBenefitModels,userUnSeenNotificationCount];
}
