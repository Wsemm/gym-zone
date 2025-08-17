import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';
import 'package:gym_zones/views/offers/widgets/category_item_widget.dart';

class OfferSection extends StatelessWidget {
  const OfferSection({
    super.key,
    required this.ctrl,
  });
  final HomeController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Offers".tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                // Get.find<CustomBottomNavBarController>().changePage(2);
                Get.toNamed(AppRoutes.categoriesPage);
              },
              child: Text(
                "View more".tr,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          width: 1.sw,
          child: GetBuilder<OfferController>(builder: (controller) {
            return controller.isLoadingOffers.value
                ? const LoadingWidget()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    primary: true,
                    shrinkWrap: true,
                    itemCount: controller.categoriesList.length,
                    itemBuilder: (context, index) {
                      return CategoryItemWidgetNew(
                        item: controller.categoriesList[index],
                        btnClick: () {
                          controller.fetchOffersByCategory(
                              controller.categoriesList[index].id ?? 0);
                          Get.toNamed(AppRoutes.offerPage, arguments: {
                            "title": Get.locale!.languageCode == "en"
                                ? controller.categoriesList[index].name ?? ""
                                : controller.categoriesList[index].nameAr ?? "",
                          });
                        },
                      );
                    });
          }),
        )
      ],
    );
  }
}
