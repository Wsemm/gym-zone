import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/constants.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/views/home/widgets/ad_card.dart';
import 'package:gym_zones/views/home/widgets/free_week_card.dart';
import 'package:gym_zones/views/home/widgets/gym_card_individual.dart';
import 'package:gym_zones/views/home/widgets/our_services_card.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';
import 'package:gym_zones/views/offers/widgets/category_item_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common/constants/api.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../common/widgets/loading_widget.dart';
import '../../controllers/custom_bottom_nav_bar_controller.dart';
import '../../controllers/home_controller.dart';
import 'widgets/gym_card.dart';
import 'widgets/label_card_widget.dart';
import 'widgets/top_user_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    OfferController offerCtrl = Get.put(OfferController());
    initializeDateFormatting('ar', null);

    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: appBarSystemStyle,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (ctrl.user != null)
                  Container(
                    constraints: BoxConstraints(maxWidth: 0.48.sw),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: ctrl.user?.imagePath != null
                              ? CachedNetworkImageProvider(
                                  '${Api.IMAGE_PREFIX}${ctrl.user?.imagePath}')
                              : AssetImage(
                                  ctrl.user?.gender == 'male'
                                      ? 'assets/images/male-placeholder.png'
                                      : 'assets/images/female-placeholder.png',
                                ) as ImageProvider,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            '${'Hi,'.tr} ${ctrl.user?.firstname}',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text('Welcome to Gym Zones 👋'.tr),
                if (ctrl.user != null && ctrl.user!.hasSubscription)
                  Image.asset(
                    Get.isDarkMode
                        ? 'assets/images/splash-image-white.png'
                        : 'assets/images/splash-image-primary.png',
                    height: 50.h,
                    width: 50.w,
                  ),
                if (ctrl.user != null)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ctrl.setUnviewedNotificationsCountToZero();
                          Get.toNamed(AppRoutes.notifications);
                        },
                        icon: Stack(
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              size: 26.sp,
                              color: AppColors.primary,
                            ),
                            if (ctrl.unviewedNotificationsCount > 0)
                              Positioned(
                                top: 0,
                                right:
                                    (Get.locale?.languageCode ?? 'en') == 'en'
                                        ? 0
                                        : null,
                                left: (Get.locale?.languageCode ?? 'en') == 'en'
                                    ? null
                                    : 0,
                                child: Container(
                                  height: 14.h,
                                  width: 14.h,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        ctrl.unviewedNotificationsCount
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'robot',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (ctrl.user != null && !ctrl.user!.hasSubscription)
                        //   IconButton(
                        //     onPressed: () {
                        //       Get.toNamed(AppRoutes.qrScan);
                        //     },
                        //     icon: Icon(
                        //       Icons.qr_code_scanner_rounded,
                        //       size: 32.sp,
                        //     ),
                        //   )
                        // else
                        ElevatedButton(
                          onPressed: () {
                            Get.find<CustomBottomNavBarController>()
                                .changePage(1);
                            Get.toNamed(AppRoutes.subscriptions);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: REdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 4.w,
                            ),
                          ),
                          child: Text('Subscribe Now'.tr),
                        ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      Get.toNamed(AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: REdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 4.w,
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Text(
                        'Get Started!'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          body: SafeArea(
            child: ctrl.nearestGyms == [] ||
                    ctrl.topUsers == [] ||
                    ctrl.isLoading
                ? const LoadingWidget()
                : RefreshIndicator(
                    onRefresh: ctrl.refreshView,
                    child: SingleChildScrollView(
                      controller: ctrl.scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // InkWell(
                            //     onTap: () {
                            //       GetStorage().erase();
                            //     },
                            //     child: Text("Clear")),
                            SizedBox(
                              height: 3.h,
                            ),
                            // InkWell(
                            //     onTap: () {
                            //       ctrl.sendWhatsAppMessage();
                            //     },
                            //     child: Text("send whatssapp message")),
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.search),
                              child: Material(
                                elevation: 2.h,
                                borderRadius: BorderRadius.circular(20.r),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Search gyms...'.tr,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.search_rounded,
                                        color: Colors.grey[400],
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (ctrl.user != null &&
                                ctrl.user!.subscriptionType ==
                                    SubscriptionType.trial.name &&
                                ctrl.user!.subscriptionStatus ==
                                    SubscriptionStatus.inactive.name) ...[
                              SizedBox(height: 16.h),
                              const FreeWeekCard()
                            ],
                            SizedBox(
                              height: 16.h,
                            ),
                            if (ctrl.user != null &&
                                (ctrl.user!.hasSubscription ||
                                    ctrl.user!.subscriptionType ==
                                        SubscriptionType.both.name ||
                                    ctrl.user!.subscriptionType ==
                                        SubscriptionType.individual.name)) ...[
                              Text(
                                "Statistics".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 1,
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 5.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CarouselSlider(
                                            items: [
                                              if (ctrl.user!.hasSubscription)
                                                const GroupSubscriptionStatisticsCard(
                                                  type: "group",
                                                ),
                                              if (ctrl.user!.subscriptionType ==
                                                      SubscriptionType
                                                          .individual.name ||
                                                  ctrl.user!.subscriptionType ==
                                                      SubscriptionType
                                                          .both.name)
                                                const GroupSubscriptionStatisticsCard(
                                                  type: "individual",
                                                ),
                                            ],
                                            options: CarouselOptions(
                                              onPageChanged: (index, reason) {
                                                ctrl.analyticsIndex.value =
                                                    index;
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
                                                activeIndex:
                                                    ctrl.analyticsIndex.value,
                                                count: ctrl.user!
                                                                .hasSubscription &&
                                                            ctrl.user!
                                                                    .subscriptionType ==
                                                                SubscriptionType
                                                                    .individual
                                                                    .name ||
                                                        ctrl.user!
                                                                .subscriptionType ==
                                                            SubscriptionType
                                                                .both.name
                                                    ? 2
                                                    : 1,
                                                effect: ExpandingDotsEffect(
                                                  dotHeight: 6.h,
                                                  dotWidth: 6.w,
                                                  spacing: 10.w,
                                                  dotColor:
                                                      const Color(0x4C111827),
                                                  activeDotColor:
                                                      const Color(0xFF374151),
                                                  paintStyle:
                                                      PaintingStyle.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (ctrl.user!.isSubscriptionExpired)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 14.h, bottom: 14.h),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.toNamed(
                                                    AppRoutes.subscriptions);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green.shade400,
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
                              )
                            ],

                            SizedBox(
                              height: 24.h,
                            ),

                            if (ctrl.ad.data != null) ...[
                              Text("Advertisements".tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp)),
                              CarouselSlider.builder(
                                itemCount: ctrl.ad.data!.length,
                                itemBuilder: (context, index, realIdx) {
                                  final ad = ctrl.ad.data![index];
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => ctrl.imageIndexHomepage.value =
                                          index);
                                  return AdCard(ad: ad);
                                },
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Obx(
                                () => SizedBox(
                                  width: Get.width,
                                  child: Center(
                                    child: AnimatedSmoothIndicator(
                                      activeIndex:
                                          ctrl.imageIndexHomepage.value,
                                      count: ctrl.ad.data!.length,
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
                            ],
                            SizedBox(
                              height: 16.h,
                            ),
                            if (ctrl.topUsers!.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              Text(
                                // '${'🔥 Top in'.tr} ${DateFormat.MMMM(Get.locale!.languageCode).format(DateTime.now())}'.tr,
                                'Top ten athletes'.tr,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CarouselSlider.builder(
                                itemCount: ctrl.topUsers!.length,
                                itemBuilder: (context, index, realIdx) =>
                                    TopUserCard(user: ctrl.topUsers![index]),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.5,
                                ),
                              ),
                            ],
                            SizedBox(height: 16.h),
                            OurServicesCard(
                              key: ctrl.ourServicesKey,
                              onOurServicesTap: ctrl.scrollToOurServices,
                              onGroupGymTap: ctrl.scrollToGroupGyms,
                              onOffersTap: ctrl.scrollToOffers,
                              onIndividualGymTap: ctrl.scrollToIndividualGyms,
                              index: ctrl.serviceIndex,
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  key: ctrl.gymsKey,
                                  child: Text(
                                    // '📌 Nearest Gyms'.tr,
                                    'Group gyms'.tr,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.find<CustomBottomNavBarController>()
                                        .changePage(1);
                                    Get.toNamed(AppRoutes.subscriptions);
                                  },
                                  child: Text(
                                    "View more".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
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
                                height: 260
                                    .h, // Set a fixed height for horizontal scroll
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ctrl.nearestGyms?.length ?? 0,
                                  itemBuilder: (context, index) => Container(
                                    width:
                                        0.8.sw, // Set width for each gym card
                                    margin: EdgeInsets.only(right: 16.w),
                                    child:
                                        GymCard(gym: ctrl.nearestGyms![index]),
                                  ),
                                ),
                              )
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Text(
                                      'No gyms found for your gender! Please make sure location access is enabled for this app to allow us to identify and suggest the closest gyms in your vicinity'
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      ctrl.refreshView();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                      ),
                                      backgroundColor: Colors.white,
                                      padding: REdgeInsets.all(8.sp),
                                    ),
                                    child: Text(
                                      'Refresh 🔄'.tr,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  key: ctrl.individualGymsKey,
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
                                    Get.find<CustomBottomNavBarController>()
                                        .changePage(2);
                                    Get.toNamed(
                                      AppRoutes.individualSubscription,
                                    );
                                  },
                                  child: Text(
                                    "View more".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: AppColors.primary,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                            if (ctrl.individualGyms?.isNotEmpty == true)
                              SizedBox(
                                height: 260
                                    .h, // Set a fixed height for horizontal scroll
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: ctrl.individualGyms?.length,
                                  itemBuilder: (context, index) => Container(
                                    width:
                                        0.8.sw, // Set width for each gym card
                                    margin: EdgeInsets.only(right: 16.w),
                                    child: IndividualGymCard(
                                        gym: ctrl.individualGyms![index]),
                                  ),
                                ),
                              )
                            else
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: Text(
                                      'No gyms found for your gender! Please make sure location access is enabled for this app to allow us to identify and suggest the closest gyms in your vicinity'
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      ctrl.refreshView();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.r),
                                      ),
                                      backgroundColor: Colors.white,
                                      padding: REdgeInsets.all(8.sp),
                                    ),
                                    child: Text(
                                      'Refresh 🔄'.tr,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Offers".tr,
                                  key: ctrl.offersKey,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.find<CustomBottomNavBarController>()
                                        .changePage(2);
                                    Get.toNamed(AppRoutes.categoriesPage);
                                  },
                                  child: Text(
                                    "View more".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: AppColors.primary,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 110.h,
                              width: 1.sw,
                              child: GetBuilder<OfferController>(
                                  builder: (controller) {
                                return controller.isLoadingOffers.value
                                    ? const LoadingWidget()
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        primary: true,
                                        shrinkWrap: true,
                                        itemCount:
                                            controller.categoriesList.length,
                                        itemBuilder: (context, index) {
                                          return CategoryItemWidgetNew(
                                            item: controller
                                                .categoriesList[index],
                                            btnClick: () {
                                              controller.fetchOffersByCategory(
                                                  controller
                                                          .categoriesList[index]
                                                          .id ??
                                                      0);
                                              Get.toNamed(AppRoutes.offerPage,
                                                  arguments: {
                                                    "title": Get.locale!
                                                                .languageCode ==
                                                            "en"
                                                        ? controller
                                                                .categoriesList[
                                                                    index]
                                                                .name ??
                                                            ""
                                                        : controller
                                                                .categoriesList[
                                                                    index]
                                                                .nameAr ??
                                                            "",
                                                  });
                                            },
                                          );
                                        });
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: CustomBottomNavBar(),
        );
      },
    );
  }
}

class GroupSubscriptionStatisticsCard extends StatelessWidget {
  const GroupSubscriptionStatisticsCard({
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
