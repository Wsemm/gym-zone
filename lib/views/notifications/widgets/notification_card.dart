import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/styles/app_colors.dart';
import '../../../models/notification.dart';

class NotificationCard extends StatelessWidget {
  final Notification notification;

  const NotificationCard({super.key, required this.notification});

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
      color: !notification.viewed ? AppColors.textfieldBackground : null,
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              margin: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: notification.getIconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                notification.notificationIcon,
                color: notification.getIconColor,
                size: 24.sp,
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  notification.notificationTitle!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                subtitle: Text(
                  notification.notificationBody!,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
