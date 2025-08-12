import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/widgets/rebi_image.dart';
import 'package:gym_zones/models/individual_gym.dart';

import '../../../common/constants/api.dart';
import '../../../common/navigation/app_routes.dart';
import '../../../common/styles/app_colors.dart';

class IndividualGymCard extends StatelessWidget {
  final IndividualGym gym;

  const IndividualGymCard({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.individualGymDetails, arguments: {
            "individualGym": gym,
          });
        },
        child: Card(
          elevation: 2.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(4.sp),
            child: Column(
              children: [
                if (gym.gallery != null && gym.gallery!.isNotEmpty)
                  SizedBox(
                    height: 140.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: RebiImage(
                        imageUrl:
                            '${Api.IMAGE_PREFIX}${gym.gallery!.first.imagePath}',
                        fit: BoxFit.cover,
                        width: Get.width,
                      ),
                    ),
                  ),
                // CarouselSlider.builder(
                //   itemCount: gym.gallery!.length,
                //   itemBuilder: (context, index, realIdx) {
                //     return GestureDetector(
                //       onTap: () {
                //         Get.toNamed(
                //           AppRoutes.gymGallery,
                //           arguments: {
                //             'images': gym.gallery,
                //             'initailImageIndex': index,
                //           },
                //         );
                //       },
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(10.r),
                //         child: RebiImage(
                //           imageUrl: '${Api.IMAGE_PREFIX}${gym.gallery![index]}',
                //           fit: BoxFit.cover,
                //           width: Get.width,
                //         ),
                //       ),
                //     );
                //   },
                //   options: CarouselOptions(
                //     enlargeCenterPage: true,
                //     autoPlay: true,
                //     padEnds: false,
                //     viewportFraction: 1,
                //   ),
                // ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: RebiImage(
                          imageUrl: '${Api.IMAGE_PREFIX}${gym.logoPath}',
                          height: 52.h,
                          width: 64.h,
                          fit: BoxFit.fill,
                        )),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Get.locale!.languageCode == 'en'
                                ? gym.name!
                                : gym.nameAr!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            Get.locale!.languageCode == 'en'
                                ? '${gym.province!.governorate!.name},${gym.province!.name}'
                                : '${gym.province!.governorate!.nameAr},${gym.province!.nameAr}',
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(5.r),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.1))),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              gym.isMixed!
                                  ? Icons.wc_rounded
                                  : gym.gender == 'female'
                                      ? Icons.woman_2_rounded
                                      : Icons.man_2_rounded,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              gym.isMixed!
                                  ? 'MIXED'.tr
                                  : gym.gender == 'female'
                                      ? 'WOMEN'.tr
                                      : 'MEN'.tr,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ]),
                    )
                  ],
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: Get.locale!.languageCode == 'en' ? 64.w : 0,
                          right: Get.locale!.languageCode == 'ar' ? 64.w : 0,
                        ),
                        child: Text(
                          "subscription start with".tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${'OMR'.tr} ${gym.basePrice}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 8.h),
                //   child: Text(
                //     Get.locale!.languageCode == 'en'
                //         ? gym.description ?? ''
                //         : gym.descriptionAr ?? '',
                //     textAlign: TextAlign.start,
                //     style: TextStyle(fontSize: 14.sp),
                //   ),
                // ),
                // SizedBox(height: 8.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       constraints: BoxConstraints(maxWidth: 0.44.sw),
                //       child: ElevatedButton.icon(
                //         onPressed: () {
                //           launchUrl(
                //             Uri.parse(gym.locationUrl),
                //             mode: LaunchMode.externalApplication,
                //           );
                //         },
                //         icon: Icon(
                //           Icons.map_rounded,
                //           color: Colors.white,
                //           size: 16.sp,
                //         ),
                //         label: FittedBox(child: Text('Locate on Maps'.tr)),
                //         style: ButtonStyle(
                //           padding: MaterialStateProperty.all(
                //             EdgeInsets.symmetric(
                //               horizontal: 16.w,
                //               vertical: 8.h,
                //             ),
                //           ),
                //           shape: MaterialStateProperty.all(
                //             RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(16.r),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     if (gym.isMixed)
                //       Row(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.wc_rounded,
                //             color: AppColors.primary,
                //             size: 24.sp,
                //           ),
                //           SizedBox(height: 4.h),
                //           Text('MIXED'.tr, style: TextStyle(fontSize: 12.sp)),
                //         ],
                //       )
                //     else if (gym.gender == 'female')
                //       Row(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.woman_2_rounded,
                //             color: AppColors.primary,
                //             size: 24.sp,
                //           ),
                //           SizedBox(height: 4.h),
                //           Text('WOMEN'.tr, style: TextStyle(fontSize: 12.sp)),
                //         ],
                //       )
                //     else
                //       Row(
                //         mainAxisSize: MainAxisSize.min,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.man_2_rounded,
                //             color: AppColors.primary,
                //             size: 24.sp,
                //           ),
                //           SizedBox(height: 4.h),
                //           Text('MEN'.tr, style: TextStyle(fontSize: 12.sp)),
                //         ],
                //       )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
