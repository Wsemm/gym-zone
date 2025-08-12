import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/models/Individual_subscription_plan.dart';

import '../../../models/subscription_plan.dart';

class CartItemWidget extends StatelessWidget {
  final SubscriptionPlan item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.w,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50.w,
                height: 50.w,
                child: Center(
                  child: Icon(
                    Icons.amp_stories_outlined,
                    color: AppColors.primary,
                    size: 40.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.durationText.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      // color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${'OMR'.tr} ${item.amount.toStringAsFixed(3)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      // color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemWidgetIndividual extends StatelessWidget {
  final MyNewData item;

  const CartItemWidgetIndividual({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.w,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 15.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50.w,
                height: 50.w,
                child: Center(
                  child: Icon(
                    Icons.amp_stories_outlined,
                    color: AppColors.primary,
                    size: 40.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 220.w,
                    ),
                    child: Text(
                      "${item.title}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        // color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '${'OMR'.tr} ${item.totalPrice}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      // color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
