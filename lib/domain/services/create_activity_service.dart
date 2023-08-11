import 'package:app/domain/activities/approach_activities.dart';
import 'package:app/domain/services/activity_widgets/display_weight_approach_activity.dart';
import 'package:app/domain/services/activity_widgets/edit_weight_approach_activity.dart';
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
  Widget drawEditActivityForm(
      ActivityTypes activityType, int index, Activity? activityModel) {
    switch (activityType) {
      case ActivityTypes.weightApproach:
        return EditWeightApproachActivityWdiget(
          exerciseIndex: index,
          activity: activityModel == null
              ? null
              : activityModel as WeightApproachActivity,
        );
      default:
        throw Error();
    }
  }

  Widget drawDisplayActivityForm(Activity activity) {
    switch (activity.type) {
      case ActivityTypes.weightApproach:
        return DisplayWeightApproachActivityWidget(
          activity: activity as WeightApproachActivity,
        );
      default:
        throw Error();
    }
  }
}

final activityDrawerProvider = Provider((ref) => CreateActivityService());
