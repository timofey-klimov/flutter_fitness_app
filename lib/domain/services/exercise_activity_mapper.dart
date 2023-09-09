import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_activity_service.dart';

class ExerciseActivityMapper {
  final Map<ExerciseTypes, List<ActivityTypes>> _map = {
    ExerciseTypes.weight: <ActivityTypes>[
      ActivityTypes.weightApproach,
      ActivityTypes.total,
      ActivityTypes.timer
    ],
    ExerciseTypes.selfWeight: <ActivityTypes>[
      ActivityTypes.approach,
      ActivityTypes.total,
      ActivityTypes.timer
    ]
  };

  List<ActivityTypes> getActivityTypesForExercise(ExerciseTypes exerciseType) {
    final list = _map[exerciseType];
    if (list == null) {
      throw new Error();
    }
    return list;
  }
}

final exerciseActivityMapperProvider =
    Provider((ref) => ExerciseActivityMapper());

class ExerciseActivityNamesMapper {
  final ExerciseActivityMapper _exerciseActivityMapper;
  final ActivityTypesMapper _activityTypesMapper;
  ExerciseActivityNamesMapper(
      {required ExerciseActivityMapper exerciseActivityMapper,
      required ActivityTypesMapper activityTypesMapper})
      : _exerciseActivityMapper = exerciseActivityMapper,
        _activityTypesMapper = activityTypesMapper;

  Map<ActivityTypes, String> getActivitiesForExercise(
      ExerciseTypes exerciseType) {
    var list =
        _exerciseActivityMapper.getActivityTypesForExercise(exerciseType);
    Map<ActivityTypes, String> map = {};
    for (var el in list) {
      var activities = _activityTypesMapper.getEntry(el);
      map.addEntries(activities);
    }
    return map;
  }
}

final exerciseActivityNamesMapperProvider = Provider(
  (ref) {
    return ExerciseActivityNamesMapper(
        activityTypesMapper: ref.read(activityTypesMapperProvider),
        exerciseActivityMapper: ref.read(exerciseActivityMapperProvider));
  },
);
