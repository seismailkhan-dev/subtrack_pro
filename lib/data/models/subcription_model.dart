class SubscriptionDataModel {
  final int? id;
  final String name;
  final String? subscriptionId;
  final String? userId;
  final double price;
  final String currency;
  final String billingCycle;
  final String category;
  final DateTime startDate;
  final bool autoRenew;
  final int reminderDays;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  SubscriptionDataModel({
    this.id,
    this.subscriptionId,
    required this.name,
     this.userId,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    required this.autoRenew,
    required this.reminderDays,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  SubscriptionDataModel copyWith({
    int? id,
    String? name,
    String? subscriptionId,
    String? userId,
    double? price,
    String? currency,
    String? billingCycle,
    String? category,
    DateTime? startDate,
    bool? autoRenew,
    int? reminderDays,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return SubscriptionDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      autoRenew: autoRenew ?? this.autoRenew,
      reminderDays: reminderDays ?? this.reminderDays,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}