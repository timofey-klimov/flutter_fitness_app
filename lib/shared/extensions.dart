import 'package:app/domain/activities/activity.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension DateTimeExtensin on DateTime {
  bool equals(DateTime dateTime) {
    return this.day == dateTime.day &&
        this.month == dateTime.month &&
        this.year == dateTime.year;
  }
}

extension NullStringExtension on String? {
  bool isValid() => this != null && this!.isNotEmpty;
}
