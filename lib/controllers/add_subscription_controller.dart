import 'package:flutter/material.dart';
import 'package:subtrack_pro/controllers/get_subscription_controller.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/core/services/loading_service.dart';
import 'package:subtrack_pro/shared/widgets/custom_snack_bar.dart';
import 'package:uuid/uuid.dart';
import '../core/services/date_picker_service.dart';
import '../core/services/drift_service.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../data/models/subcription_model.dart';
import '../shared/bottom_sheets/success_bottom.dart';

class AddSubscriptionController extends GetxController {
  final DriftService _drift = DriftService();


  final subNameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final notesTextController = TextEditingController();
  final startDateTextController = TextEditingController();
  final nextBillingDateTextController = TextEditingController();

  RxString currency = 'USD'.obs;
  RxString category = 'Entertainment'.obs;
  RxBool autoRenew = true.obs;
  RxBool freeTrial = false.obs;
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
    calculateNextBillingDate();
  }


  void calculateNextBillingDate() {
    final startDate = FormatService.parseYMD(startDateTextController.text);
    DateTime nextBillingDate;

    if (cycleIndex.value == 0) {
      nextBillingDate = startDate.add(const Duration(days: 7));
    } else if (cycleIndex.value == 1) {
      nextBillingDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
    } else {
      nextBillingDate = DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
    nextBillingDateTextController.text = FormatService.ymd(nextBillingDate);
  }


  void changeCurrency(String value){
    currency.value = value;
  }
 void changeCycle(int value){
    cycleIndex.value = value;
    calculateNextBillingDate();
  }
  void changeCategory(String value){
    category.value = value;
  }
  void changeAutoRenew(bool value){
    autoRenew.value = value;
  }
  void changeFreeTrail(bool value){
    freeTrial.value = value;
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
        calculateNextBillingDate();
      }else{
        nextBillingDateTextController.text = FormatService.ymd(picked);
      }
    }
  }



  Future<void> addSubscription({required BuildContext context}) async {

    try{
      LoadingService.show(message: 'Adding Subscription..');
      String billingCycle =' ';
      if(cycleIndex.value==0){
        billingCycle = 'weekly';
      }else if(cycleIndex.value==1){
        billingCycle = 'monthly';
      }else{
        billingCycle = 'yearly';
      }

      final startDate = FormatService.parseYMD(startDateTextController.text);
      final nextBillingDate = FormatService.parseYMD(nextBillingDateTextController.text);


      final sub = SubscriptionDataModel(
        subscriptionId: Uuid().v4(),
        name: subNameTextController.text,
        price: double.tryParse(priceTextController.text)??0,
        currency: currency.value,
        billingCycle: billingCycle,
        category: category.value,
        startDate: startDate,
        nextBillingDate: nextBillingDate,
        autoRenew: autoRenew.value,
        freeTrial: freeTrial.value,
        reminderDays: reminderDays.value,
        notes: notesTextController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      final insertedId = await _drift.saveSubscription(sub);
      LoadingService.hide();
      if (insertedId > 0) {

        try{
        await  GetSubscriptionsController.to.fetchSubscriptions();
        }catch(e){
          print(e);
        }
        showSuccessBottomSheet(context: context, title: 'Subscription has been added successfully');
      } else {
        customSnackBar(
          "Error",
          "Failed to add subscription",
        );
      }
    }catch(e){
      print('Error saving sub: $e');
      customSnackBar('Error', e.toString());
      LoadingService.hide();
    }



  }
}