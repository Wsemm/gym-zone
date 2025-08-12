import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/api.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/common/widgets/rebi_image.dart';
import 'package:gym_zones/models/ad.dart';
import 'package:url_launcher/url_launcher.dart';

class AdCard extends StatelessWidget {
  final Data ad;
  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      height: 188.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image:
              // NetworkImage("https://placehold.co/600x400/000000/FFFFFF.png"),
              NetworkImage("${Api.IMAGE_PREFIX}${ad.image}" ??
                  "https://placehold.co/600x400/000000/FFFFFF.png"),
          onError: (error, stackTrace) => Image.asset(
            "assets/images/launcher-icon.png",
            height: 280.h,
            width: 188.w,
            fit: BoxFit.fill,
          ),
          opacity: 0.5,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 16.h),
            // Text(
            //   Get.locale == const Locale("en")
            //       ? (ad.title ?? "Ad Title")
            //       : (ad.titleAr ?? "عنوان الإعلان"),
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.w700),
            // ),
            // SizedBox(height: 10.h),
            // // Text(
            // //   ad.description!,
            // //   style: TextStyle(height: 1.5),
            // // ),
            Spacer(),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              color: AppColors.primary,
              child: Text("View ad".tr, style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (ad.adurl != null) {
                  launchUrl(
                    Uri.parse(ad.adurl!),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
