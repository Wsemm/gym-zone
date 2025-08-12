import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/views/home/widgets/label_card_widget.dart';

import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.type,
  });
  final String type;

  @override
  Widget build(BuildContext context) {
    bool isGroup = type == "group";
    HomeController ctrl = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      width: 0.88.sw,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isGroup)
                Text("Group Subscription".tr)
              else
                Text("Individual subscription".tr),
              if (isGroup)
                Container(
                  margin: EdgeInsets.only(
                      right: Get.locale!.languageCode == "en" ? 10 : 0.w,
                      left: Get.locale!.languageCode == "en" ? 0 : 10.w),
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.qrScan);
                    },
                    icon: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.primary,
                      size: 32.sp,
                    ),
                  ),
                )
            ],
          ),
          Container(
            // width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    labelCardWidget(
                        title: isGroup
                            ? 'Total points'.tr
                            : "Subscription plan".tr,
                        count: isGroup
                            ? ctrl.user!.totalPoints.toString()
                            : ctrl.user!.individualSubscriptionPlanDays,
                        mainColor: AppColors.primary,
                        subColor: Colors.white.withOpacity(0.5)),
                    SizedBox(
                      height: 10.h,
                    ),
                    labelCardWidget(
                        title: isGroup
                            ? "${'Points in'.tr} ${DateFormat.MMMM(Get.locale!.languageCode).format(DateTime.now())}"
                            : "Subscription cost".tr,
                        count: isGroup
                            ? "${ctrl.user!.thisMonthPoints}"
                            : "${ctrl.user!.individualPlanAmount}",
                        mainColor: AppColors.primary,
                        subColor: Colors.white.withOpacity(0.5)),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(64.r),
                  child: CircularPercentIndicator(
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 50.r,
                    lineWidth: 12.sp,
                    percent: ctrl.user!.subscriptionValidityPercentage,
                    backgroundColor: Theme.of(context).splashColor,
                    progressColor: AppColors.primary,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isGroup
                              ? ctrl.user!.subscriptionValidityDaysLeft
                                  .toString()
                              : ctrl
                                  .user!.individualSubscriptionValidityDaysLeft
                                  .toString(),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.sp,
                          ),
                        ),
                        Text(
                          'Days Left'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

SizedBox buildStatisticsCard(HomeController ctrl) {
  return SizedBox(
    width: double.infinity,
    child: Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Statistics".tr,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
            ),
            CarouselSlider(
                items: [
                  if (ctrl.user!.hasSubscription)
                    const StatisticsCard(
                      type: "group",
                    ),
                  if (ctrl.user!.subscriptionType ==
                          SubscriptionType.individual.name ||
                      ctrl.user!.subscriptionType == SubscriptionType.both.name)
                    const StatisticsCard(
                      type: "individual",
                    ),
                ],
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    ctrl.analyticsIndex.value = index;
                  },
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                )),
            Obx(
              () => SizedBox(
                width: Get.width,
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: ctrl.analyticsIndex.value,
                    count: ctrl.user!.hasSubscription &&
                            (ctrl.user!.subscriptionType ==
                                    SubscriptionType.individual.name ||
                                ctrl.user!.subscriptionType ==
                                    SubscriptionType.both.name)
                        ? 2
                        : 1,
                    effect: ExpandingDotsEffect(
                      dotHeight: 6.h,
                      dotWidth: 6.w,
                      spacing: 10.w,
                      dotColor: const Color(0x4C111827),
                      activeDotColor: const Color(0xFF374151),
                      paintStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
            ),
            if (ctrl.user!.isSubscriptionExpired)
              Padding(
                padding: EdgeInsets.only(top: 14.h, bottom: 14.h),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.subscriptions);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    padding: REdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 4.w,
                    ),
                  ),
                  child: Text(
                    'Renew Subscription'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
