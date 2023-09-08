import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../exercises/exercise.dart';
import '../services/create_exercise_service.dart';

class TrainSample extends Equatable {
  final String? id;
  final String name;
  final List<Exercise> sample;

  const TrainSample({this.id, required this.sample, required this.name});

  Map<String, dynamic> toMap() {
    return {'sample': sample.map((x) => x.toMap()).toList(), 'name': name};
  }

  factory TrainSample.fromMap(Map<String, dynamic> map) {
    return TrainSample(
      name: map['name'],
      id: map['id'],
      sample: List<Exercise>.from((map['sample'] as List)
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
