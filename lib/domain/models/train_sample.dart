import 'dart:convert';

import '../exercises/exercise.dart';
import '../services/create_exercise_service.dart';

class TrainSample {
  final String id;
  final List<Exercise> sample;

  const TrainSample({required this.id, required this.sample});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sample': sample.map((x) => x.toMap()).toList(),
    };
  }

  factory TrainSample.fromMap(Map<String, dynamic> map) {
    return TrainSample(
      id: map['id'],
      sample: List<Exercise>.from((map['sample'] as List)
          .map((item) => ExerciseFactory.createExercise(item))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainSample.fromJson(String source) =>
      TrainSample.fromMap(json.decode(source));
}
