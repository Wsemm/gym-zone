import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user.dart';
import 'widgets/custom_textfield.dart';

class VerifyEmailView extends StatefulWidget {
  VerifyEmailView({super.key});

  final User user = User.fromJson(GetStorage().read('user'));

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final FocusNode _verificationFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _verificationFocusNode.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/verify-email.png',
                  width: 128.w,
                  height: 128.h,
                ),
                Text(
                  'Verify your email'.tr,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '${'Please enter the verification code sent to'.tr} ${widget.user.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  hintText: 'Verification code'.tr,
                  controller: _verificationCodeController,
                  focusNode: _verificationFocusNode,
                  onTap: () => setState(() {}),
                ),
                SizedBox(height: 16.h),
                GetBuilder<AuthController>(
                  builder: (ctrl) => SizedBox(
                    height: 44.h,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_verificationCodeController.text.isEmpty) return;

                        Get.dialog(
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        final result = await ctrl.verifyEmail(
                          widget.user.email,
                          _verificationCodeController.text.trim(),
                        );

                        if (result) {
                          Get.offAllNamed(AppRoutes.home);
                        } else {
                          Get.back();
                          Get.snackbar(
                            'Invalid verification code'.tr,
                            'Please enter the verification code sent to your email'
                                .tr,
                            backgroundColor: Colors.red,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.all(4.sp),
                          );
                        }
                      },
                      child: FittedBox(child: Text('VERIFY'.tr)),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 44.h,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {
                      Get.find<AuthController>().removeTokenAndUser();
                      Get.offAllNamed(AppRoutes.home);
                    },
                    child: FittedBox(child: Text('Logout'.tr)),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Didn\'t receive or expired code?'.tr),
            GetBuilder<AuthController>(builder: (ctrl) {
              return TextButton(
                onPressed: () async {
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  final result =
                      await ctrl.resendVerificationCode(widget.user.email);

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
                      'Something went wrong. Please try later, or contact us.'
                          .tr,
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.TOP,
                      margin: EdgeInsets.all(4.sp),
                    );
                  }
                },
                child: Text('Resend code'.tr),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _verificationFocusNode.dispose();
    super.dispose();
  }
}
