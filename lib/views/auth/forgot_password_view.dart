import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/custom_textfield.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _validateEmail() {
    if (!_emailController.text.trim().contains('@') ||
        !_emailController.text.trim().contains('.')) {
      Get.snackbar(
        'Invalid email address'.tr,
        'Please enter a valid email address'.tr,
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
        _emailFocusNode.unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Image.asset(
                AppImages.email,
                width: 40.w,
                height: 40.h,
              ),
              SizedBox(height: 24.h),
              Text(
                'Reset Pasword'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Please Enter your Email to send verification code'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                hintText: 'Email'.tr,
                controller: _emailController,
                focusNode: _emailFocusNode,
                onTap: () => setState(() {}),
              ),
              SizedBox(height: 16.h),
              GetBuilder<AuthController>(
                builder: (ctrl) => SizedBox(
                  height: 44.h,
                  width: 342.w,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_validateEmail()) return;

                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      final result = await ctrl.requestResetPassword(
                        _emailController.text.trim(),
                      );

                      if (result) {
                        Get.back();
                        Get.toNamed(
                          AppRoutes.resetPassword,
                          arguments: {
                            'email': _emailController.text.trim(),
                          },
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
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        'SEND'.tr,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
