import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/views/home/widgets/gym_card_individual.dart';
import 'package:gym_zones/views/home/widgets/no_gyms_widget.dart';

class IndividualGymsSection extends StatelessWidget {
  const IndividualGymsSection({
    super.key,
    required this.ctrl,
  });
  final HomeController ctrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      key: ctrl.individualGymsKey,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                // '📌 Individual Gyms'.tr,
                'Individual gyms'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.find<CustomBottomNavBarController>().changePage(2);
                Get.toNamed(
                  AppRoutes.individualSubscription,
                );
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
        if (ctrl.individualGyms?.isNotEmpty == true)
          Container(
            constraints: BoxConstraints(maxHeight: 280.h, minHeight: 260.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ctrl.individualGyms?.length,
              itemBuilder: (context, index) => Container(
                constraints: BoxConstraints(maxHeight: 280.h, minHeight: 260.h),
                width: 0.8.sw, // Set width for each gym card
                margin: EdgeInsets.only(right: 16.w),
                child: IndividualGymCard(gym: ctrl.individualGyms![index]),
              ),
            ),
          )
        else
          NoGymsFoundWidget(ctrl: ctrl),
      ],
    );
  }
}
