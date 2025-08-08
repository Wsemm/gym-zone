import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/constants.dart';
import 'package:gym_zones/common/constants/countries.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

class GiftSubscriptionController extends GetxController {
  final recipients = <RecipientData>[];

  @override
  void onInit() {
    super.onInit();
    // Initialize with one recipient
    recipients.add(RecipientData());
  }

  void addRecipient() {
    recipients.add(RecipientData());
    update();
  }

  void removeRecipient(int index) {
    if (recipients.length > 1) {
      recipients.removeAt(index);
      update();
    }
  }

  void printAllRecipients() {
    print("=== All Recipients Data ===");

    // Print all recipients
    for (int i = 0; i < recipients.length; i++) {
      final recipient = recipients[i];
      print("Recipient ${i + 1}:");
      print("  Country Code: ${recipient.selectedCountryCode}");
      print("  Phone Number: ${recipient.phoneController.text}");
    }
    print("==========================");

    // Navigate to confirm payment view with recipient data
    Get.toNamed(AppRoutes.confirmGiftPayment, arguments: {
      'recipients': recipients,
    });
  }
}

class RecipientData {
  String selectedCountryCode = countries.first['code']!;
  final TextEditingController phoneController = TextEditingController();

  void updateCountryCode(String? value) {
    if (value != null) {
      selectedCountryCode = value;
    }
  }

  void updatePhoneNumber(String value) {
    phoneController.text = value;
  }

  void dispose() {
    phoneController.dispose();
  }
}

class GiftSubscriptionView extends StatelessWidget {
  GiftSubscriptionView({super.key});

  final GiftSubscriptionController controller =
      Get.put(GiftSubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        title: Text(
          "Give the subscription as a gift 🎁".tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Choose who you want to gift a unique sports experience to.".tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Phone number (WhatsApp number)".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            GetBuilder<GiftSubscriptionController>(
              builder: (controller) => SingleChildScrollView(
                child: Column(
                  children: [
                    // All recipients including the first one
                    ...controller.recipients.asMap().entries.map((entry) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15.h),
                        child: _buildRecipientWidget(entry.key,
                            isFirst: entry.key == 0),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildAddButton(),
            SizedBox(height: 16.h),
            _buildPrintButton(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientWidget(int index, {required bool isFirst}) {
    final recipientData = controller.recipients[index];

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFirst) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recipient".tr + " ${index + 1}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.removeRecipient(index),
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  iconSize: 20.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 0.5.sw),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: recipientData.phoneController,
                  onChanged: (value) {
                    recipientData.updatePhoneNumber(value);
                    controller.update();
                  },
                  decoration: InputDecoration(
                    hintText: "Phone number".tr,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                constraints: BoxConstraints(maxWidth: 0.3.sw),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  value: recipientData.selectedCountryCode,
                  onChanged: (value) {
                    recipientData.updateCountryCode(value);
                    controller.update();
                  },
                  items: countries.map<DropdownMenuItem<String>>((country) {
                    return DropdownMenuItem<String>(
                      value: country['code']!,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 0.14.sw),
                        child: FittedBox(
                          child: Text(
                            country['display']!.tr,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: controller.addRecipient,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            "Add another recipient".tr,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              color: AppColors.primary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrintButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.printAllRecipients,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          "Send the gift now".tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
