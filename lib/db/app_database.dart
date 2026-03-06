// lib/db/app_database.dart
//
// The central Drift database class. All local reads/writes go through here.
//
// Why Drift?
//  - Type-safe SQL queries generated at compile time
//  - Works fully offline — data is persisted to device storage
//  - Easy migrations and reactive streams
//
// Run code generation once after any table change:
//   flutter pub run build_runner build --delete-conflicting-outputs

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

// The part directive links the generated file produced by drift_dev.
part 'app_database.g.dart';

/// Top-level accessor — use AppDatabase.instance everywhere.
/// Using a singleton avoids opening multiple connections to the same file.
AppDatabase? _instance;

@DriftDatabase(tables: [SubscriptionsTable, UsersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(subscriptionsTable, subscriptionsTable.brandColor);
            await m.addColumn(
                subscriptionsTable, subscriptionsTable.categoryColor);
          }
        },
      );

  Future<void> upsertUser(UsersTableCompanion user) =>
      into(usersTable).insertOnConflictUpdate(user);

  /// Load the locally stored user by Firebase UID.
  Future<UsersTableData?> getUser(String uid) =>
      (select(usersTable)..where((t) => t.id.equals(uid))).getSingleOrNull();

  /// Mark user as synced after Firestore write succeeds.
  Future<void> markUserSynced(String uid) =>
      (update(usersTable)..where((t) => t.id.equals(uid)))
          .write(const UsersTableCompanion(isSynced: Value(true)));



  // INSERT subscription
  Future<int> insertSubscription(SubscriptionsTableCompanion sub) =>
      into(subscriptionsTable).insert(sub);

  // UPDATE subscription
  Future<bool> updateSubscription(SubscriptionsTableCompanion sub) =>
      update(subscriptionsTable).replace(sub);

  // DELETE subscription
  Future<int> deleteSubscription(int id) =>
      (delete(subscriptionsTable)..where((t) => t.id.equals(id))).go();

  // GET ALL subscriptions
  Future<List<SubscriptionsTableData>> getAllSubscriptions() =>
      select(subscriptionsTable).get();

  // WATCH subscriptions (reactive UI)
  Stream<List<SubscriptionsTableData>> watchSubscriptions() =>
      select(subscriptionsTable).watch();


}

/// Opens (or creates) the SQLite database file on the device.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
