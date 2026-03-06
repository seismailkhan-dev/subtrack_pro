import 'package:flutter/material.dart';
import 'package:subtrack_pro/controllers/get_subscription_controller.dart';
import 'package:subtrack_pro/core/services/format_service.dart';
import 'package:subtrack_pro/core/services/loading_service.dart';
import 'package:subtrack_pro/core/constants/app_constants.dart';
import 'package:subtrack_pro/shared/widgets/custom_snack_bar.dart';
import 'package:uuid/uuid.dart';
import '../core/services/date_picker_service.dart';
import '../core/services/drift_service.dart';
import 'package:get/get.dart';
import '../data/models/subcription_model.dart';
import '../shared/bottom_sheets/success_bottom.dart';
import '../core/services/notification_service.dart';

class AddSubscriptionController extends GetxController {
  final DriftService _drift = DriftService();

  Rxn<SubscriptionDataModel> editingSubscription = Rxn<SubscriptionDataModel>();


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

  // Brand + Category colors
  // Default: light blue
  RxInt brandColor = 0xFF60A5FA.obs;
  RxInt categoryColor =
      AppConstants.categoryColorFor('Entertainment').toARGB32().obs;

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

  void initForEdit(SubscriptionDataModel sub) {
    editingSubscription.value = sub;
    subNameTextController.text = sub.name;
    priceTextController.text = sub.price.toString();
    notesTextController.text = sub.notes ?? '';
    startDateTextController.text = FormatService.ymd(sub.startDate);
    nextBillingDateTextController.text = FormatService.ymd(sub.nextBillingDate);
    
    currency.value = sub.currency;
    category.value = sub.category;
    autoRenew.value = sub.autoRenew;
    freeTrial.value = sub.freeTrial;
    reminderDays.value = sub.reminderDays;
    
    if (sub.billingCycle == 'weekly') {
      cycleIndex.value = 0;
    } else if (sub.billingCycle == 'monthly') {
      cycleIndex.value = 1;
    } else {
      cycleIndex.value = 2;
    }
    
    brandColor.value = sub.brandColor;
    categoryColor.value = sub.categoryColor;
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
    categoryColor.value = AppConstants.categoryColorFor(value).toARGB32();
  }
  void changeAutoRenew(bool value){
    autoRenew.value = value;
  }
  void changeFreeTrail(bool value){
    freeTrial.value = value;
  }
  void setBrandColor(Color color) {
    brandColor.value = color.toARGB32();
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
      LoadingService.show(message: editingSubscription.value == null ? 'Adding Subscription..' : 'Updating Subscription..');
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


      bool success = false;
      if (editingSubscription.value == null) {
        // Create new
        final sub = SubscriptionDataModel(
          subscriptionId: Uuid().v4(),
          name: subNameTextController.text,
          price: double.tryParse(priceTextController.text)??0,
          currency: currency.value,
          billingCycle: billingCycle,
          category: category.value,
          brandColor: brandColor.value,
          categoryColor: categoryColor.value,
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
        success = insertedId > 0;
        
        if (success) {
          final subWithId = sub.copyWith(id: insertedId);
          await NotificationService().scheduleNotification(subWithId);
          // TEST: Schedule 10 minutes from now
          // await NotificationService().testScheduleNotification(subWithId);
          
          // TEST: Add a mock sub for 5 days from now to test Upcoming Renewals
          final testSub = SubscriptionDataModel(
            subscriptionId: Uuid().v4(),
            name: 'Test Upcoming Sub',
            price: 9.99,
            currency: 'USD',
            billingCycle: 'monthly',
            category: 'Productivity',
            brandColor: 0xFFEF4444, // Red
            categoryColor: 0xFF10B981, // Green
            startDate: DateTime.now(),
            nextBillingDate: DateTime.now().add(const Duration(days: 5)),
            autoRenew: true,
            freeTrial: false,
            reminderDays: 3,
            notes: 'Test sub exactly 5 days from now',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isSynced: false,
          );
          await _drift.saveSubscription(testSub);
        }
      } else {
        // Update existing
        final existingSub = editingSubscription.value!;
        final sub = SubscriptionDataModel(
          id: existingSub.id, // Must pass DB generated ID to update
          userId: existingSub.userId,
          subscriptionId: existingSub.subscriptionId,
          name: subNameTextController.text,
          price: double.tryParse(priceTextController.text)??0,
          currency: currency.value,
          billingCycle: billingCycle,
          category: category.value,
          brandColor: brandColor.value,
          categoryColor: categoryColor.value,
          startDate: startDate,
          nextBillingDate: nextBillingDate,
          autoRenew: autoRenew.value,
          freeTrial: freeTrial.value,
          reminderDays: reminderDays.value,
          notes: notesTextController.text,
          createdAt: existingSub.createdAt, // Keep original creation date
          updatedAt: DateTime.now(), // update time
          isSynced: false, // Needs to be synced to Firebase again
        );
        success = await _drift.updateSubscription(sub);
        
        if (success && sub.id != null) {
          await NotificationService().cancelNotification(sub.id!);
          // Also cancel the test notification if it exists (using the +10000 offset we created)
          await NotificationService().cancelNotification(sub.id! + 10000);
          
          await NotificationService().scheduleNotification(sub);
          // TEST: Schedule 10 minutes from now
          // await NotificationService().testScheduleNotification(sub);
        }
      }
      
      LoadingService.hide();
      if (success) {

        try{
        await  GetSubscriptionsController.to.fetchSubscriptions();
        }catch(e){
          print(e);
        }
        showSuccessBottomSheet(context: context, title: editingSubscription.value == null ? 'Subscription has been added successfully' : 'Subscription has been updated successfully');
      } else {
        customSnackBar(
          "Error",
          "Failed to save subscription",
        );
      }
    }catch(e){
      print('Error saving sub: $e');
      customSnackBar('Error', e.toString());
      LoadingService.hide();
    }



  }
}