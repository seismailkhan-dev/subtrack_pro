import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormatService {



  static String getUserInitials(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return 'N/A';

    List<String> parts =
    fullName.trim().split(' ').where((p) => p.isNotEmpty).toList();

    // Always take first and last initials (if available)
    String initials = parts.first[0].toUpperCase();
    if (parts.length > 1) {
      initials += parts.last[0].toUpperCase();
    }

    return initials;
  }


  // Format as YYYY-MM-DD (e.g., 2025-09-17)
  static String ymd(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format as YYYY-MM-DD (e.g., 2025-09-17)
  static String formatMMMM(DateTime date) {
    return DateFormat('MMMM').format(date);
  }
  static String formatYear(DateTime date) {
    return DateFormat('yyyy').format(date);
  }




  static Map<String, dynamic> cleanMap(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, cleanMap(value));
      } else if (value is List) {
        return MapEntry(
          key,
          value.map((e) {
            if (e is Timestamp) return e.toDate().toIso8601String();
            if (e is Map<String, dynamic>) return cleanMap(e);
            return e;
          }).toList(),
        );
      }
      return MapEntry(key, value);
    });
  }


 static DateTime? parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.parse(value);
    }

    throw Exception('Invalid date format');
    return null;
  }
}