import 'package:app/domain/activities/approach_activities.dart';
import 'package:app/domain/services/activity_widgets/weight_approach_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../activities/activity.dart';

class ActivityTypesMapper {
  Map<ActivityTypes, String> map() {
    return {
      ActivityTypes.approach: 'Подходы',
      ActivityTypes.total: 'Общее количество',
      ActivityTypes.timer: 'Таймер',
      ActivityTypes.weightApproach: 'Подходы'
    };
  }

  Iterable<MapEntry<ActivityTypes, String>> getEntry(ActivityTypes type) =>
      map().entries.where((element) => element.key == type);
}

final activityTypesMapperProvider = Provider((ref) => ActivityTypesMapper());

ActivityTypes createActivityTypesFromString(String value) {
  for (var el in ActivityTypes.values) {
    if (el.toString() == value) {
      return el;
    }
  }
  throw new Error();
}

class CreateActivityService {
  Widget drawActivity(
      ActivityTypes activityType, int index, Activity? activityModel) {
    Widget activity;
    switch (activityType) {
      case ActivityTypes.weightApproach:
        activity = WeightApproachActivityWdiget(
          exerciseIndex: index,
          activity: activityModel == null
              ? null
              : activityModel as WeightApproachActivity,
        );
        break;
      default:
        throw new Error();
    }

    return activity;
  }
}

final activityDrawerProvider = Provider((ref) => CreateActivityService());
