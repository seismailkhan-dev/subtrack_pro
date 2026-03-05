import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/services/drift_service.dart';
import 'package:get/get.dart';
import 'dart:math';

import '../data/models/subcription_model.dart';

class AddSubscriptionController extends GetxController {
  final DriftService _drift = DriftService();

  Future<void> addSubscription({
    required String name,
    required double price,
    required String currency,
    required String billingCycle,
    required String category,
    required DateTime startDate,
    required bool autoRenew,
    required int reminderDays,
    String? notes,
  }) async {


    // Compute nextBilling date based on billingCycle
    DateTime nextBilling = startDate;
    switch (billingCycle.toLowerCase()) {
      case 'weekly':
        nextBilling = startDate.add(const Duration(days: 7));
        break;
      case 'monthly':
        nextBilling = DateTime(startDate.year, startDate.month + 1, startDate.day);
        break;
      case 'yearly':
        nextBilling = DateTime(startDate.year + 1, startDate.month, startDate.day);
        break;
    }

    final sub = SubscriptionDataModel(
      id: Random().nextInt(1 << 31),
      subscriptionId: Uuid().v4(),
      name: name,
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      category: category,
      startDate: startDate,
      autoRenew: autoRenew,
      reminderDays: reminderDays,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _drift.saveSubscription(sub);
  }
}