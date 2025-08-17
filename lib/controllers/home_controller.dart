import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/widgets/rebi_message.dart';
import 'package:gym_zones/models/ad.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:http/http.dart' as http;

import '../common/constants/api.dart';
import '../common/constants/constants.dart';
import '../common/constants/my_enum.dart';
import '../common/navigation/app_routes.dart';
import '../models/gym.dart';
import '../models/user.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  User? _user;

  User? get user => _user;

  String? _token;
  RxInt imageIndex = 0.obs;
  RxInt imageIndexHomepage = 0.obs;
  RxInt analyticsIndex = 0.obs;

  bool isLoading = true;
  bool isIndividualGymsLoading = true;
  late bool? isMoreData;
  int? serviceIndex;

  // ScrollController and GlobalKey for gym section scrolling
  late ScrollController scrollController;
  late ScrollController individualViewScrollController;
  final GlobalKey gymsKey = GlobalKey();
  final GlobalKey individualGymsKey = GlobalKey();
  final GlobalKey offersKey = GlobalKey();
  final GlobalKey ourServicesKey = GlobalKey();

  Ad ad = Ad();

  @override
  void onInit() {
    scrollController = ScrollController();
    individualViewScrollController = ScrollController();
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    // scrollController.dispose();
    super.onClose();
  }

  void scrollToGroupGyms() {
    serviceIndex = 1;
    update();
    _scrollToWidget(gymsKey, _calculateNearestGymsPosition());
  }

  void scrollToOffers() {
    serviceIndex = 3;
    update();
    _scrollToWidget(offersKey, _calculateOffersPosition());
  }

  void scrollToIndividualGyms() {
    serviceIndex = 2;
    update();
    _scrollToWidget(individualGymsKey, _calculateIndividualGymsPosition());
  }

  void scrollToOurServices() {
    serviceIndex = 0;
    update();
    _scrollToWidget(ourServicesKey, _calculateOurServicesPosition());
  }

  // Smart scroll function with context retry and position fallback
  void _scrollToWidget(GlobalKey key, double fallbackPosition) {
    final context = key.currentContext;

    if (context != null) {
      // Context available - use precise scrolling
      try {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        return;
      } catch (e) {
        log("Error with ensureVisible: $e");
      }
    }

    // Context null or error - use position-based fallback
    log("Context null for key, using fallback position: $fallbackPosition");
    scrollController.animateTo(
      fallbackPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  // Helper methods to calculate approximate positions
  double _calculateOurServicesPosition() {
    // Position right after the floating header
    return _calculateFirstSliverHeight();
  }

  double _calculateNearestGymsPosition() {
    // Our services height + some spacing
    return _calculateFirstSliverHeight() +
        200; // Approximate height of OurServicesCard
  }

  double _calculateIndividualGymsPosition() {
    // Our services + nearest gyms + spacing
    double nearestGymsHeight =
        (nearestGyms?.length ?? 0) * 120.0 + 100; // Estimate gym cards height
    return _calculateFirstSliverHeight() + 200 + nearestGymsHeight;
  }

  double _calculateOffersPosition() {
    // All previous sections + individual gyms
    double nearestGymsHeight = (nearestGyms?.length ?? 0) * 120.0 + 100;
    double individualGymsHeight = (individualGyms?.length ?? 0) * 120.0 + 100;
    return _calculateFirstSliverHeight() +
        200 +
        nearestGymsHeight +
        individualGymsHeight;
  }

  double _calculateFirstSliverHeight() {
    // Calculate approximate height of first sliver content
    double baseHeight = 100; // Search bar and basic spacing

    // Add free week card if shown
    if (user != null &&
        user!.subscriptionType == SubscriptionType.trial.name &&
        user!.subscriptionStatus == SubscriptionStatus.inactive.name) {
      baseHeight += 100; // FreeWeekCard height
    }

    // Add statistics card if shown
    if (user != null &&
        (user!.hasSubscription ||
            user!.subscriptionType == SubscriptionType.both.name ||
            user!.subscriptionType == SubscriptionType.individual.name)) {
      baseHeight += 150; // Statistics card height
    }

    // Add ads section if present
    if (ad.data != null && ad.data!.isNotEmpty) {
      baseHeight += 200; // Carousel + indicators
    }

    // Add top users section if present
    if (topUsers != null && topUsers!.isNotEmpty) {
      baseHeight += 200; // Top users carousel
    }

    return baseHeight;
  }

  Future initData() async {
    isMoreData = true;
    try {
      if (Get.context != null) {
        await checkForUpdate(Get.context!);
      }
      isLoading = true;
      _nearestGyms = [];
      _topUsers = [];
      _token = Get.find<AuthController>().token;
      update();

      if (_token != null) {
        _user = User.fromJson(GetStorage().read('user'));

        try {
          final response = await http.get(
            Uri.parse('${Api.API_URL}users/${_user?.id}'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $_token',
            },
          ).timeout(const Duration(seconds: 10));

          log("# user information : ${response.statusCode}");

          if (response.statusCode == 401) {
            Get.find<AuthController>().removeTokenAndUser();
            Get.offNamed(AppRoutes.login);
            return;
          } else if (response.statusCode == 403) {
            Get.offNamed(AppRoutes.verifyEmail);
            return;
          } else if (response.statusCode != 200) {
            // Don't show error for non-200 responses, just continue
            log("API Error: ${response.statusCode}");
          } else {
            // Update user data
            _user = User.fromJson(jsonDecode(response.body));
            GetStorage().write('user', _user?.toJson());
            await _fetchUnviewedNotificationsCount();
          }
        } catch (e) {
          log("Error fetching user data: $e");
          // Continue without user data
        }
      }

      // Fetch data with error handling
      try {
        await fetchNearestGyms(pageKey: "1", doLoading: true);
      } catch (e) {
        log("Error fetching nearest gyms: $e");
      }

      try {
        await fetchIndividualGyms(pageKey: "1", doLoading: true);
      } catch (e) {
        log("Error fetching individual gyms: $e");
      }

      try {
        await _fetchTopUsers();
      } catch (e) {
        log("Error fetching top users: $e");
      }

      try {
        await _fetchAds();
      } catch (e) {
        log("Error fetching ads: $e");
      }
    } catch (e) {
      log("Error in initData: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  List<Gym>? _nearestGyms;

  List<Gym>? get nearestGyms => _nearestGyms;

  List<IndividualGym>? _individualGyms;

  List<IndividualGym>? get individualGyms => _individualGyms;

  List<Gym>? _filteredGyms;

  List<Gym>? get filteredGyms => _filteredGyms;

  List<IndividualGym>? _filteredIndividualGyms;

  List<IndividualGym>? get filteredIndividualGyms => _filteredIndividualGyms;

  String? _selectedGovernorate;

  String? get selectedGovernorate => _selectedGovernorate;

  List<int> _selectedProvinces = [];

  List<int> get selectedProvinces => _selectedProvinces;

  String? _searchQuery;

  String? get searchQuery => _searchQuery;

  // Separate search and filter states for group gyms
  String? _selectedGovernorateGroup;
  String? get selectedGovernorateGroup => _selectedGovernorateGroup;

  List<int> _selectedProvincesGroup = [];
  List<int> get selectedProvincesGroup => _selectedProvincesGroup;

  String? _searchQueryGroup;
  String? get searchQueryGroup => _searchQueryGroup;

  // Separate search and filter states for individual gyms
  String? _selectedGovernorateIndividual;
  String? get selectedGovernorateIndividual => _selectedGovernorateIndividual;

  List<int> _selectedProvincesIndividual = [];
  List<int> get selectedProvincesIndividual => _selectedProvincesIndividual;

  String? _searchQueryIndividual;
  String? get searchQueryIndividual => _searchQueryIndividual;

  // Group gyms filter methods
  void filterGroupGymsByGovernorate(String? governorateName) {
    _selectedGovernorateGroup = governorateName;
    applyGroupFilters();
  }

  void filterGroupGymsByProvinces(List<int> provinces) {
    _selectedProvincesGroup = List.from(provinces);
    applyGroupFilters();
  }

  void filterGroupGymsBySearch(String? searchQuery) {
    _searchQueryGroup = searchQuery?.trim();
    applyGroupFilters();
  }

  // Individual gyms filter methods
  void filterIndividualGymsByGovernorate(String? governorateName) {
    _selectedGovernorateIndividual = governorateName;
    applyIndividualFilters();
  }

  void filterIndividualGymsByProvinces(List<int> provinces) {
    _selectedProvincesIndividual = List.from(provinces);
    applyIndividualFilters();
  }

  void filterIndividualGymsBySearch(String? searchQuery) {
    _searchQueryIndividual = searchQuery?.trim();
    applyIndividualFilters();
  }

  // Original methods for backward compatibility (can be used for home view)
  void filterGymsByGovernorate(String? governorateName) {
    _selectedGovernorate = governorateName;
    applyFilters();
  }

  void filterGymsByProvinces(List<int> provinces) {
    _selectedProvinces = List.from(provinces);
    applyFilters();
  }

  void filterGymsBySearch(String? searchQuery) {
    _searchQuery = searchQuery?.trim();
    applyFilters();
  }

  void applyFilters() {
    List<Gym>? baseGyms = _nearestGyms;
    List<IndividualGym>? baseIndividualGyms = _individualGyms;

    // Apply search filter first if there's a search query
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      baseGyms = baseGyms?.where((gym) {
        return (gym.name.toLowerCase().contains(_searchQuery!.toLowerCase())) ||
            (gym.nameAr.toLowerCase().contains(_searchQuery!.toLowerCase()));
      }).toList();

      baseIndividualGyms = baseIndividualGyms?.where((gym) {
        return (gym.name?.toLowerCase().contains(_searchQuery!.toLowerCase()) ??
                false) ||
            (gym.nameAr?.toLowerCase().contains(_searchQuery!.toLowerCase()) ??
                false);
      }).toList();
    }

    if (_selectedGovernorate == null ||
        (_selectedGovernorate?.isEmpty ?? true) ||
        _selectedGovernorate == 'All') {
      // No governorate filter, but check for province filter
      if (_selectedProvinces.isEmpty) {
        _filteredGyms = baseGyms;
        _filteredIndividualGyms = baseIndividualGyms;
      } else {
        // Filter by provinces only
        _filteredGyms = baseGyms
            ?.where((gym) => _selectedProvinces.contains(gym.province.id))
            .toList();
        _filteredIndividualGyms = baseIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvinces.contains(gym.province?.id))
            .toList();
      }
    } else {
      // Filter by governorate first
      var governorateFilteredGyms = baseGyms
          ?.where(
              (gym) => gym.province.governorate?.name == _selectedGovernorate)
          .toList();
      var governorateFilteredIndividualGyms = baseIndividualGyms
          ?.where(
              (gym) => gym.province?.governorate?.name == _selectedGovernorate)
          .toList();

      // Then apply province filter if provinces are selected
      if (_selectedProvinces.isEmpty) {
        _filteredGyms = governorateFilteredGyms;
        _filteredIndividualGyms = governorateFilteredIndividualGyms;
      } else {
        _filteredGyms = governorateFilteredGyms
            ?.where((gym) => _selectedProvinces.contains(gym.province.id))
            .toList();
        _filteredIndividualGyms = governorateFilteredIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvinces.contains(gym.province?.id))
            .toList();
      }
    }

    // If no search query and no other filters, show all gyms
    if ((_searchQuery == null || _searchQuery!.isEmpty) &&
        (_selectedGovernorate == null || _selectedGovernorate == 'All') &&
        _selectedProvinces.isEmpty) {
      _filteredGyms = null;
      _filteredIndividualGyms = null;
    }

    update();
  }

  void applyGroupFilters() {
    List<Gym>? baseGyms = _nearestGyms;
    List<IndividualGym>? baseIndividualGyms = _individualGyms;

    // Apply search filter first if there's a search query
    if (_searchQueryGroup != null && _searchQueryGroup!.isNotEmpty) {
      baseGyms = baseGyms?.where((gym) {
        return (gym.name
                .toLowerCase()
                .contains(_searchQueryGroup!.toLowerCase())) ||
            (gym.nameAr
                .toLowerCase()
                .contains(_searchQueryGroup!.toLowerCase()));
      }).toList();

      baseIndividualGyms = baseIndividualGyms?.where((gym) {
        return (gym.name
                    ?.toLowerCase()
                    .contains(_searchQueryGroup!.toLowerCase()) ??
                false) ||
            (gym.nameAr
                    ?.toLowerCase()
                    .contains(_searchQueryGroup!.toLowerCase()) ??
                false);
      }).toList();
    }

    if (_selectedGovernorateGroup == null ||
        (_selectedGovernorateGroup?.isEmpty ?? true) ||
        _selectedGovernorateGroup == 'All') {
      // No governorate filter, but check for province filter
      if (_selectedProvincesGroup.isEmpty) {
        _filteredGyms = baseGyms;
        _filteredIndividualGyms = baseIndividualGyms;
      } else {
        // Filter by provinces only
        _filteredGyms = baseGyms
            ?.where((gym) => _selectedProvincesGroup.contains(gym.province.id))
            .toList();
        _filteredIndividualGyms = baseIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvincesGroup.contains(gym.province?.id))
            .toList();
      }
    } else {
      // Filter by governorate first
      var governorateFilteredGyms = baseGyms
          ?.where((gym) =>
              gym.province.governorate?.name == _selectedGovernorateGroup)
          .toList();
      var governorateFilteredIndividualGyms = baseIndividualGyms
          ?.where((gym) =>
              gym.province?.governorate?.name == _selectedGovernorateGroup)
          .toList();

      // Then apply province filter if provinces are selected
      if (_selectedProvincesGroup.isEmpty) {
        _filteredGyms = governorateFilteredGyms;
        _filteredIndividualGyms = governorateFilteredIndividualGyms;
      } else {
        _filteredGyms = governorateFilteredGyms
            ?.where((gym) => _selectedProvincesGroup.contains(gym.province.id))
            .toList();
        _filteredIndividualGyms = governorateFilteredIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvincesGroup.contains(gym.province?.id))
            .toList();
      }
    }

    // If no search query and no other filters, show all gyms
    if ((_searchQueryGroup == null || _searchQueryGroup!.isEmpty) &&
        (_selectedGovernorateGroup == null ||
            _selectedGovernorateGroup == 'All') &&
        _selectedProvincesGroup.isEmpty) {
      _filteredGyms = null;
      _filteredIndividualGyms = null;
    }

    update();
  }

  void applyIndividualFilters() {
    List<IndividualGym>? baseIndividualGyms = _individualGyms;

    // Apply search filter first if there's a search query
    if (_searchQueryIndividual != null && _searchQueryIndividual!.isNotEmpty) {
      baseIndividualGyms = baseIndividualGyms?.where((gym) {
        return (gym.name
                    ?.toLowerCase()
                    .contains(_searchQueryIndividual!.toLowerCase()) ??
                false) ||
            (gym.nameAr
                    ?.toLowerCase()
                    .contains(_searchQueryIndividual!.toLowerCase()) ??
                false);
      }).toList();
    }

    if (_selectedGovernorateIndividual == null ||
        (_selectedGovernorateIndividual?.isEmpty ?? true) ||
        _selectedGovernorateIndividual == 'All') {
      // No governorate filter, but check for province filter
      if (_selectedProvincesIndividual.isEmpty) {
        _filteredIndividualGyms = baseIndividualGyms;
      } else {
        // Filter by provinces only
        _filteredIndividualGyms = baseIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvincesIndividual.contains(gym.province?.id))
            .toList();
      }
    } else {
      // Filter by governorate first
      var governorateFilteredIndividualGyms = baseIndividualGyms
          ?.where((gym) =>
              gym.province?.governorate?.name == _selectedGovernorateIndividual)
          .toList();

      // Then apply province filter if provinces are selected
      if (_selectedProvincesIndividual.isEmpty) {
        _filteredIndividualGyms = governorateFilteredIndividualGyms;
      } else {
        _filteredIndividualGyms = governorateFilteredIndividualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvincesIndividual.contains(gym.province?.id))
            .toList();
      }
    }

    // If no search query and no other filters, show all individual gyms
    if ((_searchQueryIndividual == null || _searchQueryIndividual!.isEmpty) &&
        (_selectedGovernorateIndividual == null ||
            _selectedGovernorateIndividual == 'All') &&
        _selectedProvincesIndividual.isEmpty) {
      _filteredIndividualGyms = null;
    }

    update();
  }

  void clearFilters() {
    _selectedGovernorate = null;
    _selectedProvinces.clear();
    _searchQuery = null;
    _filteredGyms = null;
    _filteredIndividualGyms = null;
    update();
  }

  void clearGroupFilters() {
    _selectedGovernorateGroup = null;
    _selectedProvincesGroup.clear();
    _searchQueryGroup = null;
    _filteredGyms = null;
    update();
  }

  void clearIndividualFilters() {
    _selectedGovernorateIndividual = null;
    _selectedProvincesIndividual.clear();
    _searchQueryIndividual = null;
    _filteredIndividualGyms = null;
    update();
  }

  List<Gym>? get gymsToDisplay => _filteredGyms ?? _nearestGyms;
  List<IndividualGym>? get individualGymsToDisplay =>
      _filteredIndividualGyms ?? _individualGyms;

  Future<void> fetchNearestGyms(
      {required String pageKey, required bool doLoading}) async {
    if (doLoading) {
      isLoading = true;
    } else {
      isLoading = false;
    }
    update();

    bool? result = await checkLocationPermission();
    final position = result == true ? await _determinePosition() : null;

    if (position == null) {
      _nearestGyms = [];
      RebiMessage.error(
          msg:
              "The application does not have permission to access the location."
                  .tr);
      update();
      return;
    }

    final response = await http.get(
      Uri.parse(
          '${Api.API_URL}gyms?gender=${_user != null ? user?.gender : GetStorage().read('gender')}&lat=${position.latitude}&lng=${position.longitude}&gym_type=group&page=$pageKey'),
      headers: {
        'Accept': 'application/json',
      },
    );

    log("# Nearest Gyms Page $pageKey : ${response.statusCode}");
    log("# Nearest Gyms  : ${response.request}");

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        log("# Decoded JSON type: ${decodedJson.runtimeType}");
        log("# Decoded JSON: $decodedJson");

        List<dynamic> gymsList;

        // Check if the response is a List or a Map
        if (decodedJson is List) {
          gymsList = decodedJson;
        } else if (decodedJson is Map<String, dynamic>) {
          // Handle case where response is wrapped in an object
          if (decodedJson.containsKey('data')) {
            gymsList = decodedJson['data'] as List<dynamic>;
          } else if (decodedJson.containsKey('gyms')) {
            gymsList = decodedJson['gyms'] as List<dynamic>;
          } else {
            // If it's a map but doesn't contain expected keys, treat as error
            log("# Unexpected response structure: $decodedJson");
            _nearestGyms = [];
            RebiMessage.error(msg: "Unexpected response format from server".tr);
            update();
            return;
          }
        } else {
          log("# Unexpected response type: ${decodedJson.runtimeType}");
          _nearestGyms = [];
          RebiMessage.error(msg: "Invalid response format from server".tr);
          update();
          return;
        }

        if (!doLoading) {
          _nearestGyms
              ?.addAll(List<Gym>.from(gymsList.map((g) => Gym.fromJson(g))));
          // Don't modify global isMoreData here, let individual controllers manage it
        } else {
          _nearestGyms =
              List<Gym>.from(gymsList.map((g) => Gym.fromJson(g))).toList();
        }
        update();
      } catch (e) {
        log("# Error parsing gym data: $e");
        _nearestGyms = [];
        RebiMessage.error(msg: "Failed to parse gym data".tr);
        update();
      }
      isLoading = false;
      update();
    } else {
      log("# Error fetching gyms: ${response.statusCode} - ${response.body}");
      _nearestGyms = [];
      RebiMessage.error(msg: "Failed to fetch gyms".tr);
      isLoading = false;
      update();
    }
  }

  Future<void> _fetchNearestGyms() async {
    isLoading = true;
    bool? result = await checkLocationPermission();
    final position = result == true ? await _determinePosition() : null;

    if (position == null) {
      _nearestGyms = [];
      RebiMessage.error(
          msg:
              "The application does not have permission to access the location."
                  .tr);
      update();
      return;
    }
    // final url = Uri.parse('${Api.API_URL}gyms/search');
    // final response = await http.get(
    //   url.replace(queryParameters: {"gym_type": "group"}),
    //   headers: {
    //     'Accept': 'application/json',
    //     // 'Authorization': 'Bearer ${Get.find<AuthController>().token}',
    //   },
    // );
    final response = await http.get(
      Uri.parse(
          '${Api.API_URL}gyms?gender=${_user != null ? user?.gender : GetStorage().read('gender')}&lat=${position.latitude}&lng=${position.longitude}&gym_type=group'),
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));

    log("# Nearest Gyms : ${response.statusCode}");
    log("# Nearest Gyms  : ${response.request}");

    if (response.statusCode == 200) {
      try {
        final decodedJson = jsonDecode(response.body);
        log("# Decoded JSON type: ${decodedJson.runtimeType}");
        log("# Decoded JSON: $decodedJson");

        List<dynamic> gymsList;

        // Check if the response is a List or a Map
        if (decodedJson is List) {
          gymsList = decodedJson;
        } else if (decodedJson is Map<String, dynamic>) {
          // Handle case where response is wrapped in an object
          if (decodedJson.containsKey('data')) {
            gymsList = decodedJson['data'] as List<dynamic>;
          } else if (decodedJson.containsKey('gyms')) {
            gymsList = decodedJson['gyms'] as List<dynamic>;
          } else {
            // If it's a map but doesn't contain expected keys, treat as error
            log("# Unexpected response structure: $decodedJson");
            _nearestGyms = [];
            RebiMessage.error(msg: "Unexpected response format from server".tr);
            update();
            return;
          }
        } else {
          log("# Unexpected response type: ${decodedJson.runtimeType}");
          _nearestGyms = [];
          RebiMessage.error(msg: "Invalid response format from server".tr);
          update();
          return;
        }

        _nearestGyms =
            List<Gym>.from(gymsList.map((g) => Gym.fromJson(g))).toList();
        update();
      } catch (e) {
        log("# Error parsing gym data: $e");
        _nearestGyms = [];
        RebiMessage.error(msg: "Failed to parse gym data".tr);
        update();
      }
    } else {
      log("# Error fetching gyms: ${response.statusCode} - ${response.body}");
      _nearestGyms = [];
      RebiMessage.error(msg: "Failed to fetch gyms".tr);
      update();
    }
  }

  Future<void> fetchIndividualGyms(
      {required String pageKey, required bool doLoading}) async {
    if (doLoading) {
      isIndividualGymsLoading = true;
    } else {
      isIndividualGymsLoading = false;
    }
    update();
    // bool? result = await checkLocationPermission();
    // final position = result == true ? await _determinePosition() : null;

    // if (position == null) {
    //   _individualGyms = [];
    //   RebiMessage.error(
    //       msg:
    //           "The application does not have permission to access the location."
    //               .tr);
    //   update();
    //   return;
    // }

    final url = Uri.parse('${Api.API_URL}gyms/search');

    final response = await http.get(
      url.replace(queryParameters: {"gym_type": "individual", "page": pageKey}),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
    );
    log("# Individual Gyms ================================================");

    log("# Individual Gyms : ${response.statusCode}");
    log("# Individual Gyms  : ${response.request}");

    if (response.statusCode == 200) {
      // try {
      final decodedJson = jsonDecode(response.body);
      log("# Decoded JSON type: ${decodedJson.runtimeType}");
      log("# Decoded JSON: $decodedJson");

      List<dynamic> individualGymsList;

      // Check if the response is a List or a Map
      if (decodedJson is List) {
        individualGymsList = decodedJson;
      } else if (decodedJson is Map<String, dynamic>) {
        // Handle case where response is wrapped in an object
        if (decodedJson.containsKey('data')) {
          individualGymsList = decodedJson['data'] as List<dynamic>;
        } else if (decodedJson.containsKey('gyms')) {
          individualGymsList = decodedJson['gyms'] as List<dynamic>;
        } else {
          // If it's a map but doesn't contain expected keys, treat as error
          log("# Unexpected response structure: $decodedJson");
          _individualGyms = [];
          RebiMessage.error(msg: "Unexpected response format from server".tr);
          update();
          return;
        }
      } else {
        log("# Unexpected response type: ${decodedJson.runtimeType}");
        _individualGyms = [];
        RebiMessage.error(msg: "Invalid response format from server".tr);
        update();
        return;
      }
      if (!doLoading) {
        _individualGyms?.addAll(List<IndividualGym>.from(
            individualGymsList.map((g) => IndividualGym.fromJson(g))));
        if (individualGymsList.isEmpty) {
          isMoreData = false;
        }
      } else {
        _individualGyms = List<IndividualGym>.from(
            individualGymsList.map((g) => IndividualGym.fromJson(g))).toList();
      }
      update();

      // } catch (e) {
      //   log("# Error parsing gym data: $e");
      //   _individualGyms = [];
      //   RebiMessage.error(msg: "Failed to parse gym data".tr);
      //   update();
      // }
      isIndividualGymsLoading = false;
      update();
    } else {
      log("# Error fetching gyms: ${response.statusCode} - ${response.body}");
      _individualGyms = [];
      RebiMessage.error(msg: "Failed to fetch gyms".tr);
      isIndividualGymsLoading = false;

      update();
    }
  }

  Future<Position?> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    try {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              Exception('Location permissions are permanently denied.'));
        }

        if (permission == LocationPermission.denied) {
          return Future.error(Exception('Location permissions are denied.'));
        }
      }
    } on Exception catch (e) {
      log("# Exception :$e");
    }
    update();

    return await Geolocator.getCurrentPosition();
  }

  List<User>? _topUsers;

  List<User>? get topUsers => _topUsers;

  Future<void> _fetchTopUsers() async {
    final response = await http.get(
      Uri.parse(
          '${Api.API_URL}users/top?gender=${_user != null ? user?.gender : GetStorage().read('gender')}'),
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 15));
    log("# Top Users : ${response.statusCode}");
    log("# Top Users : ${response.body}");
    log("# Top Users Length is : ${jsonDecode(response.body).length}");
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      _topUsers =
          List<User>.from((decodedJson as List).map((u) => User.fromJson(u)))
              .toList();
      log("# My Top Users : ${_topUsers?.length}");
      update();
    } else {
      // Error
    }
  }

  int _unviewedNotificationsCount = 0;

  int get unviewedNotificationsCount => _unviewedNotificationsCount;

  Future<void> _fetchUnviewedNotificationsCount() async {
    final response = await http.get(
      Uri.parse('${Api.API_URL}notifications/unviewed-count'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
    ).timeout(const Duration(seconds: 15));
    log("# Unviewed Notifications Count : ${response.statusCode}");
    log("# Unviewed Notifications Count : ${response.body}");
    if (response.statusCode == 200) {
      _unviewedNotificationsCount = jsonDecode(response.body)['unviewed_count'];
      update();
    }
  }

  void setUnviewedNotificationsCountToZero() {
    _unviewedNotificationsCount = 0;
    update();
  }

  Future<void> refreshView() async {
    onInit();
  }

  Future checkLocationPermission() async {
    var permission = await Geolocator.checkPermission();
    // RebiMessage.error(msg: "permission $permission");
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return true;
    } else if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      checkLocationPermission();
    } else if (permission == LocationPermission.deniedForever) {
      RebiMessage.error(msg: "Location Deny");
      return false;
    }
  }

  // Future<void> sendWhatsAppMessage() async {
  //   final uri = Uri.parse('https://api.zentramsg.com/v1/messages');

  //   final request = http.MultipartRequest('POST', uri)
  //     ..headers['x-api-token'] =
  //         '5486aa72-1b41-4332-980c-a7b7a527da89' // Replace with your real API token
  //     ..fields['device_uuid'] =
  //         '6a8950c1-bff2-4d1b-8453-f665b4ed96be' // Replace with your real device UUID
  //     ..fields['text_message'] = 'Hello from wsem using Flutter!'
  //     ..fields['type_message'] = 'text'
  //     ..fields['type_contact'] = 'numbers'
  //     ..fields['ids'] = '963958409501'; // Replace with real phone numbers

  //   try {
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('✅ Message sent successfully:\n${response.body}');
  //     } else {
  //       print('❌ Failed to send message. Status code: ${response.statusCode}');
  //       print('Response body:\n${response.body}');
  //     }
  //   } catch (e) {
  //     print('❗ Error sending message: $e');
  //   }
  // }

  _fetchAds() async {
    final response = await http.get(
      Uri.parse(Api.ads),
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      ad = Ad.fromJson(jsonDecode(response.body));
      update();
    }
  }
}
