import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/common/widgets/rebi_image.dart';
import 'package:gym_zones/views/offers/data/category_model.dart';

import '../../../common/constants/api.dart';

class CategoryItemWidget extends StatelessWidget {
  final Category item;
  final VoidCallback btnClick;

  const CategoryItemWidget(
      {super.key, required this.item, required this.btnClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      highlightColor: AppColors.primary,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.w,
                width: 100.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: RebiImage(
                    imageUrl: "${Api.IMAGE_PREFIX}${item.iconPath}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                Get.locale!.languageCode == "en"
                    ? item.name ?? ""
                    : item.nameAr ?? "",
                maxLines: 1,
                style: TextStyle(
                    // color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItemWidgetNew extends StatelessWidget {
  final Category item;
  final VoidCallback btnClick;

  const CategoryItemWidgetNew(
      {super.key, required this.item, required this.btnClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnClick,
      highlightColor: AppColors.primary,
      child: Container(
        margin: EdgeInsets.only(left: 16.w),
        width: 120.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 0.3),
            borderRadius: BorderRadius.circular(8.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 75.w,
                width: 75.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: RebiImage(
                    imageUrl: "${Api.IMAGE_PREFIX}${item.iconPath}",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                Get.locale!.languageCode == "en"
                    ? item.name ?? ""
                    : item.nameAr ?? "",
                maxLines: 1,
                style: TextStyle(
                    // color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
