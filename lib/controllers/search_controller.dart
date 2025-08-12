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
import '../models/individual_gym.dart' as individual;
import 'auth_controller.dart';

// Create a unified search result class
class SearchResult {
  final Gym? gym;
  final individual.IndividualGym? individualGym;
  final bool isGroup;

  SearchResult.fromGym(this.gym)
      : individualGym = null,
        isGroup = true;
  SearchResult.fromIndividualGym(this.individualGym)
      : gym = null,
        isGroup = false;

  // Helper getters for common properties
  String get id => isGroup ? gym!.id : individualGym!.id ?? '';
  String get name => isGroup ? gym!.name : individualGym!.name ?? '';
  String get nameAr => isGroup ? gym!.nameAr : individualGym!.nameAr ?? '';
  String get logoPath =>
      isGroup ? gym!.logoPath : individualGym!.logoPath ?? '';

  // Additional helper methods
  String get displayName {
    final currentName = Get.locale?.languageCode == 'en' ? name : nameAr;
    return currentName.isNotEmpty ? currentName : name;
  }

  // Check if the search result has valid data
  bool get isValid => isGroup ? gym != null : individualGym != null;
}

class SearchController extends GetxController {
  PagingController<int, SearchResult>? pagingController;

  final RxList<SearchResult> searchResults = <SearchResult>[].obs;

  final _keywordsController = TextEditingController();
  TextEditingController get keywordsController => _keywordsController;

  var selectedGovernorate = RxInt(-1);
  var selectedProvinces = <int>[].obs;
  var showMixedGyms = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    _fetchGovernoratesWithProvinces();
    performNewSearchOperation();
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
    final groupUrl = Uri.parse('${Api.API_URL}gyms/search');
    final individualUrl = Uri.parse('${Api.API_URL}gyms/search');

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

    final List<SearchResult> combinedResults = [];

    try {
      // Search for group gyms
      final groupParams = Map<String, String>.from(queryParams);
      groupParams['gym_type'] = 'group';

      final groupResponse = await http.get(
        groupUrl.replace(queryParameters: groupParams),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}',
        },
      );

      if (groupResponse.statusCode == 200) {
        final groupDecodedJson = jsonDecode(groupResponse.body);
        final groupData = groupDecodedJson is List
            ? groupDecodedJson
            : groupDecodedJson['data'] ?? [];
        for (var gymData in groupData) {
          combinedResults.add(SearchResult.fromGym(Gym.fromJson(gymData)));
        }
      }

      // Search for individual gyms
      final individualParams = Map<String, String>.from(queryParams);
      individualParams['gym_type'] = 'individual';

      final individualResponse = await http.get(
        individualUrl.replace(queryParameters: individualParams),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Get.find<AuthController>().token}',
        },
      );

      if (individualResponse.statusCode == 200) {
        final individualDecodedJson = jsonDecode(individualResponse.body);
        final individualData = individualDecodedJson is List
            ? individualDecodedJson
            : individualDecodedJson['data'] ?? [];
        for (var gymData in individualData) {
          combinedResults.add(SearchResult.fromIndividualGym(
              individual.IndividualGym.fromJson(gymData)));
        }
      }

      // Handle pagination
      final isLastPage = combinedResults.length < 20;
      if (isLastPage) {
        pagingController!.appendLastPage(combinedResults);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController!.appendPage(combinedResults, nextPageKey);
      }

      searchResults.addAll(combinedResults);
    } catch (e) {
      // Handle error
      pagingController!.error = e;
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
