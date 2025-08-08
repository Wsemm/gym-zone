import 'package:get/get.dart';
import 'package:gym_zones/views/offers/controller/offer_controller.dart';

class OffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OfferController());
  }
}
