import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/navigation/app_routes.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../common/constants/api.dart';
import '../common/styles/app_colors.dart';
import '../models/subscription_plan.dart';
import '../models/user.dart';
import 'auth_controller.dart';

enum SubscriptionStatus {
  alreadySubscribed,
  subscriptionFailed,
  paymentCancelled,
  paymentFailed,
  success
}

class SubscriptionsController extends GetxController {
  User? _user;

  User? get user => _user;

  List<SubscriptionPlan>? _plans;

  List<SubscriptionPlan>? get plans => _plans;

  RxDouble totalAmount = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble totalAmountAfterDiscount = 0.0.obs;
  TextEditingController couponController = TextEditingController();
  RxBool isLoading = false.obs;
  bool isLoadingGroupGyms = false;
  final GlobalKey<FormState> couponKey = GlobalKey<FormState>();

  // Pagination variables for group gyms
  ScrollController scrollController = ScrollController();
  late String pageKey;
  late bool isLoadingMoreData;
  late bool? isMoreGroupGymsData;

  void resetGroupGymsPagination() {
    pageKey = "2";
    isLoadingMoreData = false;
    isMoreGroupGymsData = true;
    update();
  }

  @override
  void onInit() {
    final userInStorage = GetStorage().read('user');
    if (userInStorage != null) {
      _user = User.fromJson(userInStorage);
    }

    // Initialize pagination
    pageKey = "2";
    isLoadingMoreData = false;
    isMoreGroupGymsData = true;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Load more data when scroll reaches the bottom
        loadMoreData();
      }
    });

    _fetchPlans();
    super.onInit();
  }

  // @override
  // void onClose() {
  //   scrollController.dispose();
  //   super.onClose();
  // }

  void loadMoreData() async {
    final homeController = Get.find<HomeController>();
    if (isMoreGroupGymsData == true) {
      isLoadingMoreData = true;
      update();

      // Store current gym count to check if new data was added
      final currentGymsCount = homeController.gymsToDisplay?.length ?? 0;

      await homeController.fetchNearestGyms(pageKey: pageKey, doLoading: false);

      // Check if new data was added
      final newGymsCount = homeController.gymsToDisplay?.length ?? 0;
      if (newGymsCount == currentGymsCount) {
        // No new data added, means no more data available
        isMoreGroupGymsData = false;
      }

      pageKey = (int.parse(pageKey) + 1).toString();
    } else {
      log("#log No More Data for group gyms");
    }
    isLoadingMoreData = false;
    update();
  }

  Future<void> _fetchPlans() async {
    isLoadingGroupGyms = true;
    update();
    final response = await http.get(Uri.parse(
        '${Api.API_URL}subscription-plans?gender=${_user != null ? user?.gender : GetStorage().read('gender')}'));
    if (response.statusCode == 200) {
      final plansJson = jsonDecode(response.body) as List;
      _plans =
          plansJson.map((plan) => SubscriptionPlan.fromJson(plan)).toList();
    } else {
      _plans = [];
    }
    isLoadingGroupGyms = false;
    update();
  }

  Future<SubscriptionStatus> subscribe(
      {required bool isIndividual, required int planId, String? gymId}) async {
    final Completer<SubscriptionStatus> completer =
        Completer<SubscriptionStatus>();

    double totalAmountLast = totalAmountAfterDiscount.value == 0.0
        ? totalAmount.value
        : totalAmountAfterDiscount.value;

    var response;

    // --------------------------
    // my test subscribe

    //    final response = await http.post(
    //   Uri.parse('${Api.API_URLV2}subscribe'),
    //   body: {
    //     'user_id': _user!.id,
    //     'subscription_plan_id': planId.toString(),
    //     // 'total_amount': totalAmountLast.toString(),
    //     "subscription_type": "group",
    //     "gym_id": "03857ec3-8a3c-4f01-968a-9806832f04e2"
    //   },
    //   headers: {
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer ${Get.find<AuthController>().token}',
    //   },
    // );

    // subscribe individual api
    if (isIndividual) {
      print("indivdual gym gymId : $gymId");
      print("indivdual gym planId : $planId");
      response = await http.post(
        Uri.parse('${Api.API_URL}subscribe-individual'),
        body: {
          'user_id': _user!.id,
          'subscription_plan_id': planId.toString(),
          // 'total_amount': totalAmountLast.toString(),
          // "subscription_type": "individual",
          "gym_id": gymId
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}',
        },
      );
    } else {
      response = await http.post(
        Uri.parse('${Api.API_URL}subscribe'),
        body: {
          'user_id': _user!.id,
          'subscription_plan_id': planId.toString(),
          'total_amount': totalAmountLast.toString(),
          // 'gym_id': "0613c0b1-2183-4ef8-92f0-c6cfcc268ca1",
          'gym_id': Get.find<HomeController>().gymsToDisplay!.first.id,
        },
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}',
        },
      );
    }

    log("# response ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String paymentUrl = data['payment_url'];

      // Initialize WebViewController
      final webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              log("# onNavigationRequest request : ${request.url}");
              if (Platform.isAndroid) {
                return request.isMainFrame
                    ? NavigationDecision.navigate
                    : NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
            onPageFinished: (url) async {
              log("# on page finished url : $url");
              if (url == paymentUrl || url.contains("payment-status")) {
                return;
              } else if (url.contains('successful-payment')) {
                completer.complete(SubscriptionStatus.success);
                Get.back();
                return;
              } else if (url.contains('cancel')) {
                completer.complete(SubscriptionStatus.paymentCancelled);
                Get.back();
                return;
              } else if (!url.startsWith(paymentUrl)) {
                // Handle unexpected URLs
                completer.complete(SubscriptionStatus.paymentFailed);
                Get.back();
                return;
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(paymentUrl));

      // Open the payment gateway URL in a webview
      await Get.to(
        () => Scaffold(
          body: PopScope(
            canPop: false,
            // The result argument contains the pop result that is defined in `_PageTwo`.
            onPopInvokedWithResult: (bool didPop, Object? result) async {
              Get.find<CustomBottomNavBarController>().changePage(0);
              Get.offAllNamed(AppRoutes.home);
            },
            child: Stack(
              children: [
                WebViewWidget(controller: webViewController),
                Positioned(
                  top: 50.h, // Adjust the position as needed
                  left: 10.w, // Adjust the position as needed
                  child: IconButton(
                    onPressed: () {
                      Get.find<CustomBottomNavBarController>().changePage(0);
                      Get.offAllNamed(AppRoutes.home);
                      // completer.complete(SubscriptionStatus.subscriptionFailed);
                      // Get.back(); // Go back to the previous screen
                    },
                    icon: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            spreadRadius: 1.r,
                            blurRadius: 1.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Get.locale!.languageCode == "en"
                            ? Icons.arrow_back_rounded
                            : Icons.arrow_forward,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (response.statusCode == 400) {
      completer.complete(SubscriptionStatus.alreadySubscribed);
    } else {
      completer.complete(SubscriptionStatus.subscriptionFailed);
    }

    return completer.future;
  }

  Future<void> checkCoupon(String code) async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('${Api.API_URL}verify/coupon/$code'),
      headers: {
        'Accept': 'application/json',
      },
    );

    log("# response : ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        discount.value =
            (data['discount_percentage'] * totalAmount.value) / 100;
        log("# discount : $discount");
        totalAmountAfterDiscount.value =
            totalAmount.value - discount.toDouble();
        log("# totalAmountAfterDiscount : ${totalAmountAfterDiscount.value}");
        couponController.clear();
      } else {
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.sp);
      }
      isLoading.value = false;
    } else {
      final data = jsonDecode(response.body);
      Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp);
      // Error
      isLoading.value = false;
    }
  }
}
