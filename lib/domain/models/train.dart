import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../exercises/exercise.dart';
import '../../application/services/create_exercise_service.dart';

class Train extends Equatable {
  final int? id;
  final List<Exercise> exercises;
  final DateTime date;

  const Train({
    this.id,
    required this.exercises,
    required this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory Train.fromMap(Map<String, dynamic> map) {
    return Train(
      date: DateTime.parse(map['train_date']),
      id: map['id'],
      exercises: List<Exercise>.from((json.decode(map['exercises']) as List)
          .map((item) => ExerciseFactory.createExercise(item))),
    );
  }
  
  String toJson() => json.encode(toMap());

  factory Train.fromJson(String source) =>
      Train.fromMap(json.decode(source));

  @override
  List<Object?> get props => [id, exercises, date];
}
