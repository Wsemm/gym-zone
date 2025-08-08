import 'package:get/get.dart';

import '../controllers/new_visit_controller.dart';

class QrScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewVisitController());
  }
}