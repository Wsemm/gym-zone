import 'package:get/get.dart';

class SubscriptionPlan {
  final int id;
  final double amount;
  final int months;
  final int? savingPercent;
  final String hexColor;

  SubscriptionPlan({
    required this.id,
    required this.amount,
    required this.months,
    this.savingPercent,
    required this.hexColor,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      amount: double.parse(json['amount']),
      months: json['months'],
      savingPercent: json['saving_percent'],
      hexColor: json['hex_color'],
    );
  }

  String get durationText {
    if (months == 12) {
      return Get.locale!.languageCode == 'en'
          ? 'Yearly Subscription'
          : 'اشتراك سنوي';
    } else {
      if (Get.locale!.languageCode == 'en') {
        return '$months Month${months > 1 ? 's' : ''}';
      } else {
        if (months == 1) {
          return 'شهر واحد';
        } else if (months == 2) {
          return 'شهران';
        } else if (months >= 3 && months <= 10) {
          return '$months أشهر';
        } else {
          return '$months شهر';
        }
      }
    }
  }
}
