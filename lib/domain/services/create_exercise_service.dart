import 'package:app/domain/exercises/exercise.dart';
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
