// lib/services/sync_service.dart
//
// ════════════════════════════════════════════════════════════
//  SYNC LOGIC — the heart of the offline-first architecture
// ════════════════════════════════════════════════════════════
//
// Offline-first rule:
//   1. WRITE to Drift first (always, even when online).
//   2. THEN attempt to push to Firestore.
//   3. On success, mark the local row as isSynced = true.
//   4. On app start or reconnect, sweep unsynced rows and retry.
//
// This guarantees the app works with no network,
// and data eventually reaches Firestore when connectivity returns.

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/user_model.dart';
import 'drift_service.dart';
import 'firebase_service.dart';

class SyncService {
  final FirebaseService _firebase;
  final DriftService _drift;

  SyncService({required FirebaseService firebase, required DriftService drift})
      : _firebase = firebase,
        _drift = drift;

  /// Returns true if the device currently has any network access.
  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ─── User Sync ────────────────────────────────────────────────────────────

  /// Called after sign-up/sign-in:
  ///   1. Save user locally (isSynced = false)
  ///   2. If online, push to Firestore + mark synced
  ///   3. Pull any existing Firestore children and merge locally
  Future<void> syncUserOnLogin(UserModel user) async {
    // Step 1 — persist locally first (offline-safe)
    // await _drift.saveUser(user);
    //
    // if (!await isOnline) return; // done; sync will happen later
    //
    // // Step 2 — push user to Firestore
    // await _firebase.saveUser(user);
    // await _drift.markUserSynced(user.id??'');
    //
    // // Step 3 — pull Firestore children and merge into local DB
    // //  (important for multi-device scenarios: user logs in on a new device)
    // // await _mergeRemoteChildren(user.id??'');
  }

  /// Pull children from Firestore and insert any that don't exist locally.
  // Future<void> _mergeRemoteChildren(String userId) async {
  //   final remoteChildren = await _firebase.fetchChildren(userId);
  //
  //   for (final data in remoteChildren) {
  //     final child = ChildModel(
  //       firebaseId: data['firebaseId'] as String,
  //       userId: userId,
  //       name: data['name'] as String,
  //       birthDate: data['birthDate'] as String,
  //       gender: data['gender'] as String,
  //       createdAt: DateTime.parse(data['createdAt'] as String),
  //       isSynced: true,
  //     );
  //     // insertChild will store the child; duplicate checks are omitted for
  //     // brevity — in production you'd check firebaseId first.
  //     await _drift.insertChild(child);
  //   }
  // }

  // ─── Child Sync ───────────────────────────────────────────────────────────

  /// Called after a child is saved locally.
  /// If online, immediately push to Firestore and mark as synced.
  // Future<void> trySyncChild(String userId, ChildModel child) async {
  //   if (!await isOnline) return; // will be retried in syncPendingData()
  //
  //   final firebaseId = await _firebase.saveChild(userId: userId, child: child);
  //   await _drift.markChildSynced(child.localId!, firebaseId);
  // }

  // ─── Startup Sweep ────────────────────────────────────────────────────────

  /// Called on every app start (from AuthController).
  /// Finds all rows with isSynced = false and attempts to upload them.
  /// This is the "eventually consistent" guarantee — even after a crash or
  /// extended offline period, data will reach Firestore on next launch.
  Future<void> syncPendingData(String userId) async {
    if (!await isOnline) return;

    // final unsyncedChildren = await _drift.getUnsyncedChildren(userId);
    //
    // for (final child in unsyncedChildren) {
    //   try {
    //     final firebaseId =
    //         await _firebase.saveChild(userId: userId, child: child);
    //     await _drift.markChildSynced(child.localId!, firebaseId);
    //   } catch (e) {
    //     // Swallow per-record errors — will retry next time
    //     print('Sync failed for child ${child.localId}: $e');
    //   }
    // }
  }
}
