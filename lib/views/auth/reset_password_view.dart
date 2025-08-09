import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/views/auth/widgets/custom_otp_text_field.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/custom_textfield.dart';

class ResetPasswordView extends StatefulWidget {
  final String email = Get.arguments['email'];

  ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _verificationCodeFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  bool _validateVerificationCode() {
    if (_verificationCodeController.text.trim().isEmpty) {
      Get.snackbar(
        'Invalid verification code'.tr,
        'Please enter the verification code sent to your email'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (_newPasswordController.text.trim().length < 8) {
      Get.snackbar(
        'Invalid password'.tr,
        'Password must be at least 8 characters long'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword() {
    if (_confirmPasswordController.text.trim() !=
        _newPasswordController.text.trim()) {
      Get.snackbar(
        'Invalid password'.tr,
        'Passwords do not match'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _verificationCodeFocusNode.unfocus();
        _newPasswordFocusNode.unfocus();
        _confirmPasswordFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Image.asset(
                  AppImages.shield,
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(height: 24.h),
                Text(
                  '${'Verification code was sent to'.tr} ${widget.email}',
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                CustomOtpTextField(
                  onSubmit: (code) {
                    _verificationCodeController.text = code;
                  },
                ),
                SizedBox(height: 24.h),

                // CustomTextField(
                //   hintText: 'Verification code'.tr,
                //   controller: _verificationCodeController,
                //   focusNode: _verificationCodeFocusNode,
                //   onTap: () => setState(() {}),
                // ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: 'New password'.tr,
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocusNode,
                  onTap: () => setState(() {}),
                  obscureText: _passwordObscureText,
                  onSuffixTap: () {
                    setState(() {
                      _passwordObscureText = !_passwordObscureText;
                    });
                  },
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  hintText: 'Confirm new password'.tr,
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  onTap: () => setState(() {}),
                  obscureText: _confirmPasswordObscureText,
                  onSuffixTap: () {
                    setState(() {
                      _confirmPasswordObscureText =
                          !_confirmPasswordObscureText;
                    });
                  },
                ),
                SizedBox(height: 16.h),
                GetBuilder<AuthController>(
                  builder: (ctrl) => SizedBox(
                    height: 44.h,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_validateVerificationCode()) return;
                        if (!_validatePassword()) return;
                        if (!_validateConfirmPassword()) return;

                        Get.dialog(
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        final result = await ctrl.resetPassword(
                          widget.email,
                          _verificationCodeController.text.trim(),
                          _newPasswordController.text.trim(),
                        );

                        if (result) {
                          Get.offAllNamed(AppRoutes.login);
                          Get.snackbar(
                            'Success'.tr,
                            'Password reset successfully'.tr,
                            backgroundColor: Colors.green,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(4.sp),
                          );
                        } else {
                          Get.back();
                          Get.snackbar(
                            'Error'.tr,
                            'An error occurred while resetting password'.tr,
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(4.sp),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          'Reset Password'.tr,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                GetBuilder<AuthController>(
                  builder: (ctrl) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 44.h,
                        // width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final result = await ctrl.requestResetPassword(
                              widget.email,
                            );

                            if (result) {
                              Get.back();
                              Get.snackbar(
                                'Success'.tr,
                                'Verification code re-sent successfully'.tr,
                                backgroundColor: Colors.green,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(4.sp),
                              );
                            } else {
                              Get.back();
                              Get.snackbar(
                                'Error'.tr,
                                'An error occurred while sending OTP'.tr,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(4.sp),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Didn\'t receive the code?'.tr,
                                    style: TextStyle(
                                        color: Color.fromRGBO(128, 126, 126, 1),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                  text: ' '.tr,
                                ),
                                TextSpan(
                                  text: 'click here to resend it'.tr,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    _verificationCodeFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }
}
