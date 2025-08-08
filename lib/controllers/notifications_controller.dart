import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common/constants/api.dart';
import '../models/notification.dart';
import 'auth_controller.dart';

class NotificationsController extends GetxController {
  List<Notification>? _notificationsList;

  List<Notification>? get notificationsList => _notificationsList;

  @override
  void onInit() {
    _fetchNotifications();
    super.onInit();
  }

  void _fetchNotifications() async {
    final response = await http.get(
      Uri.parse('${Api.API_URL}notifications'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
    );

    if (response.statusCode == 200) {
      final notificationsJson = jsonDecode(response.body) as List;
      _notificationsList =
          notificationsJson.map((e) => Notification.fromJson(e)).toList();
      update();
    } else {
      // Error
    }
  }
}
