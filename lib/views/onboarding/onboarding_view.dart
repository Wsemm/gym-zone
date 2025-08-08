import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/app_themes/app_themes.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      width: isActive ? 32.w : 24.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[

          Expanded(
            flex: 10,
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                _onboardingPage(
                  title: 'Nationwide Access'.tr,
                  body:
                      'One subscription, unlimited access to the best gyms across 🇴🇲'
                          .tr,
                  image: 'assets/images/onboarding1.png',
                ),
                _onboardingPage(
                  title: 'Flexible Membership'.tr,
                  body:
                      'Choose a membership plan that fits your lifestyle and schedule 📅'
                          .tr,
                  image: 'assets/images/onboarding2.png',
                ),
                _onboardingPage(
                  title: 'Join the Community'.tr,
                  body:
                      'Be a part of a growing community of fitness enthusiasts in Oman 💪'
                          .tr,
                  image: 'assets/images/onboarding3.png',
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          _currentPage != 2
              ? Align(
                  alignment: Get.locale!.languageCode == 'en'
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 4.w,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(4.sp),
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        _pageController.animateToPage(
                          _currentPage + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Icon(
                        Icons.navigate_next_rounded,
                        size: 32.sp,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      GetStorage().write('passedOnboarding', true);
                      Get.offNamed(AppRoutes.home);
                    },
                    child: Text(
                      'Get Started!'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _onboardingPage(
      {required String title, required String body, required String image}) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
             Image.asset(
               image,
               height: MediaQuery.of(context).size.height * 0.6,
               fit: BoxFit.cover,
             ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40.h,
              child: CupertinoSlidingSegmentedControl<int>(
                backgroundColor: AppColors.textfieldBackground,
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
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
