


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

Future checkForUpdate(BuildContext context) async {
  // Using Upgrader package for version checking
  // For now, we'll disable the update check to prevent blocking dialogs
  // This can be re-enabled later when needed
  return;
  
  // Original implementation (commented out to prevent blocking)
  // showDialog(
  //   context: context,
  //   barrierDismissible: false,
  //   builder: (BuildContext context) {
  //     return UpgradeAlert(
  //       child: Container(),
  //     );
  //   },
  // );
}