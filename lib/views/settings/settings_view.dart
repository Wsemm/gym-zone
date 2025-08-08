import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/views/settings/show_data_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/api.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/custom_bottom_nav_bar_controller.dart';
import '../../controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController _ctrl = Get.find<SettingsController>();

  bool _isDarkModeOn = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    Color iconColor = AppColors.primary.withOpacity(0.6);
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {},
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
          automaticallyImplyLeading: false,
          title: Text(
            'SETTINGS'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(16.sp),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.sp),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language_rounded,
                            color: iconColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Language'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      CupertinoSlidingSegmentedControl<int>(
                        children: {
                          0: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Text(
                                'English',
                                style: TextStyle(
                                  fontFamily: 'lato',
                                  fontSize: 14.sp,
                                ),
                              )),
                          1: Text(
                            'عربي',
                            style: TextStyle(
                              fontFamily: 'tajwal',
                              fontSize: 14.sp,
                            ),
                          ),
                        },
                        groupValue: _ctrl.lang == 'en' ? 0 : 1,
                        thumbColor: AppColors.primary.withOpacity(0.8),
                        padding: EdgeInsets.all(8.sp),
                        onValueChanged: (int? newValue) {
                          _ctrl.changeLanguage(newValue! == 0 ? 'en' : 'ar');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.brightness_4_rounded,
                            color: iconColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Dark Mode'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<SettingsController>(builder: (_) {
                        return Switch.adaptive(
                          activeColor: AppColors.primary,
                          value: _isDarkModeOn,
                          onChanged: (value) {
                            _ctrl.toggleTheme();
                            setState(() {
                              _isDarkModeOn = value;
                            });
                          },
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
            if (_ctrl.user != null)
              Container(
                padding: EdgeInsets.all(16.sp),
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1.sp),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          color: iconColor,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Profile'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.all(4.sp),
                      title: Text(
                        'Update profile'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.sp,
                      ),
                      onTap: () {
                        Get.toNamed(AppRoutes.updateProfile);
                      },
                    ),
                    if (_ctrl.user!.subscriptionType ==
                            SubscriptionType.individual.name ||
                        _ctrl.user!.subscriptionType ==
                            SubscriptionType.both.name ||
                        _ctrl.user!.hasSubscription)
                      ListTile(
                        contentPadding: EdgeInsets.all(4.sp),
                        title: Text(
                          'My Subscriptions'.tr,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16.sp,
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.visits);
                        },
                      )
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.all(16.sp),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.sp),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_document,
                        color: iconColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Help & Legal'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(4.sp),
                    title: Text(
                      'Terms & Conditions'.tr,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.sp,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowDataScreen(
                              title: 'Terms & Conditions'.tr,
                              pathUrl:
                                  '${Api.BASE_URL}/terms-and-conditions')));
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(4.sp),
                    title: Text(
                      'Privacy Policy'.tr,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.sp,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowDataScreen(
                              title: 'Privacy Policy'.tr,
                              pathUrl: '${Api.BASE_URL}/privacy-policy')));
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.sp),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.sp),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_rounded,
                        color: iconColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Contact Us'.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(4.sp),
                    title: Text(
                      'Email'.tr,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.sp,
                    ),
                    onTap: () {
                      launchUrl(
                        Uri.parse('mailto:support@gym-zones.com'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_ctrl.user == null)
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.login),
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.sp),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.login_rounded,
                            color: iconColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Sign in'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (_ctrl.user != null)
              InkWell(
                onTap: () async {
                  Get.defaultDialog(
                    title: 'LOG OUT'.tr,
                    middleText: 'Are you sure you want to log out?'.tr,
                    textConfirm: 'Yes'.tr,
                    textCancel: 'No'.tr,
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primary,
                    cancelTextColor: AppColors.primary,
                    onConfirm: () async {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      final result = await Get.find<AuthController>().logout();

                      if (result) {
                        Get.offAllNamed(AppRoutes.login);
                        Get.find<CustomBottomNavBarController>().changePage(0);
                      } else {
                        Get.back();
                        Get.snackbar(
                          'Error'.tr,
                          'Something went wrong. Please try later, or contact us.'
                              .tr,
                          backgroundColor: Colors.grey,
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.all(4.sp),
                        );
                      }
                    },
                    onCancel: () {},
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.sp),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: AppColors.primary.withOpacity(0.3),
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (_ctrl.user != null)
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: 'DELETE ACCOUNT'.tr,
                    middleText:
                        'Are you sure you want to delete your account?'.tr,
                    textConfirm: 'Yes'.tr,
                    textCancel: 'No'.tr,
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primary,
                    cancelTextColor: AppColors.primary,
                    onConfirm: () async {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      final result =
                          await Get.find<AuthController>().deleteAccount();

                      if (result) {
                        Get.offAllNamed(AppRoutes.login);
                        Get.find<CustomBottomNavBarController>().changePage(0);
                      } else {
                        Get.back();
                        Get.snackbar(
                          'Error'.tr,
                          'Something went wrong. Please try later, or contact us.'
                              .tr,
                          backgroundColor: Colors.grey,
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.all(4.sp),
                        );
                      }
                    },
                    onCancel: () {},
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.sp),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            color: AppColors.primary.withOpacity(0.3),
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Delete account'.tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
