import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionDataModel {
  final int? id;
  final String name;
  final String subscriptionId;
  final String? userId;
  final double price;
  final String currency;
  final String billingCycle;
  final String category;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final bool autoRenew;
  final bool freeTrial;
  final int reminderDays;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  SubscriptionDataModel({
    this.id,
    required this.subscriptionId,
    required this.name,
     this.userId,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.startDate,
    required this.autoRenew,
    required this.freeTrial,
    required this.reminderDays,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced, required this.nextBillingDate,
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
    DateTime? nextBillingDate,
    bool? autoRenew,
    bool? freeTrial,
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
      freeTrial: freeTrial ?? this.freeTrial,
      reminderDays: reminderDays ?? this.reminderDays,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced, nextBillingDate: nextBillingDate?? this.nextBillingDate,
    );
  }
}


extension SubscriptionDataModelFirebase on SubscriptionDataModel {
  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'subscriptionId': subscriptionId,
      'userId': userId,
      'name': name,
      'price': price,
      'currency': currency,
      'billingCycle': billingCycle,
      'category': category,
      'startDate': Timestamp.fromDate(startDate),
      'nextBillingDate': Timestamp.fromDate(nextBillingDate),
      'autoRenew': autoRenew,
      'reminderDays': reminderDays,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isSynced': true, // mark as synced on upload
    };
  }
}