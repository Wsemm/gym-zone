import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../common/navigation/app_routes.dart';

class GenderUnknownMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = GetStorage().read('user');
    final gender = GetStorage().read('gender');
    // إذا لم يكن هناك مستخدم، لا نحول إلى أي مكان (يسمح بالوصول للصفحة الرئيسية)
    if (user != null && gender == null) {
      return const RouteSettings(name: AppRoutes.selectedGender);
    }
    return null;
  }
}
