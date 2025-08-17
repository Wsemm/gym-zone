import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/views/home/widgets/gym_card_small.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/api.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../common/widgets/rebi_image.dart';
import '../../models/gym.dart';

class GymDetailsScreen extends GetView<HomeController> {
  final Gym item;

  const GymDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),

            ///
            /// Header :
            /// 1- Slider of images
            /// 2- company log
            ///
            SizedBox(
              height: 225.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: 200.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: CarouselSlider.builder(
                          itemCount: item.gallery!.length,
                          itemBuilder: (context, index, realIdx) {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (_) => controller.imageIndex.value = index);
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.gymGallery,
                                  arguments: {
                                    'images': item.gallery,
                                    'initailImageIndex': index,
                                  },
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: RebiImage(
                                  imageUrl:
                                      '${Api.IMAGE_PREFIX}${item.gallery![index]}',
                                  fit: BoxFit.fill,
                                  width: Get.width,
                                  height: 250.h,
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            autoPlay: true,
                            padEnds: false,
                            viewportFraction: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///
                  ///
                  ///
                  ///

                  Obx(
                    () => Positioned(
                        top: 25.h,
                        right: 0,
                        left: 0,
                        child: SizedBox(
                          width: Get.width,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: controller.imageIndex.value,
                              count: item.gallery!.length,
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
                        )),
                  ),

                  ///
                  /// Back Button icon
                  ///
                  Positioned(
                      top: 25.h,
                      left: 10.w,
                      child: TextButton(
                        child: Container(
                          height: 35.w,
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(100.r)),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )),

                  ///
                  /// Company Icon
                  ///
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5.w),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: RebiImage(
                                  imageUrl:
                                      '${Api.IMAGE_PREFIX}${item.logoPath}',
                                  height: 52.h,
                                  width: 64.h,
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///
            /// Title of company
            ///
            SizedBox(
              height: 15.h,
            ),
            Text(
              Get.locale!.languageCode == 'en' ? item.name : item.nameAr,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              Get.locale!.languageCode == 'en'
                  ? '${item.province.name}, ${item.province.governorate!.name}'
                  : '${item.province.nameAr}, ${item.province.governorate!.nameAr}',
              textAlign: TextAlign.start,
              maxLines: 2,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),

            ///
            /// description
            ///
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Text(
                Get.locale!.languageCode == 'en'
                    ? item.description ?? ''
                    : item.descriptionAr ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),

            ///
            /// Location Button
            ///

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (item.isMixed)
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
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            SizedBox(
              width: Get.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ElevatedButton.icon(
                  onPressed: () {
                    log("# item.locationUrl :${item.locationUrl}");
                    launchUrl(
                      Uri.parse(item.locationUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  label: FittedBox(child: Text('Locate on Maps'.tr)),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
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
                  "Gym List".tr,
                  textAlign: TextAlign.start,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  primary: true,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.nearestGyms!.length,
                  itemBuilder: (context, index) {
                    return GymCardSmall(
                        item: controller.nearestGyms![index],
                        btnClick: () {
                          log("# log Gym Id  ${controller.nearestGyms![index].id}");
                          log("# log Gym Type  ${controller.nearestGyms![index].gymType}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GymDetailsScreen(
                                    item: controller.nearestGyms![index])),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
