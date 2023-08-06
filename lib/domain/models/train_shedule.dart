import 'dart:convert';

enum TrainScheduleTypes { one_time, every_week }

class TrainSchedule {
  final String sample_id;
  final TrainScheduleTypes shedule_type;
  TrainSchedule({
    required this.sample_id,
    required this.shedule_type,
  });

  Map<String, dynamic> toMap() {
    return {
      'sample_id': sample_id,
      'shedule_type': shedule_type.toString(),
    };
  }

  factory TrainSchedule.fromMap(Map<String, dynamic> map) {
    return TrainSchedule(
      sample_id: map['sample_id'] ?? '',
      shedule_type: createSheduleType(map['shedule_type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainSchedule.fromJson(String source) =>
      TrainSchedule.fromMap(json.decode(source));

  static createSheduleType(String json) {
    for (var el in TrainScheduleTypes.values) {
      if (el.toString() == json) {
        return el;
      }
    }
    throw new Error();
  }
}
