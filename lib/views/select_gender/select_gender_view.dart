import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';

class SelectGenderView extends StatefulWidget {
  const SelectGenderView({super.key});

  @override
  State<SelectGenderView> createState() => _SelectGenderViewState();
}

class _SelectGenderViewState extends State<SelectGenderView> {
  String _selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please choose your gender'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'male';
                      });
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.man_2_rounded,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                          Text('Male'.tr),
                          if (_selectedGender == 'male')
                            Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 18.sp,
                            )
                          else
                            SizedBox(
                              width: 5.w,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'female';
                      });
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.woman_2_rounded,
                            color: AppColors.primary,
                            size: 24.sp,
                          ),
                          Text('Female'.tr),
                          if (_selectedGender == 'female')
                            Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                              size: 18.sp,
                            )
                          else
                            SizedBox(
                              width: 5.w,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 12.w,
        ),
        child: ElevatedButton(
          onPressed: () {
            GetStorage().write('gender', _selectedGender);
            Get.offNamed(AppRoutes.home);
          },
          child: Text('Continue'.tr),
        ),
      ),
    );
  }
}
