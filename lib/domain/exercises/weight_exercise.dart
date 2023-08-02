import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';

class WeightExercise extends Exercise {
  WeightExercise(
      {super.id,
      required super.activity,
      required super.index,
      required super.name})
      : super(type: ExerciseTypes.weight);

  factory WeightExercise.fromMap(Map<String, dynamic> map) {
    return WeightExercise(
        id: map['id'],
        name: map['name'],
        index: map['index'].toInt(),
        activity: ActivityFactory.createFromMap(map[Activity.entityKey]));
  }

  @override
  List<ActivityTypes> get activities => [ActivityTypes.weightApproach];

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'index': index,
      'name': name,
      Activity.entityKey: activity.toMap(),
      Exercise.key: type.toString()
    };
  }
}
