import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/models/user.dart';
import 'package:intl/intl.dart';

import '../../../common/constants/api.dart';
import '../../../models/visit.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;

  const VisitCard({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sp),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: '${Api.IMAGE_PREFIX}${visit.gym.logoPath}',
                // imageUrl: 'https://placehold.co/600x400/000000/FFFFFF.png',
                height: 84.h,
                width: 84.w,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: ListTile(
                isThreeLine: true,
                title: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    Get.locale!.languageCode == 'en'
                        ? visit.gym.name
                        : visit.gym.nameAr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.locale!.languageCode == 'en'
                          ? visit.gym.province.name
                          : visit.gym.province.nameAr,
                      style: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          '🕗 ${DateFormat(Get.locale!.languageCode == 'en' ? 'yyyy-MM-dd, hh:mm a' : 'a hh:mm, yyyy-MM-dd').format(visit.timestamp)}',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndividualVisitCard extends StatelessWidget {
  final User user;
  const IndividualVisitCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String subscriptionDays = user.subscriptionExpiresAtIndividual!
        .difference(user.subscribedAtIndividual!)
        .inDays
        .toString();
    bool isEnglish = Get.locale!.languageCode == 'en';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.sp),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    errorWidget: (context, error, stackTrace) => Image.asset(
                      "assets/images/launcher-icon.png",
                      height: 84.h,
                      width: 84.w,
                      fit: BoxFit.fill,
                    ),
                    // imageUrl: 'https://placehold.co/600x400/000000/FFFFFF.png',
                    imageUrl:
                        user.gymImage ?? "assets/images/launcher-icon.png",
                    height: 84.h,
                    width: 84.w,
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                Get.locale!.languageCode == 'en'
                                    ? user.gymName!
                                    : user.gymNameAr!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  // Get.locale!.languageCode == 'en'
                                  //     ? visit.gym.name
                                  //     : visit.gym.nameAr,
                                  Get.locale!.languageCode == 'en'
                                      ? "Subscription plan: "
                                      : "خطة الاشتراك: ",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                  // Get.locale!.languageCode == 'en'
                                  //     ? visit.gym.name
                                  //     : visit.gym.nameAr,
                                  Get.locale!.languageCode == 'en'
                                      ? "${user.individualPlanDays} days"
                                      : "${user.individualPlanDays} أيام",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                spacing: 5.w,
                children: [
                  Text(
                    Get.locale!.languageCode == 'en'
                        ? "Subscription duration: "
                        : "مدة الإشتراك: ",
                    style: TextStyle(fontSize: isEnglish ? 12.sp : 14.sp),
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 20.sp,
                        color: Colors.grey,
                      ),
                      Text(
                        '${DateFormat(Get.locale!.languageCode == 'en' ? 'yyyy-MM-dd' : 'yyyy-MM-dd').format(user.subscribedAtIndividual!)}',
                        style: TextStyle(fontSize: isEnglish ? 10.sp : 14.sp),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5.w,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 20.sp,
                        color: Colors.grey,
                      ),
                      Text(
                        '${DateFormat(Get.locale!.languageCode == 'en' ? 'yyyy-MM-dd' : 'yyyy-MM-dd').format(user.subscriptionExpiresAtIndividual!)}',
                        style: TextStyle(fontSize: isEnglish ? 10.sp : 14.sp),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
