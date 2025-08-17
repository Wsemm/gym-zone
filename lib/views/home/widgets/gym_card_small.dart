import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/constants/api.dart';
import '../../../common/styles/app_colors.dart';
import '../../../common/widgets/rebi_image.dart';
import '../../../models/gym.dart';

class GymCardSmall extends StatelessWidget {
  final Gym item;
  final VoidCallback btnClick;
  const GymCardSmall({super.key, required this.item, required this.btnClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      highlightColor: AppColors.primary,
      child: SizedBox(
        width: 125.w,
        height: 150.w,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 75.w,
                  width: 75.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: RebiImage(
                      imageUrl: "${Api.IMAGE_PREFIX}${item.logoPath}",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  Get.locale!.languageCode == "en"
                      ? item.name ?? ""
                      : item.nameAr ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
