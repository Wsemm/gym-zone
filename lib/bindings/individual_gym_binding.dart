import 'package:get/get.dart';
import 'package:gym_zones/controllers/individual_gym_details_screen_controller.dart';

import '../controllers/subscriptions_controller.dart';

class IndividualGymBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndividualGymDetailsScreenController>(
        () => IndividualGymDetailsScreenController());
  }
}
