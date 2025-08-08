import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../common/constants/api.dart';
import '../models/visit.dart';
import 'auth_controller.dart';

class VisitsController extends GetxController {
  User? _user;

  User? get user => _user;
  final PagingController<int, Visit> _pagingController =
      PagingController(firstPageKey: 1);
  PagingController<int, Visit> get pagingController => _pagingController;

  Rx<int> currentPage = 0.obs;

  @override
  void onInit() {
    final userInStorage = GetStorage().read('user');
    if (userInStorage != null) {
      _user = User.fromJson(userInStorage);
    }
    _pagingController.addPageRequestListener((pageKey) {
      _fetchVisitsPage(pageKey);
    });
    super.onInit();
  }

  Future<void> _fetchVisitsPage(int pageKey) async {
    try {
      final response = await http
          .get(Uri.parse('${Api.API_URL}visits?page=$pageKey'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      });

      final newVisits = (jsonDecode(response.body)['data'] as List)
          .map((e) => Visit.fromJson(e))
          .toList();
      // final newVisits = Visit.generateFakeVisits();

      final isLastPage = newVisits.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newVisits);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newVisits, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> refreshView() async => _pagingController.refresh();
}
