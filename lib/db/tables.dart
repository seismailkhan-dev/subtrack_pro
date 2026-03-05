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
  DateTimeColumn get startDate => dateTime()();
  BoolColumn get autoRenew => boolean().withDefault(const Constant(true))();
  IntColumn get reminderDays =>
      integer().withDefault(const Constant(3))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
}