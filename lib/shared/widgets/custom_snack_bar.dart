import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customSnackBar(
    String title,
    String message, {
      bool isSuccess = false,
      bool isWarning = false,
    }) {
  if (Get.isSnackbarOpen) return;

  Color bgColor;
  IconData icon;

  if (isSuccess) {
    bgColor = Colors.green;
    icon = Icons.check_circle_rounded;
  } else if (isWarning) {
    bgColor = Colors.orange;
    icon = Icons.warning_amber_rounded;
  } else {
    bgColor = Colors.red.shade800;
    icon = Icons.error_rounded;
  }

  Get.snackbar(
    title,
    message,
    margin: EdgeInsets.zero,
    duration: const Duration(seconds: 2),
    backgroundColor: bgColor,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.GROUNDED,
    shouldIconPulse: true,
    icon: Icon(icon, color: Colors.white),
  );
}