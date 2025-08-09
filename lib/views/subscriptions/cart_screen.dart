import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/widgets/rebi_button.dart';
import 'package:gym_zones/models/Individual_subscription_plan.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:gym_zones/views/subscriptions/widgets/cart_item_widget.dart';
import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/custom_bottom_nav_bar_controller.dart';
import '../../controllers/subscriptions_controller.dart';
import '../../models/subscription_plan.dart';

class CartScreen extends GetView<SubscriptionsController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionPlan? item;
    MyNewData? itemIndividual;
    bool isIndividual = false;
    if (Get.arguments != null) {
      if (Get.arguments["isIndividual"] != null) {
        isIndividual = Get.arguments["isIndividual"];
      }
      if (Get.arguments["item"] is SubscriptionPlan) {
        item = Get.arguments["item"];
      } else {
        itemIndividual = Get.arguments["item"];
      }
    }
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        automaticallyImplyLeading: true,
        title: Text(
          "Checkout".tr,
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (item != null)
              CartItemWidget(
                item: item,
              ),
            if (itemIndividual != null)
              CartItemWidgetIndividual(
                item: itemIndividual,
              ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 300.h,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5.r),
            bottomRight: Radius.circular(5.r),
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          )),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Text(
                    "Do you have any Coupon ?".tr,
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Form(
                  key: controller.couponKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Material(
                          borderRadius: BorderRadius.circular(10.r),
                          child: TextFormField(
                            controller: controller.couponController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required'.tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Coupon".tr,
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.sp)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Obx(
                        () => InkWell(
                            child: Container(
                              height: 40.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                      color: AppColors.primary, width: 1.h)),
                              child: Center(
                                child: controller.isLoading.value
                                    ? SizedBox(
                                        height: 15.w,
                                        width: 15.w,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 1.w,
                                        ),
                                      )
                                    : Text(
                                        "Apply Discount".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.primary),
                                      ),
                              ),
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              if (controller.couponKey.currentState!
                                  .validate()) {
                                if (controller
                                    .couponController.text.isNotEmpty) {
                                  controller.checkCoupon(
                                      controller.couponController.text);
                                }
                              }
                            }),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Text(
                    "Subscription info".tr,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price".tr,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "${controller.totalAmount.toStringAsFixed(2)} ${"OMR".tr}",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(
                  () => controller.totalAmountAfterDiscount.value == 0.0
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Discount".tr,
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              "-${controller.discount.toStringAsFixed(2)} ${"OMR".tr}",
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total".tr,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        controller.totalAmountAfterDiscount.value == 0.0
                            ? "${controller.totalAmount.toStringAsFixed(2)} ${"OMR".tr}"
                            : "${controller.totalAmountAfterDiscount.toStringAsFixed(2)} ${"OMR".tr}",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                RebiButton(
                  height: 25.h,
                  backgroundColor: AppColors.primary,
                  radius: 10.r,
                  child: Text(
                    "Checkout".tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  onPressed: () async {
                    int subscriptionId = Get.arguments['item'].id;
                    log("# subscriptionId : $subscriptionId");
                    if (Get.find<AuthController>().token == null) {
                      Get.toNamed(AppRoutes.login);
                      return;
                    }

                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    final ctrl = Get.find<SubscriptionsController>();

                    final response = await ctrl.subscribe(
                        planId: subscriptionId,
                        isIndividual: isIndividual,
                        gymId: itemIndividual?.id.toString());

                    if (response == SubscriptionStatus.alreadySubscribed) {
                      Get.back();
                      Get.snackbar(
                        'Not allowed'.tr,
                        'You are already subscribed!'.tr,
                        backgroundColor: Colors.yellow.shade700,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(4.sp),
                      );
                    } else if (response ==
                        SubscriptionStatus.subscriptionFailed) {
                      Get.back();
                      Get.snackbar(
                        'Error'.tr,
                        'Something went wrong. Please try later, or contact us.'
                            .tr,
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.all(4.sp),
                      );
                    } else if (response ==
                        SubscriptionStatus.paymentCancelled) {
                      Get.back();
                      Get.snackbar(
                        'Cancelled'.tr,
                        'Your payment has been cancelled'.tr,
                        backgroundColor: Colors.grey,
                        margin: EdgeInsets.all(4.sp),
                      );
                    } else if (response == SubscriptionStatus.paymentFailed) {
                      Get.back();
                      Get.snackbar(
                        'Failed'.tr,
                        'Payment failed!'.tr,
                        backgroundColor: Colors.red,
                        margin: EdgeInsets.all(4.sp),
                      );
                    } else if (response == SubscriptionStatus.success) {
                      Get.find<CustomBottomNavBarController>().changePage(0);
                      Get.offNamed(AppRoutes.successPayment);
                      Get.snackbar(
                        'Success'.tr,
                        'Your subscription has been activated successfully'.tr,
                        backgroundColor: Colors.green,
                        margin: EdgeInsets.all(4.sp),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
