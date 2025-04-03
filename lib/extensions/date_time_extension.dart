import 'package:cloud_firestore/cloud_firestore.dart';

extension DateTimeExtensions on DateTime {
  DateTime atStartOfDay() {
    return DateTime(year, month, day);
  }

  bool isSameDayAsTimestamp(Timestamp other) {
    DateTime otherDateTime = other.toDate();
    return year == otherDateTime.year && month == otherDateTime.month && day == otherDateTime.day;
  }
}
