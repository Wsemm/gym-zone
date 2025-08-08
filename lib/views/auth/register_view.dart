import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/app_images.dart';
import 'package:gym_zones/common/constants/functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/api.dart';
import '../../common/constants/constants.dart';
import '../../common/constants/countries.dart' show countries;
import '../../common/navigation/app_routes.dart';
import '../../common/styles/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'widgets/custom_textfield.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedCountryCode = countries[0]['code']!;
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;

  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;
  final _formKey = GlobalKey<FormState>();

  bool _validateFirstnameAndLastname() {
    if (_firstnameController.text.trim().isEmpty ||
        _lastnameController.text.trim().isEmpty) {
      Get.snackbar(
        'Invalid name'.tr,
        'Please enter your first and last names'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  Future<bool> _validateEmail() async {
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

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final result = await Get.find<AuthController>()
        .checkEmail(_phoneNumberController.text.trim());

    if (result) {
      Get.back();
      Get.snackbar(
        'Invalid phone number'.tr,
        'Phone number is already registered!'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    } else {
      Get.back();
      return true;
    }
  }

  bool _validatePhoneNumber() {
    if (_phoneNumberController.text.trim().length < 8 ||
        _phoneNumberController.text.trim().length > 20 ||
        !RegExp(r'^\+?[0-9]+$').hasMatch(_phoneNumberController.text.trim())) {
      Get.snackbar(
        'Invalid phone number'.tr,
        'Please enter a valid phone number'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  bool _validateGender() {
    if (_selectedGender == null) {
      Get.snackbar(
        'Invalid gender'.tr,
        'Please select your gender'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (_passwordController.text.trim().length < 8) {
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
        _passwordController.text.trim()) {
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
    AuthController authController = Get.find();
    return GestureDetector(
      onTap: () {
        _firstnameFocusNode.unfocus();
        _lastnameFocusNode.unfocus();
        _emailFocusNode.unfocus();
        _phoneNumberFocusNode.unfocus();
        _passwordFocusNode.unfocus();
        _confirmPasswordFocusNode.unfocus();
        _weightFocusNode.unfocus();
        _heightFocusNode.unfocus();
        _ageFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: appBarSystemStyle,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: Text("Create Account".tr),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    Get.isDarkMode
                        ? 'assets/images/splash-image-white.png'
                        : 'assets/images/splash-image-primary.png',
                    height: 100.h,
                    width: 100.w,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          validator: AppValidator.validator(
                            type: ValidationType.name,
                          ),
                          hintText: 'First name'.tr,
                          controller: _firstnameController,
                          focusNode: _firstnameFocusNode,
                          onTap: () => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomTextField(
                          validator: AppValidator.validator(
                            type: ValidationType.name,
                          ),
                          hintText: 'Last name'.tr,
                          controller: _lastnameController,
                          focusNode: _lastnameFocusNode,
                          onTap: () => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          isOnlyNumber: true,
                          keyboardType: TextInputType.number,
                          hintText: 'Weight in Kg'.tr,
                          controller: _weightController,
                          focusNode: _weightFocusNode,
                          onTap: () => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomTextField(
                          isOnlyNumber: true,
                          keyboardType: TextInputType.number,
                          hintText: 'Tall in Cm'.tr,
                          controller: _heightController,
                          focusNode: _heightFocusNode,
                          onTap: () => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          isOnlyNumber: true,
                          keyboardType: TextInputType.number,
                          hintText: 'Age'.tr,
                          controller: _ageController,
                          focusNode: _ageFocusNode,
                          onTap: () => setState(() {}),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DropdownButtonFormField(
                          validator: AppValidator.validator(
                            type: ValidationType.required,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'Gender'.tr,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'male',
                              child: Text(
                                'Male'.tr,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text(
                                'Female'.tr,
                              ),
                            )
                          ],
                          onChanged: (value) {
                            _selectedGender = value as String;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.3.sw),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: _selectedCountryCode,
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryCode = value!;
                            });
                          },
                          items: countries
                              .map<DropdownMenuItem<String>>((country) {
                            return DropdownMenuItem<String>(
                              value: country['code']!,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 0.14.sw),
                                child: FittedBox(
                                  child: Text(
                                    country['display']!.tr,
                                    style: TextStyle(
                                      color: country['code'] ==
                                              _selectedCountryCode
                                          ? AppColors.primary
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CustomTextField(
                          validator: AppValidator.validator(
                            type: ValidationType.phoneNumber,
                          ),
                          hintText: 'Phone number'.tr,
                          controller: _phoneNumberController,
                          focusNode: _phoneNumberFocusNode,
                          onTap: () => setState(() {}),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    validator: AppValidator.validator(
                      type: ValidationType.email,
                    ),
                    hintText: 'Email'.tr,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    onTap: () => setState(() {}),
                  ),
                  // SizedBox(height: 12.h),
                  // DropdownButtonFormField(
                  //   decoration: InputDecoration(
                  //     hintText: 'Gender'.tr,
                  //     prefixIcon: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Icon(
                  //         Icons.question_mark_rounded,
                  //         size: 20.sp,
                  //       ),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(20.r),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   items: [
                  //     DropdownMenuItem(
                  //       value: 'male',
                  //       child: Text(
                  //         'Male'.tr,
                  //       ),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: 'female',
                  //       child: Text(
                  //         'Female'.tr,
                  //       ),
                  //     )
                  //   ],
                  //   onChanged: (value) {
                  //     _selectedGender = value as String;
                  //   },
                  // ),
                  SizedBox(height: 12.h),
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
                  SizedBox(height: 12.h),
                  CustomTextField(
                    validator: AppValidator.validator(
                      type: ValidationType.confirmPassword,
                      compareValue: _passwordController.text.trim(),
                    ),
                    hintText: 'Confirm password'.tr,
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
                      width: 312.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          // if (!_validateFirstnameAndLastname()) return;
                          // if (!(await _validateEmail())) return;
                          // if (!_validatePhoneNumber()) return;
                          // if (!_validateGender()) return;
                          // if (!_validatePassword()) return;
                          // if (!_validateConfirmPassword()) return;

                          if (_formKey.currentState!.validate()) {
                            Get.dialog(
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                              barrierDismissible: false,
                            );
                            final result = await ctrl.register(
                                _firstnameController.text.trim(),
                                _lastnameController.text.trim(),
                                _emailController.text.trim(),
                                _selectedCountryCode,
                                _phoneNumberController.text.trim(),
                                _selectedGender!,
                                _passwordController.text.trim(),
                                _ageController.text.trim(),
                                _weightController.text.trim(),
                                _heightController.text.trim(),
                                "0");

                            if (result) {
                              Get.offAllNamed(AppRoutes.home);
                            } else {
                              Get.snackbar(
                                'Error'.tr,
                                'An error occurred while registering. Make sure email and phone number not registered before'
                                    .tr,
                                backgroundColor: Colors.red,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(4.sp),
                              );
                            }
                          }
                        },
                        child: FittedBox(child: Text('SIGN UP'.tr)),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 24.h,
                    children: [
                      Text("Or".tr),
                      GestureDetector(
                        onTap: () => authController.signInWithGoogle(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
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
                              Text("Sign Up with Google Account".tr),
                            ],
                          ),
                        ),
                      ),
                      if (Platform.isIOS)
                        GestureDetector(
                          onTap: () async {
                            await Get.find<AuthController>().signInWithApple();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
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
                                Text("Sign Up with Apple ID Account".tr),
                              ],
                            ),
                          ),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?'.tr),
                          SizedBox(width: 4.w),
                          TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            onPressed: () {
                              Get.toNamed(AppRoutes.login);
                            },
                            child: Text(
                              'Login'.tr,
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
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: Get.locale!.languageCode == 'ar'
                            ? 'tajwal'
                            : 'lato',
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'By signing up, you\'re accepting our'.tr,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: 'terms & conditions'.tr,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(
                                Uri.parse(
                                  '${Api.BASE_URL}/terms-and-conditions',
                                ),
                                mode: LaunchMode.inAppWebView,
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();

    _firstnameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _weightFocusNode.dispose();
    _heightFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }
}
