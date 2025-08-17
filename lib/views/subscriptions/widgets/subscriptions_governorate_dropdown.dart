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

enum ScreenType { group, individual }

class SubscriptionsGovernorateDropdown extends StatefulWidget {
  final ScreenType screenType;

  const SubscriptionsGovernorateDropdown(
      {super.key, this.screenType = ScreenType.group});

  @override
  State<SubscriptionsGovernorateDropdown> createState() =>
      _SubscriptionsGovernorateDropdownState();
}

class _SubscriptionsGovernorateDropdownState
    extends State<SubscriptionsGovernorateDropdown> {
  final TextEditingController _searchController = TextEditingController();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Clear search field when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _searchController.dispose();
      _isDisposed = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the appropriate SearchController based on screen type
    final String searchTag = widget.screenType == ScreenType.group
        ? 'group_search'
        : 'individual_search';

    return GetBuilder<HomeController>(
      builder: (homeCtrl) => GetBuilder<search_ctrl.SearchController>(
        tag: searchTag,
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
                    onChanged: (value) {
                      if (value.isEmpty) {
                        _performSearch(homeCtrl, searchCtrl);
                      }
                    },
                    onSubmitted: (value) {
                      _performSearch(homeCtrl, searchCtrl);
                    },
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
    // Add null safety check
    if (homeCtrl == null || searchCtrl == null) {
      log('Controllers are null, skipping search');
      return;
    }

    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      // Set the search keyword in the search controller for API-based search
      searchCtrl.keywordsController.text = searchQuery;

      // Trigger API search for comprehensive results
      searchCtrl.performNewSearchOperation();

      // Use the appropriate filter method based on screen type
      switch (widget.screenType) {
        case ScreenType.group:
          homeCtrl.filterGroupGymsBySearch(searchQuery);
          break;
        case ScreenType.individual:
          homeCtrl.filterIndividualGymsBySearch(searchQuery);
          break;
      }

      log('Searching for gym: $searchQuery on ${widget.screenType} screen');
    } else {
      // Clear search if query is empty
      switch (widget.screenType) {
        case ScreenType.group:
          homeCtrl.filterGroupGymsBySearch(null);
          break;
        case ScreenType.individual:
          homeCtrl.filterIndividualGymsBySearch(null);
          break;
      }

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
    // Get screen-specific selected values
    String? selectedGovernorate;
    List<int> selectedProvinces;

    switch (widget.screenType) {
      case ScreenType.group:
        selectedGovernorate = homeCtrl.selectedGovernorateGroup;
        selectedProvinces = homeCtrl.selectedProvincesGroup;
        break;
      case ScreenType.individual:
        selectedGovernorate = homeCtrl.selectedGovernorateIndividual;
        selectedProvinces = homeCtrl.selectedProvincesIndividual;
        break;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SubscriptionsGovernorateDialog(
          governorates: searchCtrl.governorates,
          selectedGovernorate: selectedGovernorate,
          selectedProvinces: selectedProvinces,
          onApply: (governorate, provinces) {
            log('Subscriptions Dialog onApply called with governorate: $governorate, provinces: $provinces');

            // Update governorate selection
            if (governorate != null) {
              log('Selected governorate: $governorate');
              switch (widget.screenType) {
                case ScreenType.group:
                  homeCtrl.filterGroupGymsByGovernorate(governorate);
                  break;
                case ScreenType.individual:
                  homeCtrl.filterIndividualGymsByGovernorate(governorate);
                  break;
              }
            } else {
              log('Clearing governorate selection');
              switch (widget.screenType) {
                case ScreenType.group:
                  homeCtrl.filterGroupGymsByGovernorate(null);
                  break;
                case ScreenType.individual:
                  homeCtrl.filterIndividualGymsByGovernorate(null);
                  break;
              }
            }

            // Update provinces selection in both controllers
            searchCtrl.selectedProvinces.clear();
            searchCtrl.selectedProvinces.addAll(provinces);

            switch (widget.screenType) {
              case ScreenType.group:
                homeCtrl.filterGroupGymsByProvinces(provinces);
                break;
              case ScreenType.individual:
                homeCtrl.filterIndividualGymsByProvinces(provinces);
                break;
            }
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
