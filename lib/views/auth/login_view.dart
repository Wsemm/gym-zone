import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/functions.dart';
import 'package:gym_zones/common/services/fire_base_auth.dart';
import 'package:gym_zones/common/styles/app_colors.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/custom_bottom_nav_bar_controller.dart';
import 'widgets/custom_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _passwordObscureText = true;

  final FireBaseAuthService fireBaseAuthService = FireBaseAuthService();

  Future<void> signInWithGoogle() async {
    await Get.find<AuthController>().signInWithGoogle();
  }

  signInWithApple() async {
    final result = await Get.find<AuthController>().signInWithApple();
    // The signInWithApple method will handle navigation to update profile
    // No need to do anything here as it's handled in AuthController
  }

  void loginFunction() async {
    if (_emailController.text.trim().isEmpty) return;

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final result = await Get.find<AuthController>().login(
        _emailController.text.trim(), _passwordController.text.trim(), "0");

    if (result) {
      Get.find<CustomBottomNavBarController>().changePage(0);
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.back();
      Get.snackbar(
        'Error'.tr,
        'Invalid email or password'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
          automaticallyImplyLeading: true,
          title: Text("Login".tr),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Get.isDarkMode
                        ? 'assets/images/splash-image-white.png'
                        : 'assets/images/splash-image-primary.png',
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    validator: AppValidator.validator(
                      type: ValidationType.email,
                    ),
                    hintText: 'Email'.tr,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onTap: () => setState(() {}),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    validator: AppValidator.validator(
                      type: ValidationType.password,
                    ),
                    hintText: 'Password'.tr,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    onTap: () => setState(() {}),
                    obscureText: _passwordObscureText,
                    onSuffixTap: () {
                      setState(() {
                        _passwordObscureText = !_passwordObscureText;
                      });
                    },
                  ),
                  SizedBox(height: 4.h),
                  GetBuilder(
                    init: AuthController(),
                    builder: (ctrl) => Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgotPassword);
                        },
                        child: Text('Forgot password?'.tr),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 31.5.w,
                    ),
                    width: 343.w,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          loginFunction();
                        }
                      },
                      child: Text('LOG IN'.tr),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24.h,
                    children: [
                      Text("Or".tr),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          width: 270.w,
                          height: 42.h,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8.r)),
                          child: Row(
                            spacing: 10.w,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                AppImages.google,
                                height: 16.h,
                                width: 16.w,
                              ),
                              Text("Sign in with Google Account".tr),
                            ],
                          ),
                        ),
                      ),
                      if (Platform.isIOS)
                        GestureDetector(
                            onTap: () {
                              signInWithApple();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                              ),
                              width: 270.w,
                              height: 42.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.primary),
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Row(
                                spacing: 10.w,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppImages.apple,
                                    height: 16.h,
                                    width: 16.w,
                                  ),
                                  Text("Sign in with Apple ID Account".tr),
                                ],
                              ),
                            )),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'.tr),
                          SizedBox(width: 4.w),
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoutes.register);
                            },
                            child: Text(
                              'SIGN UP'.tr,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primary,
                                  color: AppColors.primary),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text('Don\'t have an account?'.tr),
        //     SizedBox(width: 4.w),
        //     TextButton(
        //       style: ButtonStyle(
        //         padding: MaterialStateProperty.all(EdgeInsets.zero),
        //       ),
        //       onPressed: () {
        //         Get.toNamed(AppRoutes.register);
        //       },
        //       child: Text('SIGN UP'.tr),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }
}
