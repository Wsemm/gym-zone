import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/home_controller.dart';

class NoGymsFoundWidget extends StatelessWidget {
  const NoGymsFoundWidget({
    super.key,
    required this.ctrl,
  });
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            'No gyms found for your gender! Please make sure location access is enabled for this app to allow us to identify and suggest the closest gyms in your vicinity'
                .tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: () {
            ctrl.refreshView();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            backgroundColor: Colors.white,
            padding: REdgeInsets.all(8.sp),
          ),
          child: Text(
            'Refresh 🔄'.tr,
            style: const TextStyle(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
