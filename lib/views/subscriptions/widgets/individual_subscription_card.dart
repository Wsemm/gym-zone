import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/functions.dart';
import 'package:gym_zones/common/constants/my_enum.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/controllers/subscriptions_controller.dart';
import 'package:gym_zones/models/Individual_subscription_plan.dart';
import 'package:gym_zones/models/user.dart';
import '../../../models/subscription_plan.dart';

class IndividualSubscriptionCard extends StatelessWidget {
  final MyNewData plan;
  // final VoidCallback btnClick;

  const IndividualSubscriptionCard({
    super.key,
    required this.plan,
    // required this.btnClick
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SubscriptionsController());
    // User user = User.fromJson(GetStorage().read('user'));
    // bool hasSubsribe =
    //     user.subscriptionType == SubscriptionType.individual.name ||
    //         user.subscriptionType == SubscriptionType.both.name;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  "${plan.title.toString()}",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  '${'OMR'.tr} ${plan.totalPrice}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (plan.basePrice != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      '${'Save'.tr} ${plan.basePrice}%',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5.w,
              ),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  print("===== gym id from subscription card ${plan.gymId}");
                  if (GetStorage().read('token') != null) {
                    Get.find<SubscriptionsController>().totalAmount.value =
                        double.parse(plan.totalPrice!.toString());
                    Get.toNamed(AppRoutes.cartPage,
                        arguments: {"item": plan, "isIndividual": true});

                    // if (hasSubsribe) {
                    //   Get.toNamed(AppRoutes.giftSubscription);
                    // } else {
                    //   showGiftDialog(
                    //     context: context,
                    //     gift: () => Get.toNamed(AppRoutes.giftSubscription),
                    //     subscribe: () {
                    //       Get.find<SubscriptionsController>()
                    //           .totalAmount
                    //           .value = double.parse(plan.amount!);
                    //       Get.toNamed(AppRoutes.cartPage,
                    //           arguments: {"item": plan});
                    //     },
                    //   );
                    // }
                  } else {
                    Get.toNamed(AppRoutes.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  // hasSubsribe ? 'Gift 🎁'.tr : 'Subscribe Now'.tr,
                  'Subscribe Now'.tr,

                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
