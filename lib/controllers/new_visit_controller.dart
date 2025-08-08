import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../common/constants/api.dart';
import '../models/visit.dart';
import 'auth_controller.dart';

class NewVisitController extends GetxController {
  Future<Visit?> checkIn(String gymId) async {
    final response = await http.post(
      Uri.parse('${Api.API_URL}visits'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Get.find<AuthController>().token}',
      },
      body: {
        'gym_id': gymId,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Visit.fromJson(jsonDecode(response.body)['visit']);
    } else {
      return null;
    }
  } 
}