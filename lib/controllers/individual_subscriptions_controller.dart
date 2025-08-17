import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'home_controller.dart';

class IndividualSubscriptionsController extends GetxController {
  ScrollController scrollController = ScrollController();
  late String pageKey;
  late bool? isLoadingMoreData;
  @override
  void onInit() {
    pageKey = "2";
    isLoadingMoreData = null;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Load more data when scroll reaches the bottom
        loadMoreData();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void loadMoreData() async {
    if (Get.find<HomeController>().isMoreData == true) {
      isLoadingMoreData = true;
      update();
      await Get.find<HomeController>()
          .fetchIndividualGyms(pageKey: pageKey, doLoading: false);
      pageKey = (int.parse(pageKey) + 1).toString();
    } else if (Get.find<HomeController>().isMoreData == false) {
      log("#log No More Data");
    }
    isLoadingMoreData = false;
    update();
  }
}
