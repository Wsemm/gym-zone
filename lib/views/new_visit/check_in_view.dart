import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/constants/api.dart';
import '../../common/constants/constants.dart';
import '../../common/styles/app_colors.dart';
import '../../models/visit.dart';

class CheckInView extends StatelessWidget {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context) {
    final checkInInfo = Get.arguments as Visit?;

    if (checkInInfo == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
          iconTheme: const IconThemeData(color: Colors.red),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 64.sp,
                ),
                SizedBox(height: 24.h),
                Text(
                  '(Access Denied) Possible reasons include: Inactive subscription, Check-in at another gym within the last 12 hours, gym not for your gender, or Invalid QR code.'
                      .tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(24.r),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 64.r,
                  backgroundImage: checkInInfo.user.imagePath != null
                      ? CachedNetworkImageProvider(
                          '${Api.IMAGE_PREFIX}${checkInInfo.user.imagePath!}')
                      : AssetImage(
                          checkInInfo.user.gender == 'male'
                              ? 'assets/images/male-placeholder.png'
                              : 'assets/images/female-placeholder.png',
                        ) as ImageProvider<Object>?,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  checkInInfo.user.fullname,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '🏋🏽 ${Get.locale!.languageCode == 'en' ? checkInInfo.gym.name : checkInInfo.gym.nameAr}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '📍 ${Get.locale!.languageCode == 'en' ? checkInInfo.gym.province.name : checkInInfo.gym.province.nameAr}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  thickness: 1.w,
                  height: 24.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subscription start date:'.tr,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(checkInInfo.user.subscribedAt!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subscription end date:'.tr,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(checkInInfo.user.subscriptionExpiresAt!),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Check-in time:'.tr,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    Text(
                      DateFormat(Get.locale!.languageCode == 'en'
                              ? 'yyyy-MM-dd, hh:mm a'
                              : 'a hh:mm, yyyy-MM-dd')
                          .format(checkInInfo.timestamp),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
