import 'package:app/domain/activities/activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ExerciseTypes { weight, selfWeight, cardio, stretch }

abstract class Exercise {
  static String execricseTypeKey = 'exercise_type';
  final int? id;
  final String name;
  final Activity activity;
  final ExerciseTypes type;
  final int index;
  Exercise({
    this.id,
    required this.name,
    required this.index,
    required this.activity,
    required this.type,
  });

  Map<String, dynamic> toMap();
  List<ActivityTypes> get activities;
}

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
