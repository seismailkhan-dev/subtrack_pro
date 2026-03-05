import 'package:get/get.dart';

import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';


class GetSubscriptionsController extends GetxController{
  final DriftService _service = DriftService();

  Future<List<SubscriptionDataModel>> getSubscriptions() {
    return _service.getSubscriptions();
  }

  Stream<List<SubscriptionDataModel>> watchSubscriptions() {
    return _service.watchSubscriptions();
  }

  Future<void> deleteSubscription(int id) {
    return _service.deleteSubscription(id);
  }
}