import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification {
  final String type;
  final String? title;
  final String? body;
  final bool viewed;

  Notification({
    required this.type,
    this.title,
    this.body,
    required this.viewed,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'],
      title: json['title'],
      body: json['body'],
      viewed: json['viewed'] == 0 ? false : true,
    );
  }

  String? get notificationTitle {
    switch (type) {
      case 'expired_subscription':
        return 'EXPIRED SUBSCRIPTION'.tr;
      default:
        return title;
    }
  }

  String? get notificationBody {
    switch (type) {
      case 'expired_subscription':
        return 'Your subscription has expired. Please renew your subscription to continue workout!'.tr;
      default:
        return body;
    }
  }

  IconData get notificationIcon {
    switch (type) {
      case 'expired_subscription':
        return Icons.warning_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get getIconColor {
    switch (type) {
      case 'expired_subscription':
        return Colors.red.shade400;
      default:
        return Colors.purple.shade400;
    }
  }
}
