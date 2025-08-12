import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/api.dart';
import 'package:gym_zones/common/constants/constants.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';

AppBar buildHomeAppBar(HomeController ctrl) {
  return AppBar(
    systemOverlayStyle: appBarSystemStyle,
    automaticallyImplyLeading: false,
    toolbarHeight: ctrl.user != null &&
            (!ctrl.user!.hasSubscription &&
                !ctrl.user!.hasIndividualSubscription)
        ? 100.h
        : null,
    title: Column(
      children: [
        if (ctrl.user != null &&
            (!ctrl.user!.hasSubscription &&
                !ctrl.user!.hasIndividualSubscription)) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome to Gym Zones'.tr),
              ElevatedButton(
                onPressed: () {
                  Get.find<CustomBottomNavBarController>().changePage(1);
                  Get.toNamed(AppRoutes.subscriptions);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: REdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 8.w,
                  ),
                ),
                child: Text(
                  'Subscribe Now'.tr,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                        '${ctrl.user?.firstname} \n ${'Hello'.tr}',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                Get.isDarkMode
                    ? 'assets/images/splash-image-white.png'
                    : 'assets/images/splash-image-primary.png',
                height: 50.h,
                width: 50.w,
              ),
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
                        right: (Get.locale?.languageCode ?? 'en') == 'en'
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
                                ctrl.unviewedNotificationsCount.toString(),
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
              )
            ],
          )
        ],
        if (ctrl.user == null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome to Gym Zones'.tr),
              ElevatedButton(
                onPressed: () async {
                  Get.toNamed(AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: REdgeInsets.symmetric(
                    vertical: 8.h,
                    horizontal: 10.w,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  child: Text(
                    'Get Started'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        if (ctrl.user != null &&
            (ctrl.user!.hasSubscription ||
                ctrl.user!.hasIndividualSubscription)) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                        '${ctrl.user?.firstname} \n ${'Hello'.tr}',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                Get.isDarkMode
                    ? 'assets/images/splash-image-white.png'
                    : 'assets/images/splash-image-primary.png',
                height: 50.h,
                width: 50.w,
              ),
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
                        right: (Get.locale?.languageCode ?? 'en') == 'en'
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
                                ctrl.unviewedNotificationsCount.toString(),
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
              )
            ],
          )
        ],
      ],
    ),
  );
}


// Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (ctrl.user != null)
//                 Container(
//                   constraints: BoxConstraints(maxWidth: 0.48.sw),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircleAvatar(
//                         radius: 20.r,
//                         backgroundImage: ctrl.user?.imagePath != null
//                             ? CachedNetworkImageProvider(
//                                 '${Api.IMAGE_PREFIX}${ctrl.user?.imagePath}')
//                             : AssetImage(
//                                 ctrl.user?.gender == 'male'
//                                     ? 'assets/images/male-placeholder.png'
//                                     : 'assets/images/female-placeholder.png',
//                               ) as ImageProvider,
//                       ),
//                       SizedBox(width: 8.w),
//                       Flexible(
//                         child: Text(
//                           '${ctrl.user?.firstname} \n ${'Hello'.tr}',
//                           style: TextStyle(fontSize: 16.sp),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               else
//                 Text('Welcome to Gym Zones'.tr),
//               if (ctrl.user != null)
//                 if (ctrl.user!.hasSubscription || isSubscribedIndividually)
//                   // Image.asset(
//                   //   Get.isDarkMode
//                   //       ? 'assets/images/splash-image-white.png'
//                   //       : 'assets/images/splash-image-primary.png',
//                   //   height: 50.h,
//                   //   width: 50.w,
//                   // ),
//                   if (ctrl.user != null &&
//                       (!ctrl.user!.hasSubscription ||
//                           !isSubscribedIndividually)) ...[
//                     Image.asset(
//                       Get.isDarkMode
//                           ? 'assets/images/splash-image-white.png'
//                           : 'assets/images/splash-image-primary.png',
//                       height: 50.h,
//                       width: 50.w,
//                     ),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             ctrl.setUnviewedNotificationsCountToZero();
//                             Get.toNamed(AppRoutes.notifications);
//                           },
//                           icon: Stack(
//                             children: [
//                               Icon(
//                                 Icons.notifications_none_rounded,
//                                 size: 26.sp,
//                                 color: AppColors.primary,
//                               ),
//                               if (ctrl.unviewedNotificationsCount > 0)
//                                 Positioned(
//                                   top: 0,
//                                   right:
//                                       (Get.locale?.languageCode ?? 'en') == 'en'
//                                           ? 0
//                                           : null,
//                                   left:
//                                       (Get.locale?.languageCode ?? 'en') == 'en'
//                                           ? null
//                                           : 0,
//                                   child: Container(
//                                     height: 14.h,
//                                     width: 14.h,
//                                     decoration: const BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: FittedBox(
//                                         child: Text(
//                                           ctrl.unviewedNotificationsCount
//                                               .toString(),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 10.sp,
//                                             fontWeight: FontWeight.w500,
//                                             fontFamily: 'robot',
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//               if (ctrl.user == null)
//                 ElevatedButton(
//                   onPressed: () async {
//                     Get.toNamed(AppRoutes.login);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: REdgeInsets.symmetric(
//                       vertical: 8.h,
//                       horizontal: 10.w,
//                     ),
//                   ),
//                   child: Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                     child: Text(
//                       'Get Started'.tr,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//             ],
//           )