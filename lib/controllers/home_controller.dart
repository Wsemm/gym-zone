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
  int? serviceIndex;

  // ScrollController and GlobalKey for gym section scrolling
  late ScrollController scrollController;
  final GlobalKey gymsKey = GlobalKey();
  final GlobalKey individualGymsKey = GlobalKey();
  final GlobalKey offersKey = GlobalKey();
  final GlobalKey ourServicesKey = GlobalKey();

  Ad ad = Ad();

  @override
  void onInit() {
    scrollController = ScrollController();
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    // scrollController.dispose();
    super.onClose();
  }

  void scrollToGroupGyms() {
    final context = gymsKey.currentContext;
    if (context != null) {
      serviceIndex = 1;
      update();
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToOffers() {
    final context = offersKey.currentContext;
    if (context != null) {
      serviceIndex = 3;
      update();

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToIndividualGyms() {
    final context = individualGymsKey.currentContext;
    if (context != null) {
      serviceIndex = 2;
      update();
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToOurServices() {
    final context = ourServicesKey.currentContext;
    if (context != null) {
      serviceIndex = 0;
      update();
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  Future initData() async {
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
        await _fetchNearestGyms();
      } catch (e) {
        log("Error fetching nearest gyms: $e");
      }

      // try {
      await _fetchIndividualGyms();
      // } catch (e) {
      // log("Error fetching individual gyms: $e");
      // }

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

  void filterGymsByGovernorate(String? governorateName) {
    _selectedGovernorate = governorateName;
    _applyFilters();
  }

  void filterGymsByProvinces(List<int> provinces) {
    _selectedProvinces = List.from(provinces);
    _applyFilters();
  }

  void _applyFilters() {
    if (_selectedGovernorate == null ||
        (_selectedGovernorate?.isEmpty ?? true) ||
        _selectedGovernorate == 'All') {
      // No governorate filter, but check for province filter
      if (_selectedProvinces.isEmpty) {
        _filteredGyms = null;
        _filteredIndividualGyms = null;
      } else {
        // Filter by provinces only
        _filteredGyms = _nearestGyms
            ?.where((gym) => _selectedProvinces.contains(gym.province.id))
            .toList();
        _filteredIndividualGyms = _individualGyms
            ?.where((gym) =>
                gym.province != null &&
                _selectedProvinces.contains(gym.province?.id))
            .toList();
      }
    } else {
      // Filter by governorate first
      var governorateFilteredGyms = _nearestGyms
          ?.where(
              (gym) => gym.province.governorate?.name == _selectedGovernorate)
          .toList();
      var governorateFilteredIndividualGyms = _individualGyms
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
    update();
  }

  void clearFilters() {
    _selectedGovernorate = null;
    _selectedProvinces.clear();
    _filteredGyms = null;
    _filteredIndividualGyms = null;
    update();
  }

  List<Gym>? get gymsToDisplay => _filteredGyms ?? _nearestGyms;
  List<IndividualGym>? get individualGymsToDisplay =>
      _filteredIndividualGyms ?? _individualGyms;

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

    final response = await http.get(
      Uri.parse(
          '${Api.API_URL}gyms?gender=${_user != null ? user?.gender : GetStorage().read('gender')}&lat=${position.latitude}&lng=${position.longitude}'),
      headers: {
        'Accept': 'application/json',
      },
    );
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

  Future<void> _fetchIndividualGyms() async {
    isLoading = true;
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
      url.replace(queryParameters: {"gym_type": "individual"}),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
    );
    log("# Individual Gyms : ${response.statusCode}");
    log("# Individual Gyms  : ${response.request}");

    if (response.statusCode == 200) {
      // try {
      final decodedJson = jsonDecode(response.body);
      log("# Decoded JSON type: ${decodedJson.runtimeType}");
      log("# Decoded JSON: $decodedJson");
      log("# Data length: ${decodedJson["data"].length}");

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

      _individualGyms = List<IndividualGym>.from(
          individualGymsList.map((g) => IndividualGym.fromJson(g))).toList();
      update();
      // } catch (e) {
      //   log("# Error parsing gym data: $e");
      //   _individualGyms = [];
      //   RebiMessage.error(msg: "Failed to parse gym data".tr);
      //   update();
      // }
    } else {
      log("# Error fetching gyms: ${response.statusCode} - ${response.body}");
      _individualGyms = [];
      RebiMessage.error(msg: "Failed to fetch gyms".tr);
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
    );
    log("# Top Users : ${response.statusCode}");
    log("# Top Users : ${response.body}");
    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      _topUsers =
          List<User>.from((decodedJson as List).map((u) => User.fromJson(u)))
              .toList();
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
    );
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
    );

    if (response.statusCode == 200) {
      ad = Ad.fromJson(jsonDecode(response.body));
      update();
    }
  }
}
