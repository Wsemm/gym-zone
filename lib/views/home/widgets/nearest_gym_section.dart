import 'package:gym_zones/views/home/widgets/gym_card.dart';
import 'package:gym_zones/views/home/widgets/no_gyms_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';

class NearesetGymSection extends StatelessWidget {
  const NearesetGymSection({
    super.key,
    required this.ctrl,
  });
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ctrl.gymsKey,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                // '📌 Nearest Gyms'.tr,
                'Group Gyms'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.find<CustomBottomNavBarController>().changePage(1);
                Get.toNamed(AppRoutes.subscriptions);
              },
              child: Text(
                "View more".tr,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
        SizedBox(height: 8.h),
        if (ctrl.nearestGyms?.isNotEmpty == true)
          SizedBox(
            height: 260.h, // Set a fixed height for horizontal scroll
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ctrl.nearestGyms?.length ?? 0,
              itemBuilder: (context, index) => Container(
                width: 0.8.sw, // Set width for each gym card
                margin: EdgeInsets.only(right: 16.w),
                child: GymCard(gym: ctrl.nearestGyms![index]),
              ),
            ),
          )
        else
          NoGymsFoundWidget(ctrl: ctrl),
      ],
    );
  }
}
