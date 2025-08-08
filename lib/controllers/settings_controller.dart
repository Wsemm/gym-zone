import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../common/app_themes/app_themes.dart';
import '../models/user.dart';

class SettingsController extends GetxController {
  final RxString _lang = ''.obs;
  String get lang => _lang.value;

  User? _user;
  User? get user => _user;

  @override
  void onInit() {
    _user = GetStorage().read('user') == null
        ? null
        : User.fromJson(GetStorage().read('user'));
    _lang.value = GetStorage().read('lang');
    super.onInit();
  }

  void changeLanguage(String lang) async {
    _lang.value = lang;
    Get.updateLocale(Locale(lang));
    GetStorage().write('lang', lang);
    AppThemes.changeLanguage(lang);
  }

  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    GetStorage().write('isDarkModeOn', !Get.isDarkMode);
    update();
  }
}
