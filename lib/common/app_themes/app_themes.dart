import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import '../styles/app_colors.dart';

class AppThemes {
  static ThemeData customDarkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.sacffoldDarkBackground,
    colorScheme: const ColorScheme.dark(primary: AppColors.primary),
    appBarTheme: ThemeData().appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 50.h,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
            fontWeight: FontWeight.bold,
          ),
        ),
    textTheme: Typography.englishLike2018.apply(
      fontSizeFactor: 1.sp,
      bodyColor: Colors.white,
      fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textfieldDarkBackground,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    listTileTheme: const ListTileThemeData().copyWith(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    ),
    canvasColor: AppColors.sacffoldDarkBackground,
    dialogBackgroundColor: AppColors.sacffoldDarkBackground,
  );

  static ThemeData customLightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(primary: AppColors.primary),
    appBarTheme: ThemeData().appBarTheme.copyWith(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 50.h,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
    textTheme: Typography.englishLike2018.apply(
      fontSizeFactor: 1.sp,
      bodyColor: Colors.black,
      fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textfieldBackground,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    listTileTheme: const ListTileThemeData().copyWith(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    ),
  );

  static void changeLanguage(String lang) {
    customDarkTheme = customDarkTheme.copyWith(
      appBarTheme: customDarkTheme.appBarTheme.copyWith(
        titleTextStyle: customDarkTheme.appBarTheme.titleTextStyle!.copyWith(
          fontFamily: lang == 'en' ? 'lato' : 'tajwal',
        ),
      ),
      textTheme: customDarkTheme.textTheme.apply(
        fontFamily: lang == 'en' ? 'lato' : 'tajwal',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );

    customLightTheme = customLightTheme.copyWith(
      appBarTheme: customLightTheme.appBarTheme.copyWith(
        titleTextStyle: customLightTheme.appBarTheme.titleTextStyle!.copyWith(
          fontFamily: lang == 'en' ? 'lato' : 'tajwal',
        ),
      ),
      textTheme: customLightTheme.textTheme.apply(
        fontFamily: lang == 'en' ? 'lato' : 'tajwal',
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontFamily: GetStorage().read('lang') == 'en' ? 'lato' : 'tajwal',
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
