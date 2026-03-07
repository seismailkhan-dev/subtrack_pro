import 'package:get/get.dart';
import 'analytics_controller.dart';

import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';
import '../core/services/notification_service.dart';


class GetSubscriptionsController extends GetxController{
  final DriftService _service = DriftService();
  static GetSubscriptionsController get to => Get.find();

  RxBool isFetchingHomeSub = true.obs;


  RxList<SubscriptionDataModel> homeSubListModel = <SubscriptionDataModel>[].obs;
  RxList<SubscriptionDataModel> upcomingSubListModel = <SubscriptionDataModel>[].obs;
  
  RxDouble totalMonthlySpend = 0.0.obs;
  RxDouble totalYearlySpend = 0.0.obs;
  RxInt totalActiveSubs = 0.obs;

  final RxList<SubscriptionDataModel> allSubscriptions = <SubscriptionDataModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    allSubscriptions.bindStream(watchSubscriptions());
  }
  Future<void> fetchSubscriptions({int limit = 5}) async {
    isFetchingHomeSub(true);
    try{
      final subs = await _service.getSubscriptions();
      subs.sort((a, b) => b.startDate.compareTo(a.startDate));

      // Calculate totals BEFORE limiting for the home screen
      totalActiveSubs.value = subs.length;
      totalMonthlySpend.value = subs.fold(0.0, (sum, sub) => sum + sub.monthlyEquivalent);
      totalYearlySpend.value = subs.fold(0.0, (sum, sub) => sum + sub.yearlyEquivalent);

      homeSubListModel.value= [];
      homeSubListModel.addAll(subs.take(limit).toList());

      final upcoming = subs.where((s) => s.daysUntilRenewal <= 7 && s.daysUntilRenewal >= 0).toList()
        ..sort((a, b) => a.daysUntilRenewal.compareTo(b.daysUntilRenewal));
      upcomingSubListModel.value = upcoming;

      print('homeSubListModel ${homeSubListModel.length}');
    }catch(e){
      print('Error fetching home sub $e');
    }finally{
      isFetchingHomeSub(false);
    }
  }


  Stream<List<SubscriptionDataModel>> watchSubscriptions() {
    return _service.watchSubscriptions();
  }

  Future<void> deleteSubscription(int id) async {
    print('Deleting subscription with id: $id');
    try {
      // Optimistic UI update
      allSubscriptions.removeWhere((s) => s.id == id);
      homeSubListModel.removeWhere((s) => s.id == id);
      upcomingSubListModel.removeWhere((s) => s.id == id);

      await NotificationService().cancelNotification(id);
      await _service.deleteSubscription(id);
      
      // We don't necessarily need to call fetchSubscriptions() here 
      // because bindStream handles allSubscriptions and we've manually 
      // updated homeSubListModel/upcomingSubListModel.
      // But fetchSubscriptions updates counts and totals, so we should call it.
      await fetchSubscriptions();

      if (Get.isRegistered<AnalyticsController>()) {
        await AnalyticsController.to.fetchAnalyticsData();
      }
      print('Subscription deleted successfully');
    } catch (e) {
      print('Error deleting subscription: $e');
      fetchSubscriptions(); // Revert on error
      rethrow;
    }
  }
}