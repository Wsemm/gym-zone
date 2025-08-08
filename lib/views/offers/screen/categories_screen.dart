import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';
import 'package:gym_zones/views/offers/widgets/categories_empty_widget.dart';
import 'package:gym_zones/views/offers/widgets/category_item_widget.dart';

import '../../../common/constants/constants.dart';
import '../../../common/styles/app_colors.dart';
import '../../../common/widgets/custom_bottom_nav_bar.dart';
import '../../../common/widgets/loading_widget.dart';

class CategoriesScreen extends GetView<OfferController> {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        automaticallyImplyLeading: false,
        title: Text(
          'Offers'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Obx(
            () => controller.isLoadingCategories.value
                ? const LoadingWidget()
                :
            controller.categoriesList.isEmpty?
    const CategoriesEmptyWidget()
                :

            GridView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 150),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: controller.categoriesList.length,
                    itemBuilder: (context, index) {
                      return CategoryItemWidget(
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
                    },
                  ),
          )),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
