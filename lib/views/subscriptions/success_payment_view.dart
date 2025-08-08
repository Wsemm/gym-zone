import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';

class SuccessPaymentView extends StatelessWidget {
  const SuccessPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.successPayment,
                height: 300.h,
                width: 300.w,
              ),
              SizedBox(
                height: 86.h,
              ),
              Text(
                'Payment Successful'.tr,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                'You can now enjoy our services'.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 32.h,
              ),
              Container(
                width: 300.w,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      Get.find<CustomBottomNavBarController>().changePage(0);
                      Get.offAllNamed(AppRoutes.home);
                    },
                    child: Text(
                      'Home'.tr,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
