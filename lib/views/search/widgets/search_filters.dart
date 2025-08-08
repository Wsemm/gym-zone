import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/styles/app_colors.dart';
import '../../../controllers/search_controller.dart';

class SearchFilters extends StatelessWidget {
  const SearchFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SearchController>();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: GetBuilder<SearchController>(builder: (context) {
          if (ctrl.governorates == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4.h,
                width: 0.2.sw,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Text(
                'Filters'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Obx(
                            () {
                              return Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    child: Text('Select Governorate'.tr),
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.w),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2.w,
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: DropdownButton<int>(
                                      value: ctrl.selectedGovernorate.value,
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          ctrl.selectedGovernorate.value =
                                              newValue;
                                          ctrl.selectedProvinces.clear();
                                        }
                                      },
                                      items: ctrl.governorates!
                                          .map<DropdownMenuItem<int>>(
                                              (governorate) {
                                        return DropdownMenuItem<int>(
                                          value: governorate.id,
                                          child: FittedBox(
                                            child: Text(
                                              Get.locale!.languageCode == 'en'
                                                  ? governorate.name
                                                  : governorate.nameAr,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Obx(
                            () {
                              final governorate =
                                  ctrl.governorates!.firstWhereOrNull(
                                (g) => g.id == ctrl.selectedGovernorate.value,
                              );

                              if (governorate == null) return const SizedBox();

                              return Expanded(
                                child: ListView(
                                  children: governorate.provinces!.map(
                                    (province) {
                                      return CheckboxListTile(
                                        title: Text(
                                          Get.locale!.languageCode == 'en'
                                              ? province.name
                                              : province.nameAr,
                                        ),
                                        value: ctrl.selectedProvinces
                                            .contains(province.id),
                                        onChanged: (bool? selected) {
                                          if (selected != null && selected) {
                                            ctrl.selectedProvinces
                                                .add(province.id);
                                          } else {
                                            ctrl.selectedProvinces
                                                .remove(province.id);
                                          }
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text('Show Mixed Gyms'.tr),
                            ),
                            SizedBox(height: 8.h),
                            Switch.adaptive(
                              activeColor: AppColors.primary,
                              value: ctrl.showMixedGyms.value,
                              onChanged: (value) {
                                ctrl.showMixedGyms.value = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0.4.sw,
              margin: EdgeInsets.only(bottom: 8.h),
              child: ElevatedButton(
                onPressed: () {
                  ctrl.performNewSearchOperation();
                  Get.back();
                },
                child: Text('Apply'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
