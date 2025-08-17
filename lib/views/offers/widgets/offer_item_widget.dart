import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/widgets/rebi_image.dart';
import 'package:gym_zones/views/new_visit/qr_scan_view.dart';
import 'package:gym_zones/views/offers/data/offer_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../common/constants/api.dart';
import '../../../common/navigation/app_routes.dart';
import '../../../common/styles/app_colors.dart';

class OfferItemWidget extends StatelessWidget {
  final Offer item;

  const OfferItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(
          vertical: 10.w,
          horizontal: 10.h,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.h,
            right: 10.w,
            left: 10.w,
            bottom: 1.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: Get.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: RebiImage(
                            imageUrl:
                                "${Api.IMAGE_PREFIX_Test}${item.coverPath}",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      if (item.discount != null && item.discount != 0)
                        Transform.rotate(
                          angle: 0,
                          child: Container(
                            width: 100,
                            height: 40,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "${"SALE".tr} ${item.discount} %",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.w,
                  horizontal: 10.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///
                    /// title
                    /// image
                    /// description
                    ///
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 70.w,
                          width: 70.w,
                          child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.r),
                                  child: RebiImage(
                                    imageUrl:
                                        "${Api.IMAGE_PREFIX_Test}${item.logoPath}",
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.companyName ?? "",
                                style: TextStyle(
                                  // color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Text(
                                item.description ?? "",
                                maxLines: 3,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///
                    /// location
                    /// phone
                    /// scan qr
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            ///
                            /// Get Place name  from location details
                            ///

                            String locationUrl =
                                "https://www.google.com/maps/place/${item.longitude},${item.latitude}/20z";
                            launchUrl(
                              Uri.parse(locationUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Location".tr,
                                // "${item.distanceKm!.toStringAsFixed(2)} Km",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            launchUrlString("tel://${item.phoneNo}");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                item.phoneNo ?? "",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (GetStorage().read('token') == null) {
                              Get.toNamed(AppRoutes.login);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QrScanView(
                                          fromOffers: true,
                                        )),
                              ).then((value) {
                                if (value != null && value == "Done") {
                                  if (item.qrType == 'link') {
                                    launchUrl(
                                      Uri.parse(item.qrUrl ?? ''),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else if (item.qrType == "image") {
                                    Get.dialog(
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 300.w,
                                              height: 300.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: RebiImage(
                                                  imageUrl: item.qrUrl,
                                                  fit: BoxFit.fill,
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  } else {
                                    log("========= New Type ========");
                                  }
                                }
                              });
                            }
                          },
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 25.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
