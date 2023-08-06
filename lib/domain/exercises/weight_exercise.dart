import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';

class WeightExercise extends Exercise {
  WeightExercise(
      {required super.activity, required super.index, required super.name})
      : super(type: ExerciseTypes.weight);

  factory WeightExercise.fromMap(Map<String, dynamic> map) {
    return WeightExercise(
        name: map['name'],
        index: map['index'].toInt(),
        activity: ActivityFactory.createFromMap(map[Activity.entityKey]));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'name': name,
      Activity.entityKey: activity.toMap(),
      Exercise.execricseTypeKey: type.toString()
    };
  }
}
