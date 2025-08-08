import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/constants/constants.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/notifications_controller.dart';
import 'widgets/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        title: Text(
          'NOTIFICATIONS'.tr,
          style: const TextStyle(
            color: AppColors.primary,
          ),
        ),
      ),
      body: GetBuilder<NotificationsController>(builder: (ctrl) {
        if (ctrl.notificationsList == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.notificationsList!.isEmpty) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/no-notifications.png',
                ),
                Text(
                  'No notifications yet'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'You will receive notifications here'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: ctrl.notificationsList!.length,
          itemBuilder: (context, index) {
            final notification = ctrl.notificationsList![index];
            if ((notification.type == 'other' ||
                    notification.type == 'trip_started') &&
                (notification.notificationTitle == null ||
                    notification.notificationBody == null)) {
              return const SizedBox.shrink();
            }
            return NotificationCard(notification: notification);
          },
        );
      }),
    );
  }
}
