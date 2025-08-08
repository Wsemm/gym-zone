import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../common/navigation/app_routes.dart';

class OnboardingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final passedOnboarding = GetStorage().read('passedOnboarding');
    if (passedOnboarding != true) {
      return const RouteSettings(name: AppRoutes.onboarding);
    }
    return null;
  }
}