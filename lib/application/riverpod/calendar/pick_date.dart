enum PickDateType { single, range }

class PickDateModel {
  final PickDateType type;
  final DateTime start;
  final DateTime? end;
  PickDateModel({
    required this.type,
    required this.start,
    this.end,
  });

  factory PickDateModel.initial() =>
      PickDateModel(type: PickDateType.single, start: DateTime.now());

  PickDateModel single(DateTime date) =>
      copyWith(type: PickDateType.single, start: date);
  PickDateModel range(DateTime start, DateTime end) =>
      copyWith(type: PickDateType.range, start: start, end: end);

  PickDateModel nextDay() =>
      copyWith(start: DateTime(start.year, start.month, start.day + 1));

  PickDateModel prevDay() =>
      copyWith(start: DateTime(start.year, start.month, start.day - 1));

  PickDateModel copyWith({
    PickDateType? type,
    DateTime? start,
    DateTime? end,
  }) {
    return PickDateModel(
      type: type ?? this.type,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
