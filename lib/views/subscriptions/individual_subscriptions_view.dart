import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/home_controller.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/widgets/custom_bottom_nav_bar.dart';
import '../../controllers/subscriptions_controller.dart';
import 'widgets/filtered_gym_list.dart';
import 'widgets/subscriptions_governorate_dropdown.dart';
import 'widgets/subscription_card.dart';

class IndividualSubscriptionsView extends StatelessWidget {
  const IndividualSubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<SubscriptionsController>(builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(123, 221, 220, 220),
            systemOverlayStyle: appBarSystemStyle,
            automaticallyImplyLeading: false,
            //     ctrl.user != null && ctrl.user!.hasSubscription,
            title: Text('Individual subscription'.tr),
          ),
          body: Builder(
            builder: (_) {
              if (ctrl.plans == null) {
                return const LoadingWidget();
              }

              if (ctrl.plans!.isEmpty) {
                return Center(child: Text('No Gyms available!'.tr));
              }

              return Container(
                padding: EdgeInsets.all(16.sp),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    GetBuilder<HomeController>(
                      builder: (homeCtrl) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Individual gyms'.tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SubscriptionsGovernorateDropdown(),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          const IndividualFilteredGymList(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          bottomNavigationBar:
              // ctrl.user != null && ctrl.user!.hasSubscription
              //     ? null
              //     :
              const CustomBottomNavBar(),
        );
      }),
    );
  }
}
