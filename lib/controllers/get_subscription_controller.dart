import 'package:get/get.dart';

import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';


class GetSubscriptionsController extends GetxController{
  final DriftService _service = DriftService();
  static GetSubscriptionsController get to => Get.find();

  RxBool isFetchingHomeSub = true.obs;


  RxList<SubscriptionDataModel> homeSubListModel = <SubscriptionDataModel>[].obs;


  Future<void> fetchSubscriptions({int limit = 5}) async {

    isFetchingHomeSub(true);
    try{
      final subs = await _service.getSubscriptions();
      subs.sort((a, b) => b.startDate.compareTo(a.startDate));

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

  Future<void> deleteSubscription(int id) {
    return _service.deleteSubscription(id);
  }
}