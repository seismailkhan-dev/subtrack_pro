import 'package:drift/drift.dart';

import '../../data/models/subcription_model.dart';
import '../../data/models/user_model.dart';
import '../../db/app_database.dart';

class DriftService {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> saveUser(UserModel user) => _db.upsertUser(
    UsersTableCompanion(
      id: Value(user.id),
      name: Value(user.name),
      email: Value(user.email),
      isPremiumUser: Value(user.isPremiumUser),
      createdAt: Value(user.createdAt),
      updatedAt: Value(user.updatedAt),
      isSynced: Value(user.isSynced),
    ),
  );

  Future<UserModel?> getUser(String uid) async {
    final row = await _db.getUser(uid);
    if (row == null) return null;
    return UserModel(
      id: row.id,
      name: row.name,
      email: row.email,
      isPremiumUser: row.isPremiumUser,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
    );
  }


  Future<UserModel?> getLastLoggedInUser() async {
    final rows = await _db.select(_db.usersTable).get();
    if (rows.isEmpty) return null;

    final row = rows.first; // single-user app
    return UserModel(
      id: row.id,
      name: row.name,
      email: row.email,
      isPremiumUser: row.isPremiumUser,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
    );
  }


  Future<UserModel?> getUserByEmail(String email) async {
    final row = await (_db.select(_db.usersTable)
      ..where((t) => t.email.equals(email)))
        .getSingleOrNull();

    if (row == null) return null;

    return UserModel(
      id: row.id,
      name: row.name,
      email: row.email,
      isPremiumUser: row.isPremiumUser,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isSynced: row.isSynced,
    );
  }



  Future<int> saveSubscription(SubscriptionDataModel sub) {
    return _db.insertSubscription(
      SubscriptionsTableCompanion(
        id: Value.absent(),
        userId: Value(sub.userId),
        subscriptionId: Value(sub.subscriptionId),
        name: Value(sub.name),
        price: Value(sub.price),
        currency: Value(sub.currency),
        billingCycle: Value(sub.billingCycle),
        category: Value(sub.category),
        startDate: Value(sub.startDate),
        nextBillingDate: Value(sub.nextBillingDate),
        autoRenew: Value(sub.autoRenew),
        freeTrial: Value(sub.freeTrial),
        reminderDays: Value(sub.reminderDays),
        notes: Value(sub.notes),
        createdAt: Value(sub.createdAt),
        updatedAt: Value(sub.updatedAt),
        isSynced: Value(sub.isSynced),
      ),
    );
  }

  Future<List<SubscriptionDataModel>> getSubscriptions() async {
    final data = await _db.getAllSubscriptions();

    return data.map((e) {
      return SubscriptionDataModel(
        userId: e.userId,
        id: e.id,
        name: e.name,
        subscriptionId: e.subscriptionId,
        price: e.price,
        currency: e.currency,
        billingCycle: e.billingCycle,
        category: e.category,
        startDate: e.startDate,
        nextBillingDate: e.nextBillingDate,
        autoRenew: e.autoRenew,
        freeTrial: e.freeTrial,
        reminderDays: e.reminderDays,
        notes: e.notes,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        isSynced: e.isSynced,
      );
    }).toList();
  }

  Stream<List<SubscriptionDataModel>> watchSubscriptions() {
    return _db.watchSubscriptions().map(
          (rows) => rows
          .map(
            (e) => SubscriptionDataModel(
          userId: e.userId,
          id: e.id,
          name: e.name,
              subscriptionId: e.subscriptionId,
              price: e.price,
          currency: e.currency,
          billingCycle: e.billingCycle,
          category: e.category,
          startDate: e.startDate,
              nextBillingDate: e.nextBillingDate,
          autoRenew: e.autoRenew,
          freeTrial: e.freeTrial,
          reminderDays: e.reminderDays,
          notes: e.notes,
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
          isSynced: e.isSynced,
        ),
      )
          .toList(),
    );
  }

  Future<void> deleteSubscription(int id) {
    return _db.deleteSubscription(id);
  }
}