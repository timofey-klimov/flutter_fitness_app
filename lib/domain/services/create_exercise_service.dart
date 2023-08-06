import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/exercises/weight_exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final exerciseMapperProvider = Provider((ref) => ExerciseMapper());

class ExerciseFactory {
  static Exercise createExercise(Map<String, dynamic> map) {
    final typeString = map[Exercise.execricseTypeKey];
    final type = createType(typeString);

    switch (type) {
      case ExerciseTypes.weight:
        return WeightExercise.fromMap(map);
      default:
        throw new Error();
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
