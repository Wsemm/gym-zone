import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/controllers/individual_subscriptions_controller.dart';
import 'package:gym_zones/controllers/search_controller.dart' as search_ctrl;
import 'package:gym_zones/views/subscriptions/widgets/subscriptions_governorate_dropdown.dart'
    as dropdown;

import '../../common/constants/constants.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../controllers/subscriptions_controller.dart';
import 'widgets/filtered_gym_list.dart';
import 'widgets/subscriptions_governorate_dropdown.dart';
import 'widgets/subscription_card.dart';

class IndividualSubscriptionsView extends StatelessWidget {
  const IndividualSubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(IndividualSubscriptionsController());
    // Initialize SearchController for individual screen
    Get.put(
        search_ctrl.SearchController(
            screenType: search_ctrl.SearchScreenType.individual),
        tag: 'individual_search');

    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<IndividualSubscriptionsController>(
          builder: (individualCtrl) {
        // Clear individual search filters when entering this view
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final homeController = Get.find<HomeController>();
            homeController.clearIndividualFilters();

            // Clear the individual-specific search controller
            try {
              final searchController = Get.find<search_ctrl.SearchController>(
                  tag: 'individual_search');
              searchController.clearSearchQuery();
            } catch (e) {
              // SearchController might not exist yet
            }
          } catch (e) {
            // HomeController might not be initialized yet
          }
        });

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(123, 221, 220, 220),
            systemOverlayStyle: appBarSystemStyle,
            automaticallyImplyLeading: false,
            //     ctrl.user != null && ctrl.user!.hasSubscription,
            title: Text('Individual subscription'.tr),
          ),
          body: GetBuilder<HomeController>(
            builder: (homeCtrl) {
              if (homeCtrl.isLoading || homeCtrl.isIndividualGymsLoading) {
                Get.find<search_ctrl.SearchController>(tag: 'individual_search')
                    .clearSearchQuery();

                return const LoadingWidget();
              }
              return Container(
                padding: EdgeInsets.all(16.sp),
                child: RefreshIndicator(
                  onRefresh: () async {
                    // ctrl.onDelete();
                    homeCtrl.fetchIndividualGyms(pageKey: "1", doLoading: true);
                    individualCtrl.isLoadingMoreData = true;
                    Get.find<HomeController>().isMoreData = true;
                  },
                  child: GetBuilder<IndividualSubscriptionsController>(
                    builder: (individualCtrl) {
                      return ListView(
                        controller: individualCtrl.scrollController,
                        shrinkWrap: true,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Individual gyms'.tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const dropdown
                                      .SubscriptionsGovernorateDropdown(
                                    screenType: dropdown.ScreenType.individual,
                                  ),
                                ],
                              ),
                              if (homeCtrl.individualGymsToDisplay != null &&
                                  homeCtrl
                                      .individualGymsToDisplay!.isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                const IndividualFilteredGymList(),
                                SizedBox(height: 5.h),
                                if (individualCtrl.isLoadingMoreData == true)
                                  Center(child: CircularProgressIndicator())
                                else if (individualCtrl.isLoadingMoreData ==
                                    false)
                                  Center(child: Text("No more gyms".tr)),
                              ] else ...[
                                Container(
                                  margin: EdgeInsets.only(top: 0.35.sh),
                                  child: Center(
                                    child:
                                        Text('No gyms available right now'.tr),
                                  ),
                                )
                              ],
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar:
              // ctrl.user != null && ctrl.user!.hasSubscription
              //     ? null
              //     :
              const CustomBottomNavBar(),
        );
      }),
    );
  }
}
