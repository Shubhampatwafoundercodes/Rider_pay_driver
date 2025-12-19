import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatYMD(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }


  // Format input like "2025-07-28 06:55:41" to "July 24, 2025"
  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--";

    try {
      final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      final outputFormat = DateFormat("MMMM d, yyyy"); // e.g. July 24, 2025
      final dateTime = inputFormat.parse(dateStr);
      return outputFormat.format(dateTime);
    } catch (_) {
      return "--";
    }
  }

  // Existing time formatter for "HH:mm:ss" to "h:mm a"
  static String formatTimeAmPm(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "--";

    try {
      final inputFormat = DateFormat("HH:mm:ss");
      final outputFormat = DateFormat("h:mm a");
      final dateTime = inputFormat.parse(timeStr);
      return outputFormat.format(dateTime);
    } catch (_) {
      return "--";
    }
  }

  /// Format both date and time from full timestamp → "July 28, 2025 6:55 AM"
  // static String formatFullDateTime(dynamic dateTimeValue) {
  //   if (dateTimeValue == null) return "--";
  //
  //   try {
  //     DateTime dateTime;
  //
  //     if (dateTimeValue is DateTime) {
  //       // Already DateTime
  //       dateTime = dateTimeValue;
  //     } else if (dateTimeValue is String && dateTimeValue.isNotEmpty) {
  //       // ISO format → OK
  //       if (dateTimeValue.contains("T")) {
  //         dateTime = DateTime.parse(dateTimeValue).toLocal();
  //       }
  //       // Already formatted → try to parse manually
  //       else {
  //         try {
  //           dateTime = DateFormat("MMMM d, yyyy h:mm a").parse(dateTimeValue, true).toLocal();
  //         } catch (_) {
  //           // Fallback: return as-is if format not recognized
  //           return dateTimeValue;
  //         }
  //       }
  //     } else {
  //       return "--";
  //     }
  //
  //     final outputFormat = DateFormat("MMMM d, yyyy h:mm a");
  //     return outputFormat.format(dateTime);
  //   } catch (e) {
  //     debugPrint("🛑 Date parsing error: $e | Value: $dateTimeValue");
  //     return "--";
  //   }
  // }
  static String formatFullDateTime(dynamic value) {
    if (value == null) return "--";

    try {
      DateTime dateTime;

      // ✅ Firestore Timestamp
      if (value is Timestamp) {
        dateTime = value.toDate().toLocal();
      }
      // ✅ Already DateTime
      else if (value is DateTime) {
        dateTime = value.toLocal();
      }
      // ✅ String date
      else if (value is String && value.isNotEmpty) {
        String v = value.trim();

        // 🔥 Handle ISO / Z / UTC properly
        if (v.contains('T')) {
          dateTime = DateTime.parse(v).toLocal();
        } else {
          // Try common readable format
          try {
            dateTime =
                DateFormat("MMMM d, yyyy h:mm a").parse(v).toLocal();
          } catch (_) {
            return v; // fallback: show raw string
          }
        }
      } else {
        return "--";
      }

      // ✅ FINAL DISPLAY FORMAT
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      debugPrint("🛑 Date parse error: $e | Value: $value");
      return "--";
    }
  }

  /// Format only date from DateTime → "28 Jul 2025"
  static String formatShortDate(DateTime date) {
    return DateFormat("d MMM yyyy").format(date);
  }

  /// Format only time from DateTime → "6:55 AM"
  static String formatOnlyTime(DateTime time) {
    return DateFormat("h:mm a").format(time);
  }


  /// ⭐ New: Format future time from current time + seconds

  static String formatDropTime(int addSeconds) {
    final now = DateTime.now();
    final dropTime = now.add(Duration(seconds: addSeconds));
    return DateFormat("h:mm a").format(dropTime); // Example: 12:30 PM
  }
}
