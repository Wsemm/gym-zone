import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/app_colors.dart';


class RebiMessage {
  RebiMessage({
    required String msg,
    Color bgColor = Colors.green,
    Color? textColor,
    String webBgColor = 'green',
    bool normalToast = true,
    String? title,
  }) {
    if (normalToast) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // AlertController.show('', msg, TypeAlert.success);
    }
  }

  RebiMessage.success({
    required String msg,
    bool normalToast = true,
    String? title,
  }) {
    if (normalToast) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // AlertController.show(title ?? 'Success'.tra, msg, TypeAlert.success);
    }
  }

  RebiMessage.error({
    required String msg,
    bool normalToast = true,
    String? title,
  }) {
    if (normalToast) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      // AlertController.show(title ?? 'Error'.tra, msg, TypeAlert.error);
    }
  }

  RebiMessage.warning({
    required String msg,
    bool normalToast = true,
    String? title,
  }) {
    if (normalToast) {
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // AlertController.show(title ?? 'Warning'.tra, msg, TypeAlert.warning);
    }
  }
}
