import 'dart:convert';

import 'package:app/domain/models/train_sample.dart';
import 'package:equatable/equatable.dart';

enum TrainScheduleTypes { one_time, every_week }

class TrainInfo extends Equatable {
  final String? id;
  final TrainScheduleTypes shedule_type;
  final TrainSample? sample;
  const TrainInfo({this.id, required this.shedule_type, this.sample});

  Map<String, dynamic> toMap() {
    return {
      'shedule_type': shedule_type.toString(),
    };
  }

  factory TrainInfo.fromMap(Map<String, dynamic> map) {
    return TrainInfo(
      id: map['id'],
      shedule_type: createSheduleType(map['schedule_type']),
      sample: map['train_samples'] != null
          ? TrainSample.fromMap(jsonDecode(map['train_samples'][0]['sample']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainInfo.fromJson(String source) =>
      TrainInfo.fromMap(json.decode(source));

  static createSheduleType(String json) {
    for (var el in TrainScheduleTypes.values) {
      if (el.toString() == json) {
        return el;
      }
    }
    throw new Error();
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
