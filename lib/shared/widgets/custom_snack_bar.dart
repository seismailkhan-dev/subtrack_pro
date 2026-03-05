import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customSnackBar(String titleTxt, String msg ,{bool isSuccess = false}) {
  if (Get.isSnackbarOpen) return;

  Get.snackbar(
    titleTxt,
    msg,
    margin: const EdgeInsets.all(0),
    duration: const Duration(seconds: 2),
    backgroundColor: isSuccess
        ? Colors.green
        : Colors.red[800],
    colorText: Colors.white,
    icon: const Icon(
      Icons.info,
      color: Colors.white,
    ),
    snackPosition: SnackPosition.BOTTOM,
    snackStyle: SnackStyle.GROUNDED,
    shouldIconPulse: true,
  );
}
