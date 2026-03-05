import 'package:flutter/material.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:uuid/uuid.dart';
import '../core/services/date_picker_service.dart';
import '../core/services/drift_service.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../data/models/subcription_model.dart';

class AddSubscriptionController extends GetxController {
  final DriftService _drift = DriftService();


  final subNameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final notesTextController = TextEditingController();
  final startDateTextController = TextEditingController();
  final endDateTextController = TextEditingController();

  RxString currency = 'USD'.obs;
  RxString category = 'Entertainment'.obs;
  RxBool autoRenew = false.obs;
  RxInt reminderDays = 3.obs;
  RxInt cycleIndex = 1.obs;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rxn<DateTime> endDate = Rxn<DateTime>();
  final currentDate = DateTime.now();

  RxBool isSaving = false.obs;


  @override
  void onInit() {
    super.onInit();
    startDateTextController.text = FormatService.ymd(currentDate);
    calculateEndDate();
  }


  void calculateEndDate() {
    final startDate = FormatService.parseYMD(startDateTextController.text);
    DateTime endDate;

    if (cycleIndex.value == 0) {
      // Weekly cycle (add 1 week)
      endDate = startDate.add(const Duration(days: 7));
    } else if (cycleIndex.value == 1) {
      // Monthly cycle (add 1 month safely)
      int newYear = startDate.year + ((startDate.month + 1 - 1) ~/ 12);
      int newMonth = ((startDate.month + 1 - 1) % 12) + 1;
      int lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
      int newDay = startDate.day > lastDayOfMonth ? lastDayOfMonth : startDate.day;

      endDate = DateTime(newYear, newMonth, newDay);
    } else {
      // Yearly cycle (add 1 year)
      int newYear = startDate.year + 1;
      int lastDayOfMonth = DateTime(newYear, startDate.month + 1, 0).day;
      int newDay = startDate.day > lastDayOfMonth ? lastDayOfMonth : startDate.day;

      endDate = DateTime(newYear, startDate.month, newDay);
    }

    print('endDate ${endDate}');
    // Update the end date controller
    endDateTextController.text = FormatService.ymd(endDate);
  }


  void changeCurrency(String value){
    currency.value = value;
  }
 void changeCycle(int value){
    cycleIndex.value = value;
    calculateEndDate();
  }
  void changeCategory(String value){
    category.value = value;
  }
  void changeAutoRenew(bool value){
    autoRenew.value = value;
  }
  void changeRemindDays(int value){
    reminderDays.value = value;
  }



  Future<void> selectDate(
      BuildContext context,bool isStartDate) async {
    final DateTime? picked = await DatePickerService().pickDate(context: context);
    if (picked != null) {
      if(isStartDate){
        startDateTextController.text = FormatService.ymd(picked);
        calculateEndDate();
      }else{
        endDateTextController.text = FormatService.ymd(picked);
      }
    }
  }



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