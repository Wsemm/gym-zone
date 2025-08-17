import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/views/home/widgets/gym_card_individual.dart';

import '../../../common/styles/app_colors.dart';
import '../../../controllers/home_controller.dart';
import '../../home/widgets/gym_card.dart';

class FilteredGymList extends StatelessWidget {
  const FilteredGymList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) {
        if (homeCtrl.gymsToDisplay!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCtrl.gymsToDisplay!.length,
            itemBuilder: (context, index) =>
                GymCard(gym: homeCtrl.gymsToDisplay![index]),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  homeCtrl.selectedGovernorate != null &&
                          homeCtrl.selectedGovernorate != 'All'
                      ? homeCtrl.selectedProvinces.isNotEmpty
                          ? 'No gyms found'.tr
                          : 'No gyms found'.tr
                      : homeCtrl.selectedProvinces.isNotEmpty
                          ? 'No gyms found'.tr
                          : 'No gyms found'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              // SizedBox(height: 8.h),
              // ElevatedButton(
              //   onPressed: () {
              //     homeCtrl.refreshView();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(24.r),
              //     ),
              //     backgroundColor: Colors.white,
              //     padding: REdgeInsets.all(8.sp),
              //   ),
              //   child: Text(
              //     'Refresh 🔄'.tr,
              //     style: const TextStyle(
              //       color: AppColors.primary,
              //     ),
              //   ),
              // ),
            ],
          );
        }
      },
    );
  }
}

class IndividualFilteredGymList extends StatelessWidget {
  const IndividualFilteredGymList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) {
        if (homeCtrl.individualGymsToDisplay!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCtrl.individualGymsToDisplay!.length,
            itemBuilder: (context, index) => Container(
              constraints: BoxConstraints(maxHeight: 280.h),
              child: IndividualGymCard(
                  gym: homeCtrl.individualGymsToDisplay![index]),
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  homeCtrl.selectedGovernorate != null &&
                          homeCtrl.selectedGovernorate != 'All'
                      ? homeCtrl.selectedProvinces.isNotEmpty
                          ? 'No gyms found'.tr
                          : 'No gyms found'.tr
                      : homeCtrl.selectedProvinces.isNotEmpty
                          ? 'No gyms found'.tr
                          : 'No gyms found'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              // SizedBox(height: 8.h),
              // ElevatedButton(
              //   onPressed: () {
              //     homeCtrl.refreshView();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(24.r),
              //     ),
              //     backgroundColor: Colors.white,
              //     padding: REdgeInsets.all(8.sp),
              //   ),
              //   child: Text(
              //     'Refresh 🔄'.tr,
              //     style: const TextStyle(
              //       color: AppColors.primary,
              //     ),
              //   ),
              // ),
            ],
          );
        }
      },
    );
  }
}
