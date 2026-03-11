import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

class LoadingService {

  static void show({String? message}) {

    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false, // cannot close by tapping outside
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message ?? "Loading...",
                    // style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
                   
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hide loading dialog
  static void hide() {
    Get.back(); 
  }

}
