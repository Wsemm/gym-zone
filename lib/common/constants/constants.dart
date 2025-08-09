import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/app_colors.dart';

SystemUiOverlayStyle appBarSystemStyle = const SystemUiOverlayStyle(
  statusBarColor: AppColors.primary,
  systemNavigationBarColor: Colors.white,
  statusBarBrightness: Brightness.light,
);

Future<void> checkForUpdate(
  BuildContext context, {
  bool forceShowForTesting = false,
  bool isMandatoryUpdate = false,
}) async {
  // Create upgrader instance with platform-specific store configuration
  final upgrader = Upgrader(
    debugLogging: true,
    debugDisplayAlways: forceShowForTesting, // Set to false for production
    messages: CustomUpgraderMessages(),
    storeController: UpgraderStoreController(
      onAndroid: () => UpgraderPlayStore(),
      oniOS: () => UpgraderAppStore(),
    ),
  );

  // Wait for the current build to complete before checking
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // Check if update is needed
    if (upgrader.shouldDisplayUpgrade()) {
      _showUpgradeDialog(context, upgrader, isMandatoryUpdate);
    }
  });
}

void _showUpgradeDialog(
    BuildContext context, Upgrader upgrader, bool isMandatory) {
  showDialog(
    context: context,
    barrierDismissible: !isMandatory, // Can't dismiss if mandatory
    builder: (BuildContext dialogContext) {
      final String? appStoreVersion = upgrader.currentAppStoreVersion;
      final String? installedVersion = upgrader.currentInstalledVersion;

      return WillPopScope(
        onWillPop: () async => !isMandatory, // Prevent back button if mandatory
        child: AlertDialog(
          title: Text(isMandatory
              ? 'Critical Update Required'.tr
              : 'New update for the Gym Zone app'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMandatory) ...[
                Text(
                  'This update is required to continue using the app. Please update now to access all features.'
                      .tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ] else ...[
                Text(
                    'A new version of the app is available! Please update for better performance and new features.'
                        .tr),
              ],
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isMandatory)
                  TextButton(
                    onPressed: () {
                      // Close the app
                      exit(0);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text('Exit App'.tr),
                  )
                else
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text('Later'.tr),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Platform-specific store navigation
                    _openAppStore();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: isMandatory ? Colors.red : null,
                  ),
                  child: Text('Update now'.tr),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

// Platform-specific store navigation using existing URLs
void _openAppStore() async {
  late String storeUrl;

  if (Platform.isAndroid) {
    storeUrl =
        'https://play.google.com/store/apps/details?id=com.pixllmall.gym_zones';
  } else if (Platform.isIOS) {
    storeUrl = 'https://apps.apple.com/om/app/id6472092672';
  } else {
    return;
  }

  try {
    if (await canLaunchUrl(Uri.parse(storeUrl))) {
      await launchUrl(
        Uri.parse(storeUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {}
  } catch (e) {
    print('Error opening store: $e');
  }
}

// Custom messages class for localization
class CustomUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'New update for the Gym Zone app'.tr;

  @override
  String get body =>
      'A new version of the app is available! Please update for better performance and new features.'
          .tr;

  @override
  String get buttonTitleUpdate => 'Update now'.tr;

  @override
  String get buttonTitleLater => 'Later'.tr;

  @override
  String get buttonTitleIgnore => '';
}
