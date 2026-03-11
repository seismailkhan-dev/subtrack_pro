import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerService {

  Future<DateTime?> pickDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DatePickerMode? initialDatePickerMode,
  }) async {
    final DateTime now = DateTime.now();

    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2200),
      initialDatePickerMode: initialDatePickerMode ?? DatePickerMode.day,
    );
  }


  Future<int?> pickYear({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await pickDate(
      initialDatePickerMode: DatePickerMode.year,
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    return picked?.year;
  }



  Future<DateTime?> pickMonthYear({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await pickDate(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      return DateTime(picked.year, picked.month, 1);
    }
    return null;
  }


  Future<TimeOfDay?> pickTime({  required BuildContext context,}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // default time
    );
    return picked;
  }

  bool checkYMDIsAfterOrEqual({required String firstDate, required String lastDate}){
    DateTime date1 = DateTime.parse("$lastDate 00:00:00");
    DateTime date2 = DateTime.parse("$firstDate 00:00:00");

    if (date1.isAfter(date2) || date1.isAtSameMomentAs(date2)) {
      return true;
    }

    return false;
  }

  bool checkDMMMYYIsAfterOrEqual({required String firstDate, required String lastDate}) {
    final formatter = DateFormat('d-MMM-yy');

    DateTime date1 = formatter.parse(lastDate);   // lastDate
    DateTime date2 = formatter.parse(firstDate);  // firstDate

    // Compare
    return date1.isAfter(date2) || date1.isAtSameMomentAs(date2);
  }

  bool checkTimeOfDayIsAfterOrEqual({
    required String firstTime,
    required String lastTime,
  }) {
    DateTime parseTime(String time) {
      final formattedTime = time.trim().toUpperCase();
      final regExp = RegExp(r'^(\d{1,2}):(\d{2})\s?(AM|PM)$');
      final match = regExp.firstMatch(formattedTime);

      if (match == null) {
        throw const FormatException('Invalid time format. Use "hh:mm AM/PM"');
      }

      int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);
      final String period = match.group(3)!;

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    final firstDateTime = parseTime(firstTime);
    final lastDateTime = parseTime(lastTime);

    return firstDateTime.isBefore(lastDateTime) || firstDateTime.isAtSameMomentAs(lastDateTime);
  }


}
