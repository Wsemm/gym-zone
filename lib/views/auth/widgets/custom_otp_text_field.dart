import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

class CustomOtpTextField extends StatelessWidget {
  const CustomOtpTextField({super.key, required this.onSubmit});
  final void Function(String) onSubmit;
  @override
  Widget build(BuildContext context) {
    return OtpTextField(
        cursorColor: AppColors.primary,
        enabledBorderColor: Colors.grey,
        focusedBorderColor: AppColors.primary,
        fieldWidth: Get.width * 0.13,
        borderRadius: BorderRadius.circular(10),
        numberOfFields: 6,
        showFieldAsBox: true,
        onCodeChanged: (String code) {},
        onSubmit: onSubmit);
  }
}
