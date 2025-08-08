import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:url_launcher/url_launcher.dart';

class GymBranch extends StatelessWidget {
  const GymBranch({
    required this.gymBranch,
    super.key,
  });

  final Branches gymBranch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: AppColors.primary,
        ),
        Text(
          "${Get.locale!.languageCode == "en" ? gymBranch.name : gymBranch.nameAr}",
          style: TextStyle(
              color: const Color.fromRGBO(101, 111, 125, 1),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            launchUrl(
              Uri.parse(gymBranch.locationUrl!),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Text("Locate on Maps".tr,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primary,
              )),
        )
      ],
    );
  }
}
