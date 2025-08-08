import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

/// Enum defining different validation types
enum ValidationType {
  required,
  email,
  password,
  confirmPassword,
  phoneNumber,
  name,
  age,
  weight,
  height,
  coupon,
  verificationCode,
  custom,
}

/// Main validator class that provides validation functions for TextFormField
class AppValidator {
  /// Main validator function that returns appropriate validator based on type
  static String? Function(String?) validator({
    required ValidationType type,
    String? customErrorMessage,
    String? compareValue, // For confirm password validation
    int? minLength,
    int? maxLength,
    String? Function(String?)? customValidator,
  }) {
    return (String? value) {
      switch (type) {
        case ValidationType.required:
          return _validateRequired(value, customErrorMessage);

        case ValidationType.email:
          return _validateEmail(value, customErrorMessage);

        case ValidationType.password:
          return _validatePassword(value, customErrorMessage, minLength);

        case ValidationType.confirmPassword:
          return _validateConfirmPassword(
              value, compareValue, customErrorMessage);

        case ValidationType.phoneNumber:
          return _validatePhoneNumber(
              value, customErrorMessage, minLength, maxLength);

        case ValidationType.name:
          return _validateName(value, customErrorMessage);

        case ValidationType.age:
          return _validateAge(value, customErrorMessage);

        case ValidationType.weight:
          return _validateWeight(value, customErrorMessage);

        case ValidationType.height:
          return _validateHeight(value, customErrorMessage);

        case ValidationType.coupon:
          return _validateCoupon(value, customErrorMessage);

        case ValidationType.verificationCode:
          return _validateVerificationCode(
              value, customErrorMessage, minLength);

        case ValidationType.custom:
          return customValidator?.call(value);
      }
    };
  }

  /// Validate required fields
  static String? _validateRequired(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'This field is required'.tr;
    }
    return null;
  }

  /// Validate email format
  static String? _validateEmail(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required'.tr;
    }

    if (!GetUtils.isEmail(value.trim())) {
      return customMessage ?? 'Invalid email'.tr;
    }

    return null;
  }

  /// Validate password
  static String? _validatePassword(
      String? value, String? customMessage, int? minLength) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required'.tr;
    }

    final minimumLength = minLength ?? 8;
    if (value.trim().length < minimumLength) {
      return customMessage ??
          'Password must be at least $minimumLength characters long'.tr;
    }

    return null;
  }

  /// Validate confirm password
  static String? _validateConfirmPassword(
      String? value, String? compareValue, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password'.tr;
    }

    if (compareValue != null && value.trim() != compareValue.trim()) {
      return customMessage ?? 'Passwords do not match'.tr;
    }

    return null;
  }

  /// Validate phone number
  static String? _validatePhoneNumber(
      String? value, String? customMessage, int? minLength, int? maxLength) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required'.tr;
    }

    final min = minLength ?? 8;
    final max = maxLength ?? 20;

    if (value.trim().length < min || value.trim().length > max) {
      return customMessage ??
          'Phone number must be between $min and $max characters'.tr;
    }

    if (!RegExp(r'^\+?[0-9]+$').hasMatch(value.trim())) {
      return customMessage ?? 'Please enter a valid phone number'.tr;
    }

    return null;
  }

  /// Validate name fields
  static String? _validateName(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'Name is required'.tr;
    }

    if (value.trim().length < 2) {
      return customMessage ?? 'Name must be at least 2 characters long'.tr;
    }

    return null;
  }

  /// Validate age
  static String? _validateAge(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required'.tr;
    }

    final age = int.tryParse(value.trim());
    if (age == null) {
      return customMessage ?? 'Please enter a valid age'.tr;
    }

    if (age < 1 || age > 120) {
      return customMessage ?? 'Please enter a valid age between 1 and 120'.tr;
    }

    return null;
  }

  /// Validate weight
  static String? _validateWeight(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'Weight is required'.tr;
    }

    final weight = double.tryParse(value.trim());
    if (weight == null) {
      return customMessage ?? 'Please enter a valid weight'.tr;
    }

    if (weight < 1 || weight > 1000) {
      return customMessage ??
          'Please enter a valid weight between 1 and 1000 kg'.tr;
    }

    return null;
  }

  /// Validate height
  static String? _validateHeight(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return 'Height is required'.tr;
    }

    final height = double.tryParse(value.trim());
    if (height == null) {
      return customMessage ?? 'Please enter a valid height'.tr;
    }

    if (height < 1 || height > 300) {
      return customMessage ??
          'Please enter a valid height between 1 and 300 cm'.tr;
    }

    return null;
  }

  /// Validate coupon code
  static String? _validateCoupon(String? value, String? customMessage) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'Coupon code is required'.tr;
    }

    if (value.trim().length < 3) {
      return customMessage ??
          'Coupon code must be at least 3 characters long'.tr;
    }

    return null;
  }

  /// Validate verification code
  static String? _validateVerificationCode(
      String? value, String? customMessage, int? minLength) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required'.tr;
    }

    final min = minLength ?? 4;
    if (value.trim().length < min) {
      return customMessage ??
          'Verification code must be at least $min characters long'.tr;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return customMessage ?? 'Verification code must contain only numbers'.tr;
    }

    return null;
  }

  /// Combined validation for multiple types
  static String? Function(String?) multiValidator({
    required List<ValidationType> types,
    String? compareValue,
    int? minLength,
    int? maxLength,
    String? customErrorMessage,
  }) {
    return (String? value) {
      for (ValidationType type in types) {
        final result = validator(
          type: type,
          compareValue: compareValue,
          minLength: minLength,
          maxLength: maxLength,
          customErrorMessage: customErrorMessage,
        )(value);

        if (result != null) return result;
      }
      return null;
    };
  }

  /// Quick validator helpers for common combinations
  static String? Function(String?) get requiredEmail =>
      validator(type: ValidationType.email);

  static String? Function(String?) get requiredPassword =>
      validator(type: ValidationType.password);

  static String? Function(String?) get requiredName =>
      validator(type: ValidationType.name);

  static String? Function(String?) get requiredPhone =>
      validator(type: ValidationType.phoneNumber);

  static String? Function(String?) requiredField([String? customMessage]) =>
      validator(
          type: ValidationType.required, customErrorMessage: customMessage);

  static String? Function(String?) confirmPassword(String compareValue,
          [String? customMessage]) =>
      validator(
        type: ValidationType.confirmPassword,
        compareValue: compareValue,
        customErrorMessage: customMessage,
      );
}

showGiftDialog({
  required BuildContext context,
  required void Function()? gift,
  required void Function()? subscribe,
}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
                Text(
                  "How do you like to subscribe?".tr,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Text(
              "Do you want to subscribe or you want to buy a gift for someone else?"
                  .tr,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                onPressed: subscribe,
                child: Text("Subscribe Now".tr),
                color: AppColors.primary,
                textColor: Colors.white,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                onPressed: gift,
                child: Text("Buy a gift 🎁".tr),
                color: AppColors.primary.withAlpha(125),
                textColor: Colors.white,
              )
            ],
          ));
}
