import 'package:flutter/material.dart';

class SubscriptionDataModel {
  final int? id;
  final String name;
  final String subscriptionId;
  final String? userId;
  final double price;
  final String currency;
  final String billingCycle;
  final String category;
  final int brandColor;
  final int categoryColor;
  final DateTime startDate;
  final DateTime nextBillingDate;
  final bool autoRenew;
  final bool freeTrial;
  final int reminderDays;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final DateTime? lastUsedDate;

  SubscriptionDataModel({
    this.id,
    required this.subscriptionId,
    required this.name,
     this.userId,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.category,
    required this.brandColor,
    required this.categoryColor,
    required this.startDate,
    required this.autoRenew,
    required this.freeTrial,
    required this.reminderDays,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced, required this.nextBillingDate,
    this.lastUsedDate,
  });

  Color get brandColorAsColor => Color(brandColor);
  Color get categoryColorAsColor => Color(categoryColor);

  bool get isTrialActive {
    if (!freeTrial) return false;
    final now = DateTime.now();
    // Trial is active if it hasn't reached the next billing date yet
    return now.isBefore(nextBillingDate);
  }

  double get monthlyEquivalent {
    if (billingCycle == 'weekly') return price * 4.3333;
    if (billingCycle == 'yearly') return price / 12;
    return price; // monthly default
  }

  double get yearlyEquivalent {
    if (billingCycle == 'weekly') return price * 52;
    if (billingCycle == 'monthly') return price * 12;
    return price; // yearly default
  }

  int get daysUntilRenewal {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final billing = DateTime(nextBillingDate.year, nextBillingDate.month, nextBillingDate.day);
    return billing.difference(today).inDays;
  }

  SubscriptionDataModel copyWith({
    int? id,
    String? name,
    String? subscriptionId,
    String? userId,
    double? price,
    String? currency,
    String? billingCycle,
    String? category,
    int? brandColor,
    int? categoryColor,
    DateTime? startDate,
    DateTime? nextBillingDate,
    bool? autoRenew,
    bool? freeTrial,
    int? reminderDays,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    DateTime? lastUsedDate,
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
      brandColor: brandColor ?? this.brandColor,
      categoryColor: categoryColor ?? this.categoryColor,
      startDate: startDate ?? this.startDate,
      autoRenew: autoRenew ?? this.autoRenew,
      freeTrial: freeTrial ?? this.freeTrial,
      reminderDays: reminderDays ?? this.reminderDays,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced, 
      nextBillingDate: nextBillingDate?? this.nextBillingDate,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
    );
  }
}