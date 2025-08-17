import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/individual_gym_details_screen_controller.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:gym_zones/views/home/widgets/gym_branch.dart';
import 'package:gym_zones/views/subscriptions/widgets/individual_subscription_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/constants/api.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../common/widgets/rebi_image.dart';

class IndividualGymDetailsScreen
    extends GetView<IndividualGymDetailsScreenController> {
  const IndividualGymDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // or any color
        statusBarIconBrightness: Brightness.dark, // For dark icons
        statusBarBrightness: Brightness.light, // For iOS
      ),
      child: GetBuilder<IndividualGymDetailsScreenController>(
        builder: (controller) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.gym!.gallery != null &&
                    controller.gym!.gallery!.isNotEmpty)
                  Container(
                    color: AppColors.backGroundGrey,
                    height: 342.h,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 290.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: RebiImage(
                              imageUrl:
                                  '${Api.IMAGE_PREFIX}${controller.gym!.gallery!.first.imagePath}',
                              fit: BoxFit.cover,
                              width: Get.width,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30.h,
                          right: 20,
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.5),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 15.h),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: InkWell(
                                    onTap: () {
                                      print(
                                          '${Api.IMAGE_PREFIX}${controller.gym!.logoPath}');
                                    },
                                    child: RebiImage(
                                      imageUrl:
                                          '${Api.IMAGE_PREFIX}${controller.gym!.logoPath}',
                                      height: 52.h,
                                      width: 64.h,
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        Get.locale!.languageCode == 'en'
                            ? controller.gym!.name!
                            : controller.gym!.nameAr!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  spacing: 5.w,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.primary,
                                      size: 18.sp,
                                    ),
                                    Text(
                                      Get.locale!.languageCode == 'en'
                                          ? '${controller.gym!.province!.name}, ${controller.gym!.province!.governorate!.name}'
                                          : '${controller.gym!.province!.nameAr}, ${controller.gym!.province!.governorate!.nameAr}',
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    log("# controller.gym!.locationUrl :${controller.gym!.locationUrl}");
                                    launchUrl(
                                      Uri.parse(controller.gym!.locationUrl!),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  child: Text("Locate on Maps".tr,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
                                      )),
                                ),
                              ],
                            ),
                            Gender(item: controller.gym!),
                          ],
                        ),
                      ),

                      ///
                      /// description
                      ///
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          Get.locale!.languageCode == 'en'
                              ? controller.gym!.description ?? ''
                              : controller.gym!.descriptionAr ?? '',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(121, 121, 121, 1),
                              height: 1.6),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),

                      if (controller.isLoading)
                        const LoadingWidget()
                      else if (controller.plans!.data != null &&
                          controller.plans!.data!.isNotEmpty)
                        Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Subscription Plans'.tr,
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.black),
                                    ),
                                  ],
                                ),
                                GridView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.70,
                                    crossAxisSpacing: 8.w,
                                    mainAxisSpacing: 8.h,
                                  ),
                                  itemCount: controller.plans!.data!.length,
                                  itemBuilder: (context, index) {
                                    final plan = controller.plans!.data![index];
                                    return IndividualSubscriptionCard(
                                      plan: plan,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),

                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Working hours".tr,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${Get.locale == Locale("en") ? controller.gym!.openingDay : controller.gym!.openingDayAr}",
                                style: TextStyle(
                                    color:
                                        const Color.fromRGBO(121, 121, 121, 1),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      if (controller.gym!.schedules != null &&
                          controller.gym!.schedules!.isNotEmpty)
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weekly class times".tr,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 15.h),
                                GridView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        GetStorage().read("lang") == "en"
                                            ? 1.1.w
                                            : 0.9.w,
                                    crossAxisSpacing:
                                        GetStorage().read("lang") == "en"
                                            ? 10.w
                                            : 30.w,
                                    mainAxisSpacing: 15.h,
                                  ),
                                  itemCount: controller.gym!.schedules!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var scudule =
                                        controller.gym!.schedules![index];
                                    return DefaultTextStyle(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                          color: Color.fromRGBO(37, 37, 37, 1)),
                                      child: Container(
                                        // color: Colors.red,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              spacing: 2.w,
                                              children: [
                                                Image.asset(
                                                  AppImages.dateIconPng,
                                                  width: 20,
                                                  height: 20,
                                                  color: AppColors.primary,
                                                ),
                                                if (scudule.dayOfWeek != null)
                                                  Text(
                                                    "${Get.locale == Locale("en") ? scudule.dayOfWeek : scudule.dayOfWeekAr}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp),
                                                  )
                                                else
                                                  Text(
                                                    "${Get.locale == Locale("en") ? scudule.daysNames!.map((day) => day).join("- ") : scudule.daysNamesAr!.map((day) => day).join("- ")}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16.sp),
                                                  )
                                              ],
                                            ),
                                            SizedBox(height: 7.h),
                                            Text("Class times start from:".tr),
                                            SizedBox(height: 5.h),
                                            Container(
                                              height: 60.h,
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                children: [
                                                  ...scudule.startTime12h!.map(
                                                    (time) => Row(
                                                      spacing: 5.w,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .access_time_outlined,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                          time,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      SizedBox(
                        height: 25.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.h),
                        child: SizedBox(
                          width: Get.width,
                          child: Text(
                            "Photo Gallery".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: controller.gym!.gallery!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              List<String> images = [];
                              for (var image in controller.gym!.gallery!) {
                                images.add(image.imagePath!);
                              }
                              Get.toNamed(
                                AppRoutes.gymGallery,
                                arguments: {
                                  'images': images,
                                  'initailImageIndex': index,
                                },
                              );
                            },
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                    'assets/images/launcher-icon.png');
                              },
                              imageUrl:
                                  '${Api.IMAGE_PREFIX}${controller.gym!.gallery![index].imagePath}',
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: 125.h,
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Gym branches".tr,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: List.generate(
                            controller.gym!.branches!.length,
                            (index) => Column(
                                  children: [
                                    GymBranch(
                                      gymBranch:
                                          controller.gym!.branches![index],
                                    ),
                                    if (index !=
                                        controller.gym!.branches!.length - 1)
                                      Divider(
                                        color: Color.fromRGBO(120, 108, 255, 1),
                                      )
                                  ],
                                )),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Gender extends StatelessWidget {
  const Gender({
    super.key,
    required this.item,
  });

  final IndividualGym item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (item.isMixed!)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.wc_rounded,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text('MIXED'.tr, style: TextStyle(fontSize: 12.sp)),
            ],
          )
        else if (item.gender == 'female')
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.woman_2_rounded,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text('WOMEN'.tr, style: TextStyle(fontSize: 12.sp)),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.man_2_rounded,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text('MEN'.tr, style: TextStyle(fontSize: 12.sp)),
            ],
          )
      ],
    );
  }
}
