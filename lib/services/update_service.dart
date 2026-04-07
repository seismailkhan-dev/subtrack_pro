import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class UpdateService {
  static const String _skipKey = 'update_later_timestamp';

  static Future<Map<String, dynamic>?> checkForUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final skipTime = prefs.getInt(_skipKey);

    if (skipTime != null) {
      final skipDate = DateTime.fromMillisecondsSinceEpoch(skipTime);
      if (DateTime.now().difference(skipDate).inHours < 24) {
        return null;
      }
    }

    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 0),
      ));
      await remoteConfig.fetchAndActivate();

      final latestVersion = remoteConfig.getString('latest_version');
      final updateTitle = remoteConfig.getString('update_title');
      final updateFeatures = remoteConfig.getString('update_features');
      final forceUpdate = remoteConfig.getBool('force_update');

      if (latestVersion.isEmpty) return null;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_isNewer(latestVersion, currentVersion)) {
        return {
          'latest_version': latestVersion,
          'update_title': updateTitle,
          'update_features': updateFeatures,
          'force_update': forceUpdate,
        };
      }
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
    }

    return null;
  }

  static Future<void> remindTomorrow() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_skipKey, DateTime.now().millisecondsSinceEpoch);
  }

  static bool _isNewer(String latest, String current) {
    if (latest == current) return false;
    
    final latestParts = latest.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    
    final maxLength = latestParts.length > currentParts.length ? latestParts.length : currentParts.length;
    
    for (int i = 0; i < maxLength; i++) {
      final latestPart = i < latestParts.length ? latestParts[i] : 0;
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      
      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }
    
    return false;
  }
}
