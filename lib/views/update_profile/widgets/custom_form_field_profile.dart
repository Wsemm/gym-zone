import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

class CustomTextFormFieldProfile extends StatelessWidget {
  const CustomTextFormFieldProfile(
      {super.key,
      required this.controller,
      required this.hintText,
      this.validator});
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: false,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8.r),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: Image.asset(AppImages.pin),
      ),
    );
  }
}
