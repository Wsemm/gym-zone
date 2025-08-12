import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'dart:developer';

import '../../../common/constants/governorate.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/search_controller.dart' as search_ctrl;
import 'subscriptions_governorate_dialog.dart';

class SubscriptionsGovernorateDropdown extends StatefulWidget {
  const SubscriptionsGovernorateDropdown({super.key});

  @override
  State<SubscriptionsGovernorateDropdown> createState() =>
      _SubscriptionsGovernorateDropdownState();
}

class _SubscriptionsGovernorateDropdownState
    extends State<SubscriptionsGovernorateDropdown> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeCtrl) => GetBuilder<search_ctrl.SearchController>(
        builder: (searchCtrl) => Container(
          width: 0.5.sw,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _performSearch(homeCtrl, searchCtrl),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for gym'.tr,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 20.h,
                  color: Colors.grey.shade300,
                ),
                InkWell(
                  onTap: () {
                    _showSubscriptionsGovernorateDialog(
                        context, homeCtrl, searchCtrl);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Image.asset(
                      AppImages.filter,
                      color: AppColors.primary,
                      width: 20.sp,
                      height: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch(
      HomeController homeCtrl, search_ctrl.SearchController searchCtrl) {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      // Set the search keyword in the search controller for API-based search
      searchCtrl.keywordsController.text = searchQuery;

      // Trigger API search for comprehensive results
      searchCtrl.performNewSearchOperation();

      // Use the HomeController's search filter for local filtering
      homeCtrl.filterGymsBySearch(searchQuery);

      log('Searching for gym: $searchQuery');
    } else {
      // Clear search if query is empty
      homeCtrl.filterGymsBySearch(null);
      // Clear the API search results as well
      searchCtrl.searchResults.clear();
      searchCtrl.keywordsController.clear();
    }
  }

  void _showSubscriptionsGovernorateDialog(
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
        return SubscriptionsGovernorateDialog(
          governorates: searchCtrl.governorates,
          selectedGovernorate: homeCtrl.selectedGovernorate,
          selectedProvinces: homeCtrl.selectedProvinces,
          onApply: (governorate, provinces) {
            log('Subscriptions Dialog onApply called with governorate: $governorate, provinces: $provinces');

            // Update governorate selection
            if (governorate != null) {
              log('Selected governorate: $governorate');
              homeCtrl.filterGymsByGovernorate(governorate);
            } else {
              log('Clearing governorate selection');
              homeCtrl.filterGymsByGovernorate(null);
            }

            // Update provinces selection in both controllers
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
