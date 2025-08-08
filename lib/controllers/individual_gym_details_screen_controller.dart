import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gym_zones/common/constants/api.dart';
import 'package:gym_zones/models/Individual_subscription_plan.dart';
import 'package:gym_zones/models/individual_gym.dart';
import 'package:gym_zones/models/user.dart';
import 'package:http/http.dart' as http;

class IndividualGymDetailsScreenController extends GetxController {
  User? _user;

  User? get user => _user;

  IndividualSubscriptionPlan? _plans;

  IndividualSubscriptionPlan? get plans => _plans;

  IndividualGym? _gym;

  IndividualGym? get gym => _gym;

  bool isLoading = false;
  Future<void> _fetchPlans() async {
    isLoading = true;
    update();
    final response = await http.get(
      Uri.parse('${Api.API_URL}subscription-plans-individual')
          .replace(queryParameters: {
        "gym_id": "${gym!.id}",
        "gender":
            "${_user != null ? user?.gender : GetStorage().read('gender')}"
      }),
    );

    if (response.statusCode == 200) {
      isLoading = false;

      final plansJson = jsonDecode(response.body);
      _plans = IndividualSubscriptionPlan.fromJson(plansJson);
    } else {
      isLoading = false;
      _plans = IndividualSubscriptionPlan(data: [MyNewData.fake()]);
      update();
    }

    update();
  }

  @override
  void onInit() async {
    _plans = IndividualSubscriptionPlan();
    final userInStorage = GetStorage().read('user');
    if (userInStorage != null) {
      _user = User.fromJson(userInStorage);
    }
    _gym = Get.arguments["individualGym"];
    await _fetchPlans();
    super.onInit();
  }
}
