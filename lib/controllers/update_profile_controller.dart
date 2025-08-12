import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../common/constants/api.dart';
import '../common/constants/countries.dart' show countries;
import '../models/user.dart';
import 'auth_controller.dart';

enum ResponseCode {
  success,
  updateImageNotAllowed,
  selectedImageIsNotValid,
  systemErorr,
}

class UpdateProfileController extends GetxController {
  late User _user;
  User get user => _user;

  File? _image;
  File? get image => _image;

  final _firstnameController = TextEditingController();
  TextEditingController get firstnameController => _firstnameController;

  final _lastnameController = TextEditingController();
  TextEditingController get lastnameController => _lastnameController;

  late String _selectedCountryCode;
  String get selectedCountryCode => _selectedCountryCode;

  final _phoneNumberController = TextEditingController();
  TextEditingController get phoneNumberController => _phoneNumberController;

  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  String? _socialEmail;
  String? get socialEmail => _socialEmail;

  final _weightController = TextEditingController();
  TextEditingController get weightController => _weightController;

  final _heightController = TextEditingController();
  TextEditingController get heightController => _heightController;

  final _ageController = TextEditingController();
  TextEditingController get ageController => _ageController;

  final _bioController = TextEditingController();
  TextEditingController get bioController => _bioController;

  late bool _showImageToOthers;
  bool get showImageToOthers => _showImageToOthers;

  bool isGoogle = false;
  bool isApple = false;

  final formKey = GlobalKey<FormState>();

  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments["email"] != null) {
      _user = User.fake();
      _selectedCountryCode = countries[0]['code']!;
      _showImageToOthers = false;
      _socialEmail = Get.arguments["email"];
      _emailController.text = _socialEmail ?? '';

      // Check if it's Apple Sign-In
      if (Get.arguments["isApple"] == true) {
        isApple = true;
        // Pre-fill Apple data if available
        if (Get.arguments["firstName"] != null) {
          _firstnameController.text = Get.arguments["firstName"];
        }
        if (Get.arguments["lastName"] != null) {
          _lastnameController.text = Get.arguments["lastName"];
        }
      } else {
        isGoogle = true;
        // Pre-fill Google data if available
        if (Get.arguments["firstName"] != null) {
          _firstnameController.text = Get.arguments["firstName"];
        }
        if (Get.arguments["lastName"] != null) {
          _lastnameController.text = Get.arguments["lastName"];
        }
      }
    } else {
      _user = User.fromJson(GetStorage().read('user'));
      _firstnameController.text = _user.firstname;
      _lastnameController.text = _user.lastname;
      _phoneNumberController.text = _user.phoneNumber;
      _selectedCountryCode = _user.countryCode;
      _emailController.text = _user.email;
      _weightController.text = _user.weight ?? "";
      _heightController.text = _user.height ?? "";
      _ageController.text = _user.age ?? "";
      if (_user.bio != null) {
        _bioController.text = _user.bio!;
      }
      _showImageToOthers = _user.showImageToOthers;
    }
  }

  Future<void> pickImage() async {
    final XFile? result =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result != null) {
      _image = File(result.path);
      update();
    } else {
      // User canceled the picker
    }
  }

  void setShowImageToOtherUsers(bool value) {
    _showImageToOthers = value;
    update();
  }

  void setCountyCode(String value) {
    _selectedCountryCode = value;
    update();
  }

  void setGender(String value) {
    _selectedGender = value;
    update();
  }

  Future<ResponseCode> updateProfile() async {
    if (isGoogle || isApple) {
      if (formKey.currentState!.validate() && _selectedGender != null) {
        try {
          print("Starting registration process...");
          AuthController authController = Get.put(AuthController());
          final emailToUse = _socialEmail ?? _emailController.text.trim();
          print("Registering with email: $emailToUse");

          var result = await authController.register(
              _firstnameController.text.trim(),
              _lastnameController.text.trim(),
              emailToUse,
              _selectedCountryCode.trim(),
              _phoneNumberController.text.trim(),
              _selectedGender!,
              "hanyhany",
              _heightController.text.isNotEmpty
                  ? _heightController.text.trim()
                  : null,
              _ageController.text.isNotEmpty
                  ? _ageController.text.trim()
                  : null,
              _weightController.text.isNotEmpty
                  ? _weightController.text.trim()
                  : null,
              "1");
          print("Registration result: $result");
          if (result) {
            print("Registration successful, navigating to home...");
            Get.offAllNamed(AppRoutes.home);
            return ResponseCode.success;
          } else {
            return ResponseCode.systemErorr;
          }
        } catch (e) {
          print("Error in updateProfile: $e");
          return ResponseCode.systemErorr;
        }
      } else {
        if (_selectedGender == null) {
          Get.snackbar(
            'Error'.tr,
            'Please select your gender'.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
        return ResponseCode.systemErorr;
      }
    } else {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Api.API_URL}users/${_user.id}'))
        ..fields['firstname'] = _firstnameController.text.trim()
        ..fields['lastname'] = _lastnameController.text.trim()
        ..fields['phone'] = _phoneNumberController.text.trim()
        ..fields['country_code'] = _selectedCountryCode
        ..fields['show_image_to_others'] = showImageToOthers ? '1' : '0'
        // ..fields['email'] = _emailController.text.trim()
        ..fields['weight'] = _weightController.text.trim()
        ..fields['height'] = _heightController.text.trim()
        ..fields['age'] = _ageController.text.trim();

      if (_bioController.text.trim().isNotEmpty) {
        request.fields['bio'] = _bioController.text.trim();
      }

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      });

      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      var response = await request.send();

      if (response.statusCode == 422) {
        final errorCode =
            jsonDecode(await response.stream.bytesToString())['errorCode'];
        switch (errorCode) {
          case 1:
            return ResponseCode.updateImageNotAllowed;
          default:
            return ResponseCode.selectedImageIsNotValid;
        }
      } else if (response.statusCode == 500) {
        return ResponseCode.systemErorr;
      }
      var responseBody = await response.stream.bytesToString();
      log(responseBody.toString());
      _user = User.fromJson(jsonDecode(responseBody));
      await GetStorage().write('user', _user.toJson());
      update();

      return ResponseCode.success;
    }

    return ResponseCode.systemErorr;
  }

  // Alternative method to send data as JSON (without file upload)
}
