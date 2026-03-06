import 'package:get/get.dart';

import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';
import '../core/services/notification_service.dart';


class GetSubscriptionsController extends GetxController{
  final DriftService _service = DriftService();
  static GetSubscriptionsController get to => Get.find();

  RxBool isFetchingHomeSub = true.obs;


  RxList<SubscriptionDataModel> homeSubListModel = <SubscriptionDataModel>[].obs;
  
  RxDouble totalMonthlySpend = 0.0.obs;
  RxDouble totalYearlySpend = 0.0.obs;
  RxInt totalActiveSubs = 0.obs;


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
    await NotificationService().cancelNotification(id);
    return _service.deleteSubscription(id);
  }
}