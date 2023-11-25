import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/exercises/self_weight_exercise.dart';
import 'package:app/domain/exercises/weight_exercise.dart';

class ExerciseMapper {
  Map<ExerciseTypes, String> map() {
    return {
      ExerciseTypes.weight: 'С доп. весом',
      ExerciseTypes.selfWeight: 'Со своим весом',
      ExerciseTypes.cardio: 'Кардио',
      ExerciseTypes.stretch: 'Растяжка'
    };
  }
}

class ExerciseFactory {
  static Exercise createExercise(Map<String, dynamic> map) {
    final typeString = map[Exercise.execricseTypeKey];
    final type = createType(typeString);

    switch (type) {
      case ExerciseTypes.weight:
        return WeightExercise.fromMap(map);
      case ExerciseTypes.selfWeight:
        return SelfWeightExercise.fromMap(map);
      default:
        throw new Error();
    }
  }

  static Exercise createExerciseFromState(ExerciseTypes type, Activity? activity, int index, String name) {
    switch (type) {
      case ExerciseTypes.weight:
        return WeightExercise(
            activity: activity!, index: index, name: name);
      case ExerciseTypes.selfWeight:
        return SelfWeightExercise(
            activity: activity!, index: index, name: name);
      default:
        throw Error();
    }
  }

  static createType(String type) {
    for (var value in ExerciseTypes.values) {
      if (value.toString() == type) {
        return value;
      }
    }
    throw new Error();
  }
}
