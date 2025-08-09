import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

import '../../../common/constants/api.dart';
import '../../../models/user.dart';

class TopUserCard extends StatelessWidget {
  final User user;

  const TopUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166.w,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8.sp),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundImage:
                      user.imagePath != null && user.showImageToOthers
                          ? CachedNetworkImageProvider(
                              '${Api.IMAGE_PREFIX}${user.imagePath!}')
                          : AssetImage(
                              user.gender == 'male'
                                  ? 'assets/images/male-placeholder.png'
                                  : 'assets/images/female-placeholder.png',
                            ) as ImageProvider<Object>?,
                  radius: 48.r,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${user.firstname} ${user.lastname}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 4.h),

                Text("🏆"),
                SizedBox(height: 4.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${'Points count'.tr}: ',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      TextSpan(
                        text: '${user.thisMonthPoints}',
                        style: TextStyle(
                            color: AppColors.primary, fontSize: 14.sp),
                      ),
                    ],
                  ),
                )
                // Text(
                //   '${'Points'.tr}: ${user.thisMonthPoints}',
                //   style: TextStyle(fontSize: 14.sp),
                // ),
                // Add more details as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
