import 'package:get/get.dart';
import 'package:gym_zones/controllers/custom_bottom_nav_bar_controller.dart';
import 'package:gym_zones/controllers/settings_controller.dart';
import 'package:gym_zones/controllers/visits_controller.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';

import '../controllers/auth_controller.dart';

class NavBarBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(CustomBottomNavBarController());
   Get.put(AuthController());
   Get.put(OfferController());
   Get.put(SettingsController());
   Get.put(VisitsController());
  }

}