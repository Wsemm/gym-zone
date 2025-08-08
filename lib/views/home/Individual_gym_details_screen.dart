import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/functions.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/controllers/individual_gym_details_screen_controller.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:gym_zones/views/home/widgets/gym_branch.dart';
import 'package:gym_zones/views/subscriptions/widgets/individual_subscription_card.dart';
import 'package:intl/intl.dart';
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
    List<String> formattedTimes = controller.gym!.schedules!.map((scudule) {
      final dt = DateFormat("HH:mm:ss").parse(scudule.startTime!.first);
      return DateFormat("hh:mm a").format(dt);
    }).toList();
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
                              child: Icon(
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
                                  child: RebiImage(
                                    imageUrl:
                                        '${Api.IMAGE_PREFIX}${controller.gym!.logoPath}',
                                    height: 52.h,
                                    width: 64.h,
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ///
                /// Header :
                /// 1- Slider of images
                /// 2- company log
                ///
                // SizedBox(
                //   height: 225.h,
                //   child: Stack(
                //     children: [
                //       Positioned(
                //         top: 0,
                //         right: 0,
                //         left: 0,
                //         child: SizedBox(
                //           height: 200.h,
                //           child: Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 10.w),
                //             child: CarouselSlider.builder(
                //               controller.gym!Count: controller.gym!.gallery!.length,
                //               controller.gym!Builder: (context, index, realIdx) {
                //                 WidgetsBinding.instance.addPostFrameCallback(
                //                     (_) => controller.imageIndex.value = index);
                //                 return GestureDetector(
                //                   onTap: () {
                //                     Get.toNamed(
                //                       AppRoutes.gymGallery,
                //                       arguments: {
                //                         'images': controller.gym!.gallery,
                //                         'initailImageIndex': index,
                //                       },
                //                     );
                //                   },
                //                   child: ClipRRect(
                //                     borderRadius: BorderRadius.circular(10.r),
                //                     child: RebiImage(
                //                       imageUrl:
                //                           '${Api.IMAGE_PREFIX}${controller.gym!.gallery![index]}',
                //                       fit: BoxFit.fill,
                //                       width: Get.width,
                //                       height: 250.h,
                //                     ),
                //                   ),
                //                 );
                //               },
                //               options: CarouselOptions(
                //                 enlargeCenterPage: true,
                //                 autoPlay: true,
                //                 padEnds: false,
                //                 viewportFraction: 1,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),

                //       ///
                //       ///
                //       ///
                //       ///

                //       Obx(
                //         () => Positioned(
                //             top: 25.h,
                //             right: 0,
                //             left: 0,
                //             child: SizedBox(
                //               width: Get.width,
                //               child: Center(
                //                 child: AnimatedSmoothIndicator(
                //                   activeIndex: controller.imageIndex.value,
                //                   count: controller.gym!.gallery!.length,
                //                   effect: ExpandingDotsEffect(
                //                     dotHeight: 6.h,
                //                     dotWidth: 6.w,
                //                     spacing: 10.w,
                //                     dotColor: const Color(0x4C111827),
                //                     activeDotColor: const Color(0xFF374151),
                //                     paintStyle: PaintingStyle.fill,
                //                   ),
                //                 ),
                //               ),
                //             )),
                //       ),

                //       ///
                //       /// Back Button icon
                //       ///
                //       Positioned(
                //           top: 25.h,
                //           left: 10.w,
                //           child: TextButton(
                //             child: Container(
                //               height: 35.w,
                //               width: 35.w,
                //               decoration: BoxDecoration(
                //                   color: Colors.white.withOpacity(0.5),
                //                   borderRadius: BorderRadius.circular(100.r)),
                //               child: Center(
                //                 child: Icon(
                //                   Icons.arrow_back_ios_new,
                //                   size: 18.sp,
                //                 ),
                //               ),
                //             ),
                //             onPressed: () => Navigator.of(context).pop(),
                //           )),

                //       ///
                //       /// Company Icon
                //       ///
                //       Positioned(
                //         bottom: 0,
                //         left: 0,
                //         right: 0,
                //         child: Column(
                //           children: [
                //             Card(
                //               elevation: 4,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(10.r),
                //               ),
                //               child: Padding(
                //                 padding: EdgeInsets.all(5.w),
                //                 child: ClipRRect(
                //                     borderRadius: BorderRadius.circular(10.r),
                //                     child: RebiImage(
                //                       imageUrl: '${Api.IMAGE_PREFIX}${controller.gym!.logoPath}',
                //                       height: 52.h,
                //                       width: 64.h,
                //                       fit: BoxFit.fill,
                //                     )),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                ///
                /// Title of company
                ///
                // InkWell(
                //   onTap: () {
                //     print("${controller.gym!.id}");
                //   },
                //   child: Text("Dsa"),
                // ),
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
                              height: 1.6),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),

                      if (controller.isLoading)
                        const LoadingWidget()
                      else if (controller.plans!.data != null)
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
                                    childAspectRatio: 0.75,
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
                              SizedBox(height: 10.h),
                              GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.6,
                                  crossAxisSpacing: 25.w,
                                  mainAxisSpacing: 15.h,
                                ),
                                itemCount: controller.gym!.schedules!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var scudule =
                                      controller.gym!.schedules![index];
                                  return DefaultTextStyle(
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: Color.fromRGBO(37, 37, 37, 1)),
                                    child: Column(
                                      children: [
                                        Row(
                                          spacing: 2.w,
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.dateIcon,
                                              width: 20,
                                              height: 20,
                                            ),
                                            Text(
                                              "${Get.locale == Locale("en") ? scudule.dayOfWeek : scudule.dayOfWeekAr}",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          height: 60.h,
                                          child: ListView(
                                            padding: EdgeInsets.zero,
                                            children: [
                                              ...scudule.startTime!.map(
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///
                      /// Location Button
                      ///

                      // SizedBox(
                      //   width: Get.width,
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 10.w),
                      //     child: ElevatedButton.icon(
                      //       onPressed: () {
                      //         log("# controller.gym!.locationUrl :${controller.gym!.locationUrl}");
                      //         launchUrl(
                      //           Uri.parse(controller.gym!.locationUrl),
                      //           mode: LaunchMode.externalApplication,
                      //         );
                      //       },
                      //       icon: Icon(
                      //         Icons.location_on_outlined,
                      //         color: Colors.white,
                      //         size: 16.sp,
                      //       ),
                      //       label: FittedBox(child: Text('Locate on Maps'.tr)),
                      //       style: ButtonStyle(
                      //         padding: WidgetStateProperty.all(
                      //           EdgeInsets.symmetric(
                      //             horizontal: 16.w,
                      //             vertical: 8.h,
                      //           ),
                      //         ),
                      //         shape: WidgetStateProperty.all(
                      //           RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10.r),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 25.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.h),
                        child: SizedBox(
                          width: Get.width,
                          child: Text(
                            "Gym pictures".tr,
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
                      Text("Gym branches".tr,
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500)),

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

                      // SizedBox(
                      //   height: 125.h,
                      //   child: ListView.builder(
                      //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                      //       primary: true,
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       controller.gym!Count: controller.nearestGyms!.length,
                      //       controller.gym!Builder: (context, index) {
                      //         return GymCardSmall(
                      //             controller.gym!: controller.nearestGyms![index],
                      //             btnClick: () {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         IndividualGymDetailsScreen(
                      //                             controller.gym!: controller.nearestGyms![index])),
                      //               );
                      //             });
                      //       }),
                      // ),
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
