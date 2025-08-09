import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

class OurServicesCard extends StatelessWidget {
  final VoidCallback? onGroupGymTap;
  final VoidCallback? onOffersTap;
  final VoidCallback? onIndividualGymTap;
  final VoidCallback? onOurServicesTap;
  final int? index;

  const OurServicesCard({
    super.key,
    this.onGroupGymTap,
    this.onOffersTap,
    this.onIndividualGymTap,
    this.index,
    this.onOurServicesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 15.w,
            children: [
              GestureDetector(
                  onTap: onOurServicesTap,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: index == 0 ? AppColors.primary : null,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(4.r)),
                    child: Text(
                      textAlign: TextAlign.start,
                      "Our servcies".tr,
                      style: TextStyle(
                          color: index == 0 ? Colors.white : AppColors.primary),
                    ),
                  )),
              GestureDetector(
                onTap: onGroupGymTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                      color: index == 1 ? AppColors.primary : null,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Text(
                    "Group gyms".tr,
                    style: TextStyle(
                        color: index == 1 ? Colors.white : AppColors.primary),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onIndividualGymTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                      color: index == 2 ? AppColors.primary : null,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Text(
                    "Individual gyms".tr,
                    style: TextStyle(
                        color: index == 2 ? Colors.white : AppColors.primary),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOffersTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                      color: index == 3 ? AppColors.primary : null,
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Text(
                    "Offers".tr,
                    style: TextStyle(
                        color: index == 3 ? Colors.white : AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          "Our servcies".tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(150, 98, 241, 1),
                Color.fromRGBO(103, 58, 183, 1)
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: [
              Text(
                "Individual subscription".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "Choose one gym and join it directly.".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "You can join multiple gyms at once.".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "Each gym has its own packages and prices.".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: const LinearGradient(colors: [
                Color.fromRGBO(79, 64, 255, 1),
                Color.fromRGBO(17, 4, 167, 1)
              ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: [
              Text(
                "Group subscription".tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "Subscribe once and enter dozens of gyms.".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "Various packages (month, 3 months, year).".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                spacing: 5.w,
                children: [
                  Icon(Icons.check),
                  Text(
                    "Access to all gyms within the group system.".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
