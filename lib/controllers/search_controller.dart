import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/controllers/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../common/constants/api.dart';
import '../models/governorate.dart';
import '../models/gym.dart';
import 'auth_controller.dart';

class SearchController extends GetxController {
  PagingController<int, Gym>? pagingController;

  final RxList<Gym> searchResults = <Gym>[].obs;

  final _keywordsController = TextEditingController();
  TextEditingController get keywordsController => _keywordsController;

  var selectedGovernorate = RxInt(-1);
  var selectedProvinces = <int>[].obs;
  var showMixedGyms = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    _fetchGovernoratesWithProvinces();
  }

  List<Governorate>? _governorates;
  List<Governorate>? get governorates => _governorates;

  void _fetchGovernoratesWithProvinces() async {
    final response = await http.get(
      Uri.parse('${Api.API_URL}governorates'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      _governorates =
          (decodedJson as List).map((e) => Governorate.fromJson(e)).toList();

      _governorates!.insert(
        0,
        Governorate(
          id: -1,
          name: 'All',
          nameAr: 'الكل',
          provinces: [],
        ),
      );

      update();
    }
  }

  void _searchGyms({int pageKey = 1}) async {
    final url = Uri.parse('${Api.API_URL}gyms/search');

    Map<String, String> queryParams = {};

    if (_keywordsController.text.trim().isNotEmpty) {
      queryParams['keyword'] = _keywordsController.text.trim();
    }

    if (selectedGovernorate.value != -1) {
      queryParams['governorate_id'] = selectedGovernorate.value.toString();
    }

    if (selectedProvinces.isNotEmpty) {
      queryParams['province_ids'] = selectedProvinces.join(',');
    }

    final user = Get.find<HomeController>().user;
    queryParams['gender'] =
        user != null ? user.gender : GetStorage().read('gender');
    queryParams['show_mixed_gyms'] = showMixedGyms.value ? '1' : '0';
    queryParams['page'] = pageKey.toString();

    final response = await http.get(
      url.replace(queryParameters: queryParams),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
    );

    if (response.statusCode == 200) {
      final gyms = <Gym>[];
      final decodedJson = jsonDecode(response.body);
      decodedJson['data'].forEach((e) {
        gyms.add(Gym.fromJson(e));
      });

      final isLastPage = gyms.length < 20;
      if (isLastPage) {
        pagingController!.appendLastPage(gyms);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController!.appendPage(gyms, nextPageKey);
      }

      searchResults.addAll(gyms);
    } else {
      // Handle error
    }
  }

  void performNewSearchOperation() {
    if (pagingController == null) {
      pagingController = PagingController(firstPageKey: 1);
      pagingController!.addPageRequestListener((pageKey) {
        _searchGyms(pageKey: pageKey);
      });
    } else {
      searchResults.clear();
      pagingController!.refresh();
    }
    update();
  }
}
