import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';

class FreeWeekCard extends StatelessWidget {
  const FreeWeekCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 343.w,
          height: 140.h,
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(202, 141, 255, 1),
                Color.fromRGBO(120, 28, 199, 1)
              ]),
              borderRadius: BorderRadius.circular(20.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50.h),
                  child: Image.asset(
                    AppImages.offerSpeaker,
                    width: 57.w,
                    height: 57.h,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your First Week is Free!".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              GetStorage().read('lang') == 'en' ? 14.sp : 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxWidth: GetStorage().read("lang") == "end"
                              ? 155.w
                              : 150.w),
                      child: Text(
                        "Try any group gym for free once during your first 7 days of registration."
                            .tr,
                        style: TextStyle(
                            height: 1.8,
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Image.asset(
                  AppImages.offerDumbbell,
                  width: 108.w,
                  height: 108.h,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: GetStorage().read('lang') == 'en' ? 10 : null,
          left: GetStorage().read('lang') == 'ar' ? 10 : null,
          child: GestureDetector(
            onTap: () {
              // Get.find<CustomBottomNavBarController>().changePage(1);
              // Get.toNamed(AppRoutes.subscriptions);
              Get.find<HomeController>().user != null
                  ? Get.toNamed(AppRoutes.qrScan)
                  : Get.offAllNamed(AppRoutes.login);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "Scan gym Qr".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        )
      ],
    );
  }
}
