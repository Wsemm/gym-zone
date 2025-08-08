import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/app_themes/app_themes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

class CategoriesEmptyWidget extends StatelessWidget {
  const CategoriesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.sh,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "There are no offers currently.".tr,
            style: TextStyle(color: AppColors.primary, fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
