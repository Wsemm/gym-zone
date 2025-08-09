import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

import '../styles/app_colors.dart';

SystemUiOverlayStyle appBarSystemStyle = const SystemUiOverlayStyle(
  statusBarColor: AppColors.primary,
  systemNavigationBarColor: Colors.white,
  statusBarBrightness: Brightness.light,
);

// Future checkForUpdate(BuildContext context) async {
//   // Using Upgrader package for version checking
//   // For now, we'll disable the update check to prevent blocking dialogs
//   // This can be re-enabled later when needed
//   return;

//   // Original implementation (commented out to prevent blocking)
//   // showDialog(
//   //   context: context,
//   //   barrierDismissible: false,
//   //   builder: (BuildContext context) {
//   //     return UpgradeAlert(
//   //       child: Container(),
//   //     );
//   //   },
//   // );
// }

Future<void> checkForUpdate(BuildContext context) async {
  // Get current app version
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  String? latestVersion;
  String? storeUrl;

  if (Platform.isAndroid) {
    final packageName = packageInfo.packageName;
    final response = await http.get(Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName&hl=en'));

    if (response.statusCode == 200) {
      final match = RegExp(r'(?<=<span class="htlgb">)([\d.]+)(?=</span>)')
          .allMatches(response.body)
          .map((m) => m.group(0))
          .where((v) => v != null && RegExp(r'^\d+\.\d+(\.\d+)?$').hasMatch(v!))
          .toList();

      if (match.isNotEmpty) {
        latestVersion = match.first;
        storeUrl = 'https://play.google.com/store/apps/details?id=$packageName';
      }
    }
  } else if (Platform.isIOS) {
    final bundleId = packageInfo.packageName;
    final response = await http
        .get(Uri.parse('https://itunes.apple.com/lookup?bundleId=$bundleId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['resultCount'] > 0) {
        latestVersion = data['results'][0]['version'];
        storeUrl = data['results'][0]['trackViewUrl'];
      }
    }
  }

  // Compare versions
  if (latestVersion != null &&
      _isVersionHigher(latestVersion, currentVersion)) {
    _showUpdateDialog(context, storeUrl);
  }
}

// Version comparison
bool _isVersionHigher(String latest, String current) {
  List<int> latestParts =
      latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  List<int> currentParts =
      current.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  for (int i = 0; i < latestParts.length; i++) {
    if (i >= currentParts.length || latestParts[i] > currentParts[i]) {
      return true;
    } else if (latestParts[i] < currentParts[i]) {
      return false;
    }
  }
  return false;
}

// Show dialog
void _showUpdateDialog(BuildContext context, String? storeUrl) {
  showDialog(
    context: context,
    barrierDismissible: false, // same as allowDismissal: false
    builder: (context) => AlertDialog(
      title: Text('New update for the Gym Zone app'.tr),
      content: Text(
          'A new version of the app is available! Please update for better performance and new features.'
              .tr),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Later'.tr),
        ),
        ElevatedButton(
          onPressed: () async {
            if (storeUrl != null && await canLaunch(storeUrl)) {
              await launch(storeUrl);
            }
          },
          child: Text('Update now'.tr),
        ),
      ],
    ),
  );
}
