// lib/services/firebase_service.dart
//
// All Firebase Auth + Firestore operations live here.
// The rest of the app treats Firebase as a remote sync target, not a source of truth.
// The source of truth is always the local Drift database.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/user_model.dart';



class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<User?> signUp({required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<User?> signIn({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  Future<void> signOut() => _auth.signOut();

  // ─── User Firestore ───────────────────────────────────────────────────────

  Future<void> ensureSignedInFromCache() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        // No cached session — do nothing
        return;
      }

      // Optionally reload to refresh token (safe)
      await user.reload();
    } catch (_) {
      // Swallow errors — background sync must never crash app
    }
  }

  /// Write (or overwrite) user document in Firestore.
  Future<void> saveUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));
  }

  /// Fetch user document from Firestore. Returns null if not found.
  Future<Map<String, dynamic>?> fetchUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }


}
