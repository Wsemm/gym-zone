import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/styles/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onTap;
  final Widget? prefixIcon;
  final bool? obscureText;
  final Function? onSuffixTap;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isOnlyNumber;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    this.prefixIcon,
    this.obscureText,
    this.onSuffixTap,
    this.keyboardType,
    this.validator,
    this.isOnlyNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: focusNode.hasFocus ? 0 : 2.r,
      color: AppColors.textfieldBackground,
      borderRadius: BorderRadius.circular(20.r),
      child: TextFormField(
        inputFormatters:
            isOnlyNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        validator: validator,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        controller: controller,
        focusNode: focusNode,
        onTap: () => onTap(),
        style: TextStyle(fontSize: 16.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey.shade400,
          ),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            // borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          suffixIcon: obscureText == null || onSuffixTap == null
              ? null
              : InkWell(
                  onTap: onSuffixTap as void Function()?,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      obscureText!
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20.sp,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
