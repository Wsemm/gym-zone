import 'package:get/get.dart';

class CustomBottomNavBarController extends GetxController {
  Future<CustomBottomNavBarController> init() async => this;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void changePage(int index) {
    _currentIndex = index;
    update();
  }
}
