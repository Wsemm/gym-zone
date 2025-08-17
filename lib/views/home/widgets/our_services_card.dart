import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/home_controller.dart';

class OurServicesCard extends StatelessWidget {
  const OurServicesCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.h,
      children: [
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
                    "Each gym has its own packages and prices.".tr,
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
                    "Unlimited access to individual gyms.".tr,
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

class RowService extends StatelessWidget {
  const RowService({
    super.key,
    required this.ctrl,
  });

  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    int? index = ctrl.serviceIndex;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 15.w,
        children: [
          GestureDetector(
              onTap: ctrl.scrollToOurServices,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
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
            onTap: ctrl.scrollToGroupGyms,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
              decoration: BoxDecoration(
                  color: index == 1 ? AppColors.primary : null,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(4.r)),
              child: Text(
                "Group Gyms".tr,
                style: TextStyle(
                    color: index == 1 ? Colors.white : AppColors.primary),
              ),
            ),
          ),
          GestureDetector(
            onTap: ctrl.scrollToIndividualGyms,
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
            onTap: ctrl.scrollToOffers,
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
    );
  }
}

class RowServiceHeaderDelegate extends SliverPersistentHeaderDelegate {
  final HomeController ctrl;
  final double height;

  RowServiceHeaderDelegate({required this.ctrl, this.height = 50.0});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: shrinkOffset > 0 ? 2.0 : 0.0,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: _buildRowServiceContent(),
      ),
    );
  }

  Widget _buildRowServiceContent() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        int? index = controller.serviceIndex;
        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 15.w,
                children: [
                  _buildServiceButton(
                    text: "Our servcies".tr,
                    isSelected: index == 0,
                    onTap: () {
                      controller.serviceIndex = 0;
                      controller.update();
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.scrollToOurServices();
                      });
                    },
                  ),
                  _buildServiceButton(
                    text: "Group Gyms".tr,
                    isSelected: index == 1,
                    onTap: () {
                      controller.serviceIndex = 1;
                      controller.update();
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.scrollToGroupGyms();
                      });
                    },
                  ),
                  _buildServiceButton(
                    text: "Individual gyms".tr,
                    isSelected: index == 2,
                    onTap: () {
                      controller.serviceIndex = 2;
                      controller.update();
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.scrollToIndividualGyms();
                      });
                    },
                  ),
                  _buildServiceButton(
                    text: "Offers".tr,
                    isSelected: index == 3,
                    onTap: () {
                      controller.serviceIndex = 3;
                      controller.update();
                      Future.delayed(Duration(milliseconds: 100), () {
                        controller.scrollToOffers();
                      });
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 15.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white, // match your background color
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 15.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white, // match your background color
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : null,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
