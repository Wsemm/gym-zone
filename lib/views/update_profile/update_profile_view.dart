import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/constants/functions.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/views/update_profile/widgets/custom_form_field_profile.dart';

import '../../common/constants/api.dart';
import '../../common/constants/constants.dart';
import '../../common/constants/countries.dart' show countries;
import '../../common/styles/app_colors.dart';
import '../../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  UpdateProfileView({super.key});

  final _phoneNumberFocusNode = FocusNode();

  bool _validateFirstnameAndLastname() {
    if (controller.firstnameController.text.trim().isEmpty ||
        controller.lastnameController.text.trim().isEmpty) {
      Get.snackbar(
        'Invalid name'.tr,
        'Please enter a valid name'.tr,
        backgroundColor: Colors.grey,
        snackPosition: SnackPosition.TOP,
        margin: EdgeInsets.all(4.sp),
      );
      return false;
    }
    return true;
  }

  bool _validatePhoneNumber() {
    if (controller.phoneNumberController.text.trim().length < 8 ||
        controller.phoneNumberController.text.trim().length > 20 ||
        !RegExp(r'^\+?[0-9]+$')
            .hasMatch(controller.phoneNumberController.text.trim())) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          (controller.isGoogle || controller.isApple)
              ? 'Create Account'.tr
              : 'Update profile'.tr,
          style: const TextStyle(
            color: AppColors.primary,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (!controller.isGoogle && !controller.isApple)
                  Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          'NOTE: Make sure to choose a picture that reflects how you look like, as you can only change your profile picture once every 30 days. If you have a related issue, please contact us.'
                              .tr,
                          style: TextStyle(
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 140.h,
                          width: 140.h,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              GetBuilder<UpdateProfileController>(
                                builder: (_) {
                                  if (controller.image != null) {
                                    return CircleAvatar(
                                      radius: 140.r,
                                      backgroundImage:
                                          FileImage(controller.image!),
                                    );
                                  }

                                  if (controller.user.imagePath != null) {
                                    return CircleAvatar(
                                      radius: 140.r,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        '${Api.IMAGE_PREFIX}${controller.user.imagePath}',
                                      ),
                                    );
                                  }

                                  return CircleAvatar(
                                    radius: 140.r,
                                    backgroundImage: AssetImage(
                                      controller.user.gender == 'male'
                                          ? 'assets/images/male-placeholder.png'
                                          : 'assets/images/female-placeholder.png',
                                    ),
                                  );
                                },
                              ),
                              if (controller.user.canUpdateImage)
                                Positioned(
                                  right: 2.w,
                                  bottom: 2.h,
                                  child: SizedBox(
                                    height: 32.h,
                                    width: 32.h,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                          EdgeInsets.zero,
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color(0xFFF5F6F9),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(65.r),
                                          ),
                                        ),
                                      ),
                                      onPressed: controller.pickImage,
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GetBuilder<UpdateProfileController>(
                              builder: (_) {
                                return Transform.scale(
                                  scale: 0.8.h,
                                  child: Checkbox(
                                    value: controller.showImageToOthers,
                                    onChanged: (value) {
                                      controller
                                          .setShowImageToOtherUsers(value!);
                                    },
                                  ),
                                );
                              },
                            ),
                            Text(
                              'Show my profile image to other users'.tr,
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Row(
                  spacing: 12.w,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 5.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "First name".tr,
                              ),
                              if (controller.isGoogle || controller.isApple)
                                Text(
                                  "  *".tr,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                            ],
                          ),
                          CustomTextFormFieldProfile(
                              validator: AppValidator.validator(
                                type: ValidationType.name,
                              ),
                              controller: controller.firstnameController,
                              hintText: "Ahmad".tr),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        spacing: 5.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Last name".tr),
                              if (controller.isGoogle || controller.isApple)
                                Text(
                                  "  *".tr,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                            ],
                          ),
                          CustomTextFormFieldProfile(
                              validator: AppValidator.validator(
                                type: ValidationType.name,
                              ),
                              controller: controller.lastnameController,
                              hintText: "Mohamad".tr),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 16.h),
                // Text("Email".tr),
                // SizedBox(height: 6.h),
                // CustomTextFormFieldProfile(
                //   controller: controller.emailController,
                //   hintText: "example@email.com".tr,
                //   readOnly: true,
                //   fillColor: Colors.grey.shade100,
                //   textColor: Colors.grey.shade600,
                // ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Text("Phone number".tr),
                    if (controller.isGoogle || controller.isApple)
                      Text(
                        "  *".tr,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 48.h,
                  child: TextFormField(
                    validator: (controller.isGoogle || controller.isApple)
                        ? AppValidator.validator(
                            type: ValidationType.phoneNumber,
                          )
                        : null,
                    enableInteractiveSelection: false,
                    controller: controller.phoneNumberController,
                    focusNode: _phoneNumberFocusNode,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      hintText: "Enter phone number".tr,
                      hintStyle: TextStyle(fontSize: 14.sp),
                      prefixIcon: Container(
                        width: 0.25.sw,
                        padding: EdgeInsets.only(
                            left: 8.w, right: 4.w, top: 2.h, bottom: 2.h),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          iconSize: 16.sp,
                          value: controller.selectedCountryCode,
                          onChanged: (value) {
                            controller.setCountyCode(value!);
                            _phoneNumberFocusNode.requestFocus();
                          },
                          items: countries
                              .map<DropdownMenuItem<String>>((country) {
                            return DropdownMenuItem<String>(
                              value: country['code']!.tr,
                              child: FittedBox(
                                child: GetBuilder<UpdateProfileController>(
                                    builder: (_) {
                                  return Text(
                                    country['display']!.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: country['code'] ==
                                              controller.selectedCountryCode
                                          ? AppColors.primary
                                          : Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .color,
                                    ),
                                  );
                                }),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                if (controller.isGoogle || controller.isApple) ...[
                  SizedBox(height: 16.h),
                  TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      labelText: "Email".tr,
                      hintText: controller.socialEmail,
                    ),
                  )
                ],
                // SizedBox(height: 16.h),
                // Text("Email".tr),
                // CustomTextFormFieldProfile(
                //     validator: AppValidator.validator(
                //       type: ValidationType.email,
                //     ),
                //     controller: controller.emailController,
                //     hintText: "Email".tr),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller.bioController,
                  minLines: 2,
                  maxLines: 2,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    prefixIcon: Icon(
                      Icons.app_registration_rounded,
                      size: 18.sp,
                    ),
                    labelText: 'Bio'.tr,
                  ),
                ),
                SizedBox(height: 16.h),
                if (controller.isGoogle || controller.isApple)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Gender".tr),
                          if (controller.isGoogle || controller.isApple)
                            Text(
                              "  *".tr,
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            )
                        ],
                      ),
                      SizedBox(height: 8.h),
                      GetBuilder<UpdateProfileController>(
                        builder: (_) => DropdownButtonFormField<String>(
                          validator: AppValidator.validator(
                            type: ValidationType.required,
                          ),
                          value: controller.selectedGender,
                          decoration: InputDecoration(
                            hintText: 'Gender'.tr,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8.r),
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
                            if (value != null) {
                              controller.setGender(value);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                Text(
                  "Health information".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                Column(
                  spacing: 12.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Weight".tr),
                    CustomTextFormFieldProfile(
                        controller: controller.weightController,
                        hintText: "Weight".tr),
                    SizedBox(height: 4.h),
                    Text("Height".tr),
                    CustomTextFormFieldProfile(
                        controller: controller.heightController,
                        hintText: "Height".tr),
                    SizedBox(height: 4.h),
                    Text("Age".tr),
                    CustomTextFormFieldProfile(
                        controller: controller.ageController,
                        hintText: "Age".tr),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8.sp),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            if (controller.formKey.currentState!.validate()) {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );

              var result = await controller.updateProfile();

              if (Get.isDialogOpen == true) {
                Get.back();
              }

              if (result == ResponseCode.success) {
                if (!(controller.isGoogle || controller.isApple)) {
                  Get.back();
                  Get.back();
                }
                Get.snackbar(
                  'Success'.tr,
                  (controller.isGoogle || controller.isApple)
                      ? 'Account created successfully'.tr
                      : 'Profile updated successfully'.tr,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: EdgeInsets.all(4.sp),
                );
              } else if (result == ResponseCode.updateImageNotAllowed) {
                Get.snackbar(
                  'Error'.tr,
                  'You can only change your profile picture once every 30 days'
                      .tr,
                  backgroundColor: Colors.grey,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: EdgeInsets.all(4.sp),
                );
              } else if (result == ResponseCode.selectedImageIsNotValid) {
                Get.snackbar(
                  'Error'.tr,
                  'Image size or format is not valid'.tr,
                  backgroundColor: Colors.grey,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: EdgeInsets.all(4.sp),
                );
              } else {
                Get.snackbar(
                  'Error'.tr,
                  'Something went wrong. Please try later, or contact us.'.tr,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: EdgeInsets.all(4.sp),
                );
              }
            }
          },
          child: Text(
            (controller.isGoogle || controller.isApple)
                ? 'Create Account'.tr
                : 'Update'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
