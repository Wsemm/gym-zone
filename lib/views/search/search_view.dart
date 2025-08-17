import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common/constants/constants.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/search_controller.dart';
import '../home/widgets/gym_card.dart';
import '../home/widgets/gym_card_individual.dart';
import 'widgets/search_filters.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
          title: Text('Search Gyms'.tr),
        ),
        body: GetBuilder<SearchController>(
          builder: (ctrl) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            elevation: 2.h,
                            borderRadius: BorderRadius.circular(8.r),
                            child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Search gyms...'.tr,
                              ),
                              controller: ctrl.keywordsController,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Material(
                          elevation: 2.h,
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.primary,
                          child: IconButton(
                            onPressed: () {
                              ctrl.performNewSearchOperation();
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Material(
                          elevation: 2.h,
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.primary,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                constraints: const BoxConstraints.expand(),
                                context: context,
                                builder: (_) => const SearchFilters(),
                              );
                            },
                            icon: Icon(
                              Icons.filter_alt_rounded,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ctrl.pagingController == null
                      ? const SizedBox()
                      : Expanded(
                          child: PagedListView<int, SearchResult>(
                            shrinkWrap: false,
                            padding: EdgeInsets.zero,
                            pagingController: ctrl.pagingController!,
                            builderDelegate:
                                PagedChildBuilderDelegate<SearchResult>(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              itemBuilder: (context, item, index) {
                                // Add validation check
                                if (!item.isValid) {
                                  return const SizedBox.shrink();
                                }

                                if (item.isGroup && item.gym != null) {
                                  return GymCard(gym: item.gym!);
                                } else if (!item.isGroup &&
                                    item.individualGym != null) {
                                  return IndividualGymCard(
                                      gym: item.individualGym!);
                                } else {
                                  // Fallback widget in case of null data
                                  return Container(
                                    padding: EdgeInsets.all(16.sp),
                                    child: Text('Invalid gym data'.tr),
                                  );
                                }
                              },
                              newPageProgressIndicatorBuilder: (context) =>
                                  const Center(
                                child: CircularProgressIndicator(),
                              ),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  SizedBox(
                                height: MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    100.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  Center(
                                child: Text(
                                  'Error loading data!'.tr,
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  SizedBox(
                                height: MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    100.h,
                                child: Center(
                                  child: Text(
                                    'No gyms found'.tr,
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
