import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../common/constants/api.dart';
import '../common/constants/constants.dart';
import '../common/navigation/app_routes.dart';
import '../common/widgets/rebi_message.dart';

enum UpdateStatus {
  required,
  optional,
  notRequired,
}

class LandingController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await checkLocationPermission();
    await checkForUpdate(Get.context!);
    // final status = await _checkForAppUpdate();
    // if (status == UpdateStatus.required) {
    //   Get.offAllNamed(AppRoutes.updateApp);
    // } else if (status == UpdateStatus.optional) {
    //   Get.offAllNamed(AppRoutes.updateApp, arguments: true);
    // } else {
    //   Get.offAllNamed(AppRoutes.home);
    // }
    Get.offAllNamed(AppRoutes.home);
  }

  Future<UpdateStatus> _checkForAppUpdate() async {
    final response = await http.get(
      Uri.parse(
          '${Api.API_URL}gym-zones/releases/latest?platform=${GetPlatform.isAndroid ? 'android' : 'ios'}'),
      headers: {
        'Accept': 'application/json',
      },
    );
    // log("# landing response : ${response.body}");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (response.statusCode == 200) {
      final currentVersion = packageInfo.version;
      log("# currentVersion : ${currentVersion}");
      final latestVersion = jsonDecode(response.body)['version'];
      final forecUpdate = jsonDecode(response.body)['force_update'];

      if (currentVersion != latestVersion && forecUpdate == true) {
        return UpdateStatus.required;
      } else if (currentVersion != latestVersion && forecUpdate == false) {
        return UpdateStatus.optional;
      } else {
        return UpdateStatus.notRequired;
      }
    } else {
      return UpdateStatus.notRequired;
    }
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
}
