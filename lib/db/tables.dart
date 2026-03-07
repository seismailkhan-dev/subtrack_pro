// lib/db/tables.dart
//
// Defines the two Drift tables: UsersTable and ChildrenTable.
// These are the local SQLite schemas — they mirror the Firestore structure
// but add an `isSynced` flag to track what still needs uploading.

import 'package:drift/drift.dart';

class UsersTable extends Table {
  TextColumn get id => text()(); // Firebase UID
  TextColumn get name => text()();
  TextColumn get email => text()();
  BoolColumn get isPremiumUser => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  RealColumn get monthlyBudget => real().withDefault(const Constant(0.0))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}




class SubscriptionsTable extends Table {
  TextColumn get userId => text().nullable()(); // nullable for guest users
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get subscriptionId => text()();
  RealColumn get price => real()();
  TextColumn get currency => text()(); // USD, EUR, etc.
  TextColumn get billingCycle => text()(); // weekly, monthly, yearly
  TextColumn get category => text()(); // entertainment, productivity etc
  IntColumn get brandColor =>
      integer().withDefault(const Constant(0xFF60A5FA))(); // light blue
  IntColumn get categoryColor =>
      integer().withDefault(const Constant(0xFF6366F1))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextBillingDate => dateTime()();
  BoolColumn get autoRenew => boolean().withDefault(const Constant(true))();
  BoolColumn get freeTrial => boolean().withDefault(const Constant(false))();
  IntColumn get reminderDays =>
      integer().withDefault(const Constant(3))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastUsedDate => dateTime().nullable()();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
}