import 'package:app/domain/activities/activity.dart';

enum ExerciseTypes { weight, selfWeight, cardio, stretch }

abstract class Exercise {
  static String execricseTypeKey = 'exercise_type';
  final String name;
  final Activity activity;
  final ExerciseTypes type;
  final int index;
  Exercise({
    required this.name,
    required this.index,
    required this.activity,
    required this.type,
  });

  Map<String, dynamic> toMap();
}
