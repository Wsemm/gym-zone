import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gym_zones/views/offers/data/category_model.dart';
import 'package:http/http.dart' as http;
import '../../../common/constants/api.dart';
import '../../../common/widgets/rebi_message.dart';
import '../data/offer_model.dart';

class OfferController extends GetxController {
  // RxList<Offer> offersList = RxList([]);
  // RxList<Offer> oldOffersList = RxList([]);
  // RxList<Offer> newOffersList = RxList([]);

  List<Offer> offersList = [];
  List<Offer> oldOffersList = [];
  List<Offer> newOffersList = [];

  RxList<Category> categoriesList = RxList([]);
  TextEditingController searchController = TextEditingController();
  RxBool isLoadingCategories = false.obs;
  RxBool isLoadingOffers = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGymsCategories();
  }

  Future<void> fetchGymsCategories() async {
    isLoadingCategories.value = true;
    final response = await http.get(
      Uri.parse('${Api.API_URL}get/offer/categories'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      categoriesList.value = CategoriesModel.fromJson(decodedJson).categories;
      isLoadingCategories.value = false;
    } else {
      // Error
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchOffersByCategory(int id) async {
    try {
      isLoadingOffers.value = true;
      final position = await _determinePosition();

      if (position == null) {
        offersList = [];
        RebiMessage.error(
            msg:
                "The application does not have permission to access the location."
                    .tr);
        update();
        return;
      }

      print("# position.longitude :${position.longitude}");
      print("# position.longitude :${position.latitude}");
      // RebiMessage.error(msg: "# position.longitude :${position.longitude}");
      // RebiMessage.error(msg: "# position.latitude :${position.latitude}");
      final response = await http.get(
        Uri.parse(
            '${Api.API_URL}get/offers/$id/${position.longitude}/${position.latitude}'),
        headers: {
          'Accept': 'application/json',
        },
      );
      // RebiMessage.error(msg: "# response :${response.statusCode}");
      // RebiMessage.error(msg: "# response :${response.body}");
      //

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        offersList.clear();
        offersList.addAll(OffersModel.fromJson(decodedJson).offers);
        oldOffersList.addAll(offersList);
        isLoadingOffers.value = false;
        update();
      } else {
        // Error
        isLoadingOffers.value = false;
        update();
      }
      update();
    } on Exception catch (e) {
      RebiMessage.error(msg: "EXCEPTION : $e");
    }
    update();
  }

  void updateList(String text) {
    if (text.isNotEmpty) {
      newOffersList.clear();
      for (var item in oldOffersList) {
        if (item.companyName!.contains(text) ||
            item.description!.contains(text)) {
          newOffersList.add(item);
        }
      }
      offersList.clear();
      offersList.addAll(newOffersList);
    } else {
      offersList.clear();
      offersList.addAll(oldOffersList);
    }
    update();
  }

  Future<Position?> _determinePosition() async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            Exception('Location permissions are permanently denied.'));
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(Exception('Location permissions are denied.'));
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Future<Position?> _determinePosition() async {
  //   try {
  //     bool serviceEnabled;
  //     LocationPermission permission;
  //
  //     // Test if location services are enabled.
  //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       // Location services are not enabled don't continue
  //       // accessing the position and request users of the
  //       // App to enable the location services.
  //       return Future.error('Location services are disabled.');
  //     }
  //
  //     permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         // Permissions are denied, next time you could try
  //         // requesting permissions again (this is also where
  //         // Android's shouldShowRequestPermissionRationale
  //         // returned true. According to Android guidelines
  //         // your App should show an explanatory UI now.
  //         return Future.error('Location permissions are denied');
  //       }
  //     }
  //
  //     if (permission == LocationPermission.deniedForever) {
  //       // Permissions are denied forever, handle appropriately.
  //       return Future.error(
  //           'Location permissions are permanently denied, we cannot request permissions.');
  //     }
  //
  //     // When we reach here, permissions are granted and we can
  //     // continue accessing the position of the device.
  //     return await Geolocator.getCurrentPosition();
  //   } catch (e) {
  //     log("# Exception : $e");
  //     return null;
  //   }
  // }
}
