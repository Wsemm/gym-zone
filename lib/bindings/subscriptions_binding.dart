import 'package:get/get.dart';

import '../controllers/subscriptions_controller.dart';
import '../controllers/search_controller.dart' as search_ctrl;

class SubscriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionsController>(() => SubscriptionsController());
    Get.lazyPut<search_ctrl.SearchController>(
        () => search_ctrl.SearchController());
  }
}
