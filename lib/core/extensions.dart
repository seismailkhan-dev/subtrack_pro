import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../data/models/subcription_model.dart';

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
      'brandColor': brandColor,
      'categoryColor': categoryColor,
      'startDate': Timestamp.fromDate(startDate),
      'nextBillingDate': Timestamp.fromDate(nextBillingDate),
      'autoRenew': autoRenew,
      'freeTrial': freeTrial,
      'reminderDays': reminderDays,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isSynced': true, // mark as synced on upload
    };
  }
}

extension FirebaseToSubscriptionDataModel on Map<String, dynamic> {
  SubscriptionDataModel toSubscription() {
    final category = (this['category'] as String?) ?? 'Other';
    return SubscriptionDataModel(
      id: this['id'],
      subscriptionId: this['subscriptionId'],
      userId: this['userId'],
      name: this['name'],
      price: (this['price'] as num).toDouble(),
      currency: this['currency'],
      billingCycle: this['billingCycle'],
      category: category,
      brandColor: (this['brandColor'] as int?) ?? 0xFF60A5FA,
      categoryColor: (this['categoryColor'] as int?) ??
          AppConstants.categoryColorFor(category).toARGB32(),
      startDate: (this['startDate'] as Timestamp).toDate(),
      nextBillingDate: (this['nextBillingDate'] as Timestamp).toDate(),
      autoRenew: this['autoRenew'],
      freeTrial: this['freeTrial'],
      reminderDays: this['reminderDays'],
      notes: this['notes'],
      createdAt: (this['createdAt'] as Timestamp).toDate(),
      updatedAt: (this['updatedAt'] as Timestamp).toDate(),
      isSynced: this['isSynced'] ?? true,
    );
  }
}