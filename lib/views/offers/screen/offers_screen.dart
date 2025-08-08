import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/widgets/loading_widget.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';
import 'package:gym_zones/views/offers/widgets/offer_item_widget.dart';
import '../../../common/constants/constants.dart';
import '../../../common/styles/app_colors.dart';

class OffersScreen extends GetView<OfferController> {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        automaticallyImplyLeading: true,
        title: Text(
          Get.arguments["title"].toString(),
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Material(
              elevation: 2.h,
              borderRadius: BorderRadius.circular(20.r),
              child: TextField(
                  enabled: true,
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search'.tr,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.grey[400],
                        size: 16.sp,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    EasyDebounce.debounce(
                        'search', const Duration(milliseconds: 500), () {
                      controller.updateList(value);
                    });
                  }),
            ),
          ),
          GetBuilder<OfferController>(builder: (ctrl) {
            return Expanded(
              child: ctrl.isLoadingOffers.value
                  ? const LoadingWidget()
                  : ListView.builder(
                      primary: true,
                      shrinkWrap: true,
                      itemCount: ctrl.offersList.length,
                      itemBuilder: (context, index) {
                        return OfferItemWidget(item: ctrl.offersList[index]);
                      }),
            );
          }),
        ],
      ),
    );
  }
}
