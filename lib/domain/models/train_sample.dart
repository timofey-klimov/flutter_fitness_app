import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../exercises/exercise.dart';
import '../../application/services/factory/create_exercise_service.dart';

///Obsolete
class TrainSample extends Equatable {
  final String? id;
  final String name;
  final String train_info_id;
  final List<Exercise> sample;

  const TrainSample(
      {this.id,
      required this.sample,
      required this.name,
      required this.train_info_id});

  Map<String, dynamic> toMap() {
    return {
      'sample': sample.map((x) => x.toMap()).toList(),
      'name': name,
      'train_info_id': train_info_id
    };
  }

  factory TrainSample.fromMap(Map<String, dynamic> map) {
    var sample = jsonDecode(map['sample']);
    return TrainSample(
      name: sample['name'],
      id: map['id'],
      train_info_id: 'train_info_id',
      sample: List<Exercise>.from((sample['sample'] as List)
          .map((item) => ExerciseFactory.createExercise(item))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainSample.fromJson(String source) =>
      TrainSample.fromMap(json.decode(source));

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
