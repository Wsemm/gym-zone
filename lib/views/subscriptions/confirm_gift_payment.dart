import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/countries.dart';
import 'package:gym_zones/common/styles/app_colors.dart';
import 'package:gym_zones/views/subscriptions/gift_subscription_view.dart';

class ConfirmGiftPaymentController extends GetxController {
  List<RecipientData> recipients = [];
  bool isEditing = false;

  @override
  void onInit() {
    super.onInit();
    // Get recipients data from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments['recipients'] != null) {
      recipients = List<RecipientData>.from(arguments['recipients']);
    }
  }

  void toggleEditMode() {
    isEditing = !isEditing;
    update();
  }

  void removeRecipient(int index) {
    recipients.removeAt(index);
    update();
  }

  void updateRecipientPhone(int index, String phone) {
    recipients[index].phoneController.text = phone;
    update();
  }

  void updateRecipientCountry(int index, String countryCode) {
    recipients[index].selectedCountryCode = countryCode;
    update();
  }

  void confirmPayment() {
    print("=== Confirmed Recipients ===");
    for (int i = 0; i < recipients.length; i++) {
      final recipient = recipients[i];
      print("Recipient ${i + 1}:");
      print("  Country Code: ${recipient.selectedCountryCode}");
      print("  Phone Number: ${recipient.phoneController.text}");
    }
    print("==========================");
    Get.back();
  }
}

class ConfirmGiftPayment extends StatelessWidget {
  const ConfirmGiftPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmGiftPaymentController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirm Gift Payment".tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.toggleEditMode,
            icon: Icon(
              controller.isEditing ? Icons.check : Icons.edit,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20.h),
            Image.asset(
              AppImages.giftConfirm,
              width: 165.w,
              height: 160.h,
            ),
            SizedBox(height: 20.h),
            Text(
              "Gift will be sent to:".tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20.h),
            GetBuilder<ConfirmGiftPaymentController>(
              builder: (controller) => _buildRecipientsList(controller),
            ),
            SizedBox(height: 20.h),
            _buildConfirmButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientsList(ConfirmGiftPaymentController controller) {
    if (controller.recipients.isEmpty) {
      return Center(
        child: Text(
          "No recipients found".tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.recipients.length,
      itemBuilder: (context, index) {
        return _buildRecipientWidget(controller, index);
      },
    );
  }

  Widget _buildRecipientWidget(
      ConfirmGiftPaymentController controller, int index) {
    final recipient = controller.recipients[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.isEditing) ...[
            Row(
              children: [
                SizedBox(width: 30.w),
                Text(
                  "Recipient".tr + " ${index + 1}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => controller.removeRecipient(index),
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ],
          Row(
            children: [
              Icon(
                Icons.circle,
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: controller.isEditing
                    ? _buildEditableRecipient(controller, index, recipient)
                    : _buildReadOnlyRecipient(recipient, index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyRecipient(RecipientData recipient, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recipient".tr + " ${index + 1}",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Text(
          "${recipient.selectedCountryCode} ${recipient.phoneController.text}",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }

  Widget _buildEditableRecipient(
    ConfirmGiftPaymentController controller,
    int index,
    RecipientData recipient,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: recipient.phoneController,
                onChanged: (value) =>
                    controller.updateRecipientPhone(index, value),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone number".tr,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              constraints: BoxConstraints(maxWidth: 0.28.sw),
              child: DropdownButtonFormField<String>(
                value: recipient.selectedCountryCode,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateRecipientCountry(index, value);
                  }
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                items: countries.map<DropdownMenuItem<String>>((country) {
                  return DropdownMenuItem<String>(
                    value: country['code']!,
                    child: Text(
                      country['display']!.tr,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmButton(ConfirmGiftPaymentController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.confirmPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          "Confirm Payment".tr,
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
