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
