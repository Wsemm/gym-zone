import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/app_images.dart';

import '../../controllers/custom_bottom_nav_bar_controller.dart';
import '../../models/user.dart';
import '../navigation/app_routes.dart';
import '../styles/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  bool _hasCurrentUserValidSubscription() {
    final userInGetStorage = GetStorage().read('user');
    final User? user =
        userInGetStorage == null ? null : User.fromJson(userInGetStorage);

    return user != null && user.hasSubscription;
  }

  @override
  Widget build(BuildContext context) {
    bool hasSubscription = _hasCurrentUserValidSubscription();
    return GetBuilder<CustomBottomNavBarController>(
      builder: (ctrl) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24.r),
            topLeft: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1.r,
              offset: const Offset(0, -0.5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          child: BottomNavigationBar(
            currentIndex: ctrl.currentIndex,
            fixedColor: AppColors.primary,
            type: BottomNavigationBarType.fixed,
            iconSize: 20.sp,
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            onTap: (index) {
              ctrl.changePage(index);
              switch (index) {
                case 0:
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(AppRoutes.home));
                  break;
                case 1:
                  // if (hasSubscription) {
                  //   Navigator.of(context).pushNamed(AppRoutes.visits);
                  //   // Navigator.of(context).pushNamed(AppRoutes.subscriptions);
                  // } else {
                  Navigator.of(context).pushNamed(AppRoutes.subscriptions);
                  // }
                  break;
                case 2:
                  Navigator.of(context)
                      .pushNamed(AppRoutes.individualSubscription);
                  break;
                case 3:
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_rounded),
                label: 'Home'.tr,
              ),
              // if (hasSubscription)
              //   BottomNavigationBarItem(
              //     icon: const Icon(Icons.history_rounded),
              //     label: 'Visits'.tr,
              //   )
              // else
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  AppImages.groupGyms,
                  color: AppColors.primary,
                ),
                icon: Image.asset(
                  AppImages.groupGyms,
                  color: ctrl.currentIndex == 1 ? AppColors.primary : null,
                ),
                label: 'Group sub'.tr,
              ),
              BottomNavigationBarItem(
                activeIcon: Image.asset(
                  AppImages.individualGym,
                  color: AppColors.primary,
                ),
                icon: Image.asset(
                  AppImages.individualGym,
                ),
                label: 'Individual sub'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                label: 'Settings'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
