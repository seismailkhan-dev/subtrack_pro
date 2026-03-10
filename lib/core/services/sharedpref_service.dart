import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  factory SharedPrefService() => _instance;
  SharedPrefService._internal();

  static late SharedPreferences _prefs;

  /// CALL THIS FIRST IN main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String keyLoggedIn = 'isLoggedIn';
  static const String keyHasLoggedInBefore = 'hasLoggedInBefore';
  static const String loggedInTime = 'loggedInTime';
  static const String isSkipOnboarding = 'isSkipOnboarding';
  static const String isGuestUser = 'isGuestUser';
  static const String isNotificationsEnabled = 'isNotificationsEnabled';

  // ================= NOTIFICATIONS FLAG =================
  static Future<void> saveIsNotificationsEnabled(bool value) async {
    await _prefs.setBool(isNotificationsEnabled, value);
  }

  static bool getIsNotificationsEnabled() =>
      _prefs.getBool(isNotificationsEnabled) ?? true;

  // ================= LOGIN FLAG =================
  static Future<void> saveIsLoggedIn(bool value) async {
    await _prefs.setBool(keyLoggedIn, value);
  }

  static bool getIsLoggedIn() => _prefs.getBool(keyLoggedIn) ?? false;

  static Future<void> saveHasIsLoggedInBefore() async {
    await _prefs.setBool(keyHasLoggedInBefore, true);
  }

  static bool getHasLoggedInBefore() =>
      _prefs.getBool(keyHasLoggedInBefore) ?? false;

  static Future<void> saveIsSkipOnboarding() async {
    await _prefs.setBool(isSkipOnboarding, true);
  }

  static bool getIsSkipOnboarding() =>
      _prefs.getBool(isSkipOnboarding) ?? false;

  static Future<void> saveIsGuestUser(bool value) async {
    await _prefs.setBool(isGuestUser, value);
  }

  static bool getIsGuestUser() => _prefs.getBool(isGuestUser) ?? false;

  // ================= LOGIN Time =================
  static Future<void> saveLoggedInTime() async {
    await _prefs.setString(loggedInTime, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLoggedInTime() async {
    final dateString = _prefs.getString(loggedInTime);
    if (dateString == null) return null;
    return DateTime.parse(dateString);
  }

  // ================= CLEAR =================
  static Future<void> clear() async {
    await _prefs.clear();
    await saveHasIsLoggedInBefore();
    await saveIsSkipOnboarding();
  }
}
