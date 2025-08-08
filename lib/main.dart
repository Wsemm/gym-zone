import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'dart:io';

import 'common/app_themes/app_themes.dart';
import 'common/lang/app_translations.dart';
import 'common/navigation/app_pages.dart';
import 'common/navigation/app_routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/custom_bottom_nav_bar_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  
  // تهيئة Firebase مع معالجة أفضل للأخطاء
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    // إذا فشل Firebase، نستمر بدونها
  }
  
  // تهيئة Controllers
  try {
    await Get.putAsync(() => AuthController().init());
    await Get.putAsync(() => CustomBottomNavBarController().init());
  } catch (e) {
    print('Controller initialization error: $e');
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary,
    systemNavigationBarColor: Colors.white,
    statusBarBrightness: Brightness.light,
  ));

  runApp(const GymZonesApp());
}

class GymZonesApp extends StatelessWidget {
  const GymZonesApp({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull('lang', Get.deviceLocale!.languageCode);
    GetStorage()
        .writeIfNull('isDarkModeOn', Get.theme.brightness == Brightness.dark);
    GetStorage().remove('gender');

    return SafeArea(
      top: false,
      bottom: true,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            defaultTransition: Transition.native,
            transitionDuration: const Duration(milliseconds: 100),
            debugShowCheckedModeBanner: false,
            themeMode: GetStorage().read('isDarkModeOn')
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: AppThemes.customLightTheme,
            darkTheme: AppThemes.customDarkTheme,
            getPages: AppPages.pages,
            initialRoute: AppRoutes.landing,
            translations: AppTranslations(),
            locale: Locale(GetStorage().read('lang')),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
