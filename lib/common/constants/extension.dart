import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate {
    return DateFormat(
            Get.locale!.languageCode == 'en' ? 'yyyy-MM-dd' : 'yyyy-MM-dd')
        .format(this);
  }
}
