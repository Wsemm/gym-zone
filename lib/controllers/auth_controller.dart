import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/common/services/fire_base_auth.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../common/constants/api.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async => this;

  String? _token = GetStorage().read('token');
  String? get token => _token;
  bool? isEmailRegisteredApple;
  final FireBaseAuthService fireBaseAuthService = FireBaseAuthService();

  void removeTokenAndUser() {
    _token = null;
    GetStorage().remove('token');
    GetStorage().remove('user');
  }

  Future<bool> checkEmail(String email) async {
    final response = await http.get(
      Uri.parse('${Api.API_URL}auth/check-email?email=$email'),
      headers: {
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 204;
  }

  Future<bool?> isEmailExist(String email) async {
    final response = await http.get(
      Uri.parse('${Api.isEmailRegistered}?email=$email'),
      headers: {
        'Accept': 'application/json',
      },
    );
    var responseBody = jsonDecode(response.body);
    if (responseBody["message"] == "Email address is already registered" &&
        responseBody["is_google"] == 1) {
      return true;
    } else if (responseBody["message"] == "Email address is not registered") {
      return false;
    }
    if (responseBody["message"] == "Email address is already registered" &&
        responseBody["is_google"] == 0) {
      return null;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In process...');
       await GoogleSignIn().signOut();
      print('Signed out from previous sessions');
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      
      print('GoogleSignIn instance created with scopes: ${googleSignIn.scopes}');

      print('Attempting to sign in...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      print('Sign-in attempt completed');

      if (googleUser == null) {
        print('Google Sign-In was cancelled by user');
        Get.snackbar(
          'Cancellation'.tr,
          'Google sign-in was canceled'.tr,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        print('Google auth tokens obtained successfully');

        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        var isEmailRegistered = await isEmailExist(googleUser.email);
        if (isEmailRegistered == null) {
          Get.back();

          Get.snackbar(
            'Error Account Already Exists'.tr,
            'Please Sign In using email and password'.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }

        print('Firebase credential created, signing in...');

        final userCredential = await firebase_auth.FirebaseAuth.instance
            .signInWithCredential(credential);

        Get.back();

        print('Firebase sign-in successful: ${userCredential.user?.email}');

        if (userCredential.user != null) {
          final userEmail = userCredential.user!.email;
          String? firstName;
          String? lastName;
          final gName = googleUser.displayName;
          if (gName != null && gName.trim().isNotEmpty) {
            final parts = gName.trim().split(' ');
            if (parts.isNotEmpty) {
              firstName = parts.first;
              if (parts.length > 1) {
                lastName = parts.sublist(1).join(' ');
              }
            }
          } else {
            final displayName = userCredential.user!.displayName;
            if (displayName != null && displayName.trim().isNotEmpty) {
              final parts = displayName.trim().split(' ');
              if (parts.isNotEmpty) {
                firstName = parts.first;
                if (parts.length > 1) {
                  lastName = parts.sublist(1).join(' ');
                }
              }
            }
          }
          if (userEmail != null) {
            if (isEmailRegistered == true) {
              var result = await login(userEmail, "hanyhany", "1");
              if (result) {
                Get.find<CustomBottomNavBarController>().changePage(0);
                Get.offAllNamed(AppRoutes.home);
              }
            } else if (isEmailRegistered == false) {
              Get.offAllNamed(
                AppRoutes.updateProfile,
                arguments: {
                  "email": userEmail,
                  "firstName": firstName ?? '',
                  "lastName": lastName ?? '',
                  "isApple": false,
                },
              );
            }
          }
          return true;
        }
        return false;
      } catch (firebaseError) {
        Get.back();
        print('Firebase Auth Error: $firebaseError');
        Get.snackbar(
          'Error'.tr,
          'Failed to sign in with Google. Please try again.'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      Get.snackbar(
        'Firebase Error'.tr,
        'Firebase authentication failed: ${e.message}'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      print('Unexpected error in Google Sign-In: $e');
      Get.snackbar(
        'Unexpected Error'.tr,
        'An unexpected error occurred. Please try again.'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> _loginWithBackend(String email, String googleToken) async {
    try {
      final response = await http.post(
        Uri.parse('${Api.API_URL}auth/google-login'),
        body: jsonEncode({
          'email': email,
          'google_token': googleToken,
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final user = User.fromJson(responseBody['user']);
        _token = responseBody['token'];

        await GetStorage().write('user', user.toJson());
        await GetStorage().write('token', _token);

        return true;
      }
      return false;
    } catch (e) {
      print('Backend login error: $e');
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final result = await fireBaseAuthService.signInWithApple();

      Get.back();

      if (result != null) {
        final email = result['email'] as String?;
        final firstName = result['firstName'] as String?;
        final lastName = result['lastName'] as String?;

        if (email != null && email.isNotEmpty) {
          if (isEmailRegisteredApple == true) {
            var result = await login(email, "hanyhany", "1");
            if (result) {
              Get.find<CustomBottomNavBarController>().changePage(0);
              Get.offAllNamed(AppRoutes.home);
            }
          } else if (isEmailRegisteredApple == false) {
            Get.offAllNamed(AppRoutes.updateProfile, arguments: {
              "email": email,
              "firstName": firstName ?? '',
              "lastName": lastName ?? '',
              "isApple": true,
            });
          }
          return true;
        }
      }

      Get.snackbar(
        'Error'.tr,
        'Apple Sign-In was cancelled or failed. Please try again.'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      print('Apple Sign-In Error: $e');

      String errorMessage = 'Apple Sign-In was cancelled or failed.';
      if (e.toString().contains('AuthorizationErrorCode.unknown')) {
        errorMessage = 'Apple Sign-In was cancelled or configuration issue.';
      } else if (e.toString().contains('AuthorizationErrorCode.canceled')) {
        errorMessage = 'Apple Sign-In was cancelled.';
      } else if (e.toString().contains('AuthorizationErrorCode.failed')) {
        errorMessage = 'Apple Sign-In failed. Please try again.';
      }

      Get.snackbar(
        'Error'.tr,
        errorMessage.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> register(
    String firstname,
    String lastname,
    String email,
    String countryCode,
    String phone,
    String gender,
    String password,
    String? height,
    String? age,
    String? weight,
    String isGoogle,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Api.API_URL}auth/register'),
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'country_code': countryCode,
          'phone': phone,
          'gender': gender,
          'password': password,
          'height': height,
          'age': age,
          'weight': weight,
          'is_google': isGoogle
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      log("register response body${response.body}");

      if (response.statusCode == 201) {
        final responseBodyDecoded = jsonDecode(response.body);
        final user = User.fromJson(responseBodyDecoded['user']);
        await GetStorage().write('user', user.toJson());

        _token = responseBodyDecoded['token'];
        await GetStorage().write('token', _token);

        await _addDeviceToken(user.id);
        return true;
      } else {
        print('Registration failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    final response = await http.post(
      Uri.parse('${Api.API_URL}auth/verify-email'),
      body: {
        'email': email,
        'code': code,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final responseBodyDecoded = jsonDecode(response.body);

      final user = User.fromJson(responseBodyDecoded['user']);
      await GetStorage().write('user', user.toJson());

      return true;
    } else {
      return false;
    }
  }

  Future<bool> resendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse('${Api.API_URL}auth/resend-verification-code'),
      body: {
        'email': email,
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    return response.statusCode == 204;
  }

  Future<bool> login(String email, String password, String isGoogle) async {
    try {
      final response = await http.post(
        Uri.parse('${Api.API_URL}auth/login'),
        body: {
          'email': email,
          'password': password,
          'is_google': isGoogle,
        },
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      log("==============" + response.body.toString());

      if (response.statusCode == 200) {
        final responseBodyDecoded = jsonDecode(response.body);

        final user = User.fromJson(responseBodyDecoded['user']);
        GetStorage().write('user', user.toJson());

        _token = responseBodyDecoded['token'];
        await GetStorage().write('token', _token);

        await _addDeviceToken(user.id);
        return true;
      } else {
        print('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(
    String email,
    String verificationCode,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('${Api.API_URL}auth/reset-password'),
      body: {
        'email': email,
        'code': verificationCode,
        'password': password,
      },
      headers: {
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 204;
  }

  Future<void> _addDeviceToken(String userId) async {
    try {
      late String deviceId;
      late String deviceName;

      final deviceInfo = DeviceInfoPlugin();

      if (GetPlatform.isAndroid) {
        final androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.id;
        deviceName = androidDeviceInfo.model;
      } else if (GetPlatform.isIOS) {
        final iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor!;
        deviceName = iosDeviceInfo.name;
      } else {
        deviceId = 'Unknown';
        deviceName = 'Unknown';
      }

      FirebaseMessaging.instance.requestPermission();
      final token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        await http.post(
          Uri.parse('${Api.API_URL}fcm-tokens'),
          body: {
            'user_id': userId,
            'device_id': deviceId,
            'device_name': deviceName,
            'token': token,
          },
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $_token',
          },
        ).timeout(Duration(seconds: 10));
        print('Device token added successfully');
      }
    } catch (e) {
      print('Warning: Could not add device token: $e');
    }
  }

  Future<bool> logout() async {
    try {
      final user = User.fromJson(GetStorage().read('user'));

      final response = await http.post(
        Uri.parse('${Api.API_URL}auth/logout'),
        body: {
          'user_id': user.id,
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode != 204) {
        return false;
      }

      removeTokenAndUser();

      GetStorage().remove('gender');

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> requestResetPassword(String email) async {
    final response = await http.post(
      Uri.parse('${Api.API_URL}auth/request-reset-password-code'),
      body: {
        'email': email,
      },
      headers: {
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 204;
  }

  Future<bool> deleteAccount() async {
    final response = await http.delete(
      Uri.parse('${Api.API_URL}users'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 204) {
      removeTokenAndUser();
    }

    return response.statusCode == 204;
  }
}
