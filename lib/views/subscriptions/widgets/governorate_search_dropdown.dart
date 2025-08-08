import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'dart:developer';

import '../../../common/constants/governorate.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/search_controller.dart' as search_ctrl;
import 'governorate_province_dialog.dart';

class GovernorateSearchDropdown extends StatelessWidget {
  const GovernorateSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) => GetBuilder<search_ctrl.SearchController>(
        builder: (searchCtrl) => Container(
          width: 0.5.sw,
          child: InkWell(
            onTap: () {
              _showGovernorateProvinceDialog(context, homeCtrl, searchCtrl);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _getDisplayText(homeCtrl, searchCtrl),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _getDisplayText(homeCtrl, searchCtrl) ==
                                'Select governorate'.tr
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayText(
      HomeController homeCtrl, search_ctrl.SearchController searchCtrl) {
    if (homeCtrl.selectedGovernorate == null) {
      return 'Select governorate'.tr;
    }

    final governorateName = homeCtrl.selectedGovernorate!;

    // Handle "All" selection
    if (governorateName == 'All') {
      return 'All Governorates'.tr;
    }

    final governorateAr = governorate[governorateName] ?? '';

    if (homeCtrl.selectedProvinces.isEmpty) {
      return GetStorage().read('lang') == 'en'
          ? '$governorateName ($governorateAr)'
          : '$governorateAr ($governorateName)';
    }

    // If provinces are selected, show count
    final provinceCount = homeCtrl.selectedProvinces.length;
    final baseText = GetStorage().read('lang') == 'en'
        ? '$governorateName ($governorateAr)'
        : '$governorateAr ($governorateName)';

    return '$baseText - $provinceCount ${provinceCount == 1 ? 'province'.tr : 'provinces'.tr}';
  }

  void _showGovernorateProvinceDialog(
    BuildContext context,
    HomeController homeCtrl,
    search_ctrl.SearchController searchCtrl,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GovernorateProvinceDialog(
          governorates: searchCtrl.governorates,
          selectedGovernorate: homeCtrl.selectedGovernorate,
          selectedProvinces: homeCtrl.selectedProvinces,
          onApply: (governorate, provinces) {
            log('Dialog onApply called with governorate: $governorate, provinces: $provinces');

            // Update governorate selection
            if (governorate != null) {
              log('Selected governorate: $governorate');
              homeCtrl.filterGymsByGovernorate(governorate);
            } else {
              log('Clearing governorate selection');
              homeCtrl.filterGymsByGovernorate(null);
            }

            // Update provinces selection
            searchCtrl.selectedProvinces.clear();
            searchCtrl.selectedProvinces.addAll(provinces);
            homeCtrl.filterGymsByProvinces(provinces);
            log('Selected provinces: ${searchCtrl.selectedProvinces}');

            // Update UI
            homeCtrl.update();
            searchCtrl.update();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
