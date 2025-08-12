import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/constants.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common/styles/app_colors.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../controllers/visits_controller.dart';
import '../../models/visit.dart';
import 'widgets/visit_card.dart';

class VisitsView extends StatelessWidget {
  const VisitsView({super.key});

  @override
  Widget build(BuildContext context) {
    BoxDecoration selectedTheme = BoxDecoration(
        borderRadius: BorderRadius.circular(4.r), color: AppColors.primary);
    BoxDecoration unSelectedTheme = BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.primary));

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        systemOverlayStyle: appBarSystemStyle,
        title: Text(
          'My Subscriptions'.tr,
          style: const TextStyle(
            color: AppColors.primary,
          ),
        ),
      ),
      body: GetBuilder<VisitsController>(
        builder: (ctrl) {
          return Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.w,
                children: [
                  GestureDetector(
                    onTap: () {
                      ctrl.currentPage.value = 0;
                      ctrl.update();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: ctrl.currentPage.value == 0
                          ? selectedTheme
                          : unSelectedTheme,
                      width: 160.w,
                      child: Center(
                        child: Text(
                          "Group visits".tr,
                          style: TextStyle(
                              color: ctrl.currentPage.value == 0
                                  ? Colors.white
                                  : AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ctrl.currentPage.value = 1;
                      ctrl.update();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: ctrl.currentPage.value == 1
                          ? selectedTheme
                          : unSelectedTheme,
                      width: 165.w,
                      child: Center(
                        child: Text(
                          "Individual subscriptions".tr,
                          style: TextStyle(
                              color: ctrl.currentPage.value == 1
                                  ? Colors.white
                                  : AppColors.primary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              if (ctrl.currentPage.value == 0)
                if (!ctrl.user!.hasSubscription)
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 64.h,
                        ),
                        Image.asset(AppImages.noSubscripeImage),
                        SizedBox(
                          height: 32.h,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 50.w,
                            ),
                            child: Text(
                              "You didn't choose your training plan yet".tr,
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w700),
                            )),
                        SizedBox(
                          height: 32.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            "We have the perfect plan for you, start now and unleash your energy."
                                .tr,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          width: 300.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: () {
                                Get.find<CustomBottomNavBarController>()
                                    .changePage(1);
                                Get.offNamed(AppRoutes.subscriptions);
                              },
                              child: Text(
                                'Group subscription'.tr,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.refreshView(),
                      child: Center(
                        child: PagedListView<int, Visit>(
                          padding: EdgeInsets.zero,
                          pagingController: ctrl.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Visit>(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            itemBuilder: (context, item, index) {
                              return VisitCard(visit: item);
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
                                    child: const LoadingWidget()),
                            firstPageErrorIndicatorBuilder: (context) => Center(
                              child: Text(
                                'Error loading data!'.tr,
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ),
                            noItemsFoundIndicatorBuilder: (context) => SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  100.h,
                              child: Center(
                                child: Text(
                                  'No visits found'.tr,
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              else if (ctrl.user!.subscriptionType ==
                      SubscriptionType.individual.name ||
                  ctrl.user!.subscriptionType == SubscriptionType.both.name)
                Expanded(
                  child:
                      // IndividualVisitCard(visit: Visit.generateFakeVisits()[0]),
                      IndividualVisitCard(user: ctrl.user!),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 64.h,
                      ),
                      Image.asset(AppImages.noSubscripeImage),
                      SizedBox(
                        height: 32.h,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 50.w,
                          ),
                          child: Text(
                            "You didn't choose your training plan yet".tr,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w700),
                          )),
                      SizedBox(
                        height: 32.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          "We have the perfect plan for you, start now and unleash your energy."
                              .tr,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        width: 300.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              Get.find<CustomBottomNavBarController>()
                                  .changePage(2);
                              Get.offNamed(AppRoutes.individualSubscription);
                            },
                            child: Text(
                              'Individual subscriptions'.tr,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
