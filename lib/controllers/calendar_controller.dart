import 'package:get/get.dart';
import '../core/services/drift_service.dart';
import '../data/models/subcription_model.dart';

class CalendarController extends GetxController {
  final DriftService _service = DriftService();
  
  static CalendarController get to => Get.find();

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = DateTime.now().obs;
  
  final RxList<SubscriptionDataModel> allSubscriptions = <SubscriptionDataModel>[].obs;
  final RxList<SubscriptionDataModel> selectedDayEvents = <SubscriptionDataModel>[].obs;
  final RxList<SubscriptionDataModel> currentMonthEvents = <SubscriptionDataModel>[].obs;
  
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllSubscriptions(); // Initial fetch handles loading state
    allSubscriptions.bindStream(_service.watchSubscriptions());
    // Update derived lists whenever allSubscriptions changes
    ever(allSubscriptions, (_) {
      _updateSelectedDayEvents();
      _updateCurrentMonthEvents();
    });
  }

  Future<void> fetchAllSubscriptions() async {
    // This method is now mostly redundant but kept for any manual refreshes
    isLoading(true);
    try {
      final subs = await _service.getSubscriptions();
      allSubscriptions.assignAll(subs);
    } catch (e) {
      print('Error fetching subscriptions for calendar: $e');
    } finally {
      isLoading(false);
    }
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
    _updateSelectedDayEvents();
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    _updateCurrentMonthEvents();
  }

  List<SubscriptionDataModel> getEventsForDay(DateTime day) {
    return allSubscriptions.where((sub) {
      final nb = sub.nextBillingDate;
      return nb.day == day.day && nb.month == day.month && nb.year == day.year;
    }).toList();
  }

  void _updateSelectedDayEvents() {
    if (selectedDay.value == null) {
      selectedDayEvents.clear();
      return;
    }
    selectedDayEvents.assignAll(getEventsForDay(selectedDay.value!));
  }

  void _updateCurrentMonthEvents() {
    final month = focusedDay.value.month;
    final year = focusedDay.value.year;
    
    final events = allSubscriptions.where((sub) {
      final nb = sub.nextBillingDate;
      return nb.month == month && nb.year == year;
    }).toList();
    
    events.sort((a, b) => a.nextBillingDate.day.compareTo(b.nextBillingDate.day));
    currentMonthEvents.assignAll(events);
  }

  void selectToday() {
    final now = DateTime.now();
    onDaySelected(now, now);
  }
}
