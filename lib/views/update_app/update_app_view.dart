import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_themes/app_themes.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';

class UpdateAppView extends StatelessWidget {
  final _updateIsOptional = Get.arguments ?? false;

  UpdateAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,

        title: CupertinoSlidingSegmentedControl<int>(
          children: {
            0: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Text(
                'English',
                style: TextStyle(
                  fontFamily: 'lato',
                  fontSize: 14.sp,
                ),
              ),
            ),
            1: Text(
              'عربي',
              style: TextStyle(
                fontFamily: 'tajwal',
                fontSize: 14.sp,
              ),
            ),
          },
          groupValue: Get.locale!.languageCode == 'en' ? 0 : 1,
          thumbColor: AppColors.primary,
          padding: EdgeInsets.all(8.sp),
          onValueChanged: (int? newValue) {
            final lang = newValue == 0 ? 'en' : 'ar';
            Get.updateLocale(Locale(lang));
            GetStorage().write('lang', lang);
            AppThemes.changeLanguage(lang);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      MediaQuery.of(context).size.height * 0.25),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Get.isDarkMode
                      ? 'assets/images/slogan-white.png'
                      : 'assets/images/slogan-primary.png',
                ),
                SizedBox(height: 16.h),
                FittedBox(
                  child: Text(
                    'Update the app to the latest version'.tr,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Please update the app to the latest version to enjoy the new features'
                      .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: 0.5.sw,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        launchUrl(
                          Uri.parse(
                            'https://play.google.com/store/apps/details?id=com.pixllmall.gym_zones',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        launchUrl(
                          Uri.parse(
                            'https://apps.apple.com/om/app/id6472092672',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Update now'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_updateIsOptional)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: SizedBox(
                      width: 0.5.sw,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.home);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Later'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
