import 'package:app/features/trains/widgets/body/activity/display/display_approach_activity.dart';
import 'package:app/features/trains/widgets/body/activity/display/display_timer_activity.dart';
import 'package:app/features/trains/widgets/body/activity/display/display_total_activity.dart';
import 'package:app/features/trains/widgets/body/activity/display/display_weight_approach_activity.dart';
import 'package:app/features/trains/widgets/body/activity/edit/edit_approach_activity.dart';
import 'package:app/features/trains/widgets/body/activity/edit/edit_timer_activity.dart';
import 'package:app/features/trains/widgets/body/activity/edit/edit_total_activity.dart';
import 'package:app/features/trains/widgets/body/activity/edit/edit_weight_approach_activity.dart';
import 'package:flutter/material.dart';
import '../../domain/activities/activity.dart';

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

ActivityTypes createActivityTypesFromString(String value) {
  for (var el in ActivityTypes.values) {
    if (el.toString() == value) {
      return el;
    }
  }
  throw Error();
}

class CreateActivityService {
  Widget drawEditActivityForm(
      ActivityTypes activityType, int index, Activity activityModel) {
    final activity = activityModel.type == ActivityTypes.empty ? null : activityModel;
    switch (activityType) {
      case ActivityTypes.weightApproach:
        return EditWeightApproachActivityWdiget(
          exerciseIndex: index,
          activity: activity?.convert(),
        );
      case ActivityTypes.approach:
        return EditApproachActivityWdiget(
            exerciseIndex: index, activity: activity?.convert());
      case ActivityTypes.total:
        return EditTotalActivityWidget(
            index: index, activity: activity?.convert());
      case ActivityTypes.timer:
        return EditTimerActivity(
            index: index, activity: activity?.convert());
      default:
        throw Error();
    }
  }

  Widget drawDisplayActivityForm(Activity activity) {
    switch (activity.type) {
      case ActivityTypes.weightApproach:
        return DisplayWeightApproachActivityWidget(
          activity: activity.convert(),
        );
      case ActivityTypes.approach:
        return DisplayApproachActivityWidget(activity: activity.convert());
      case ActivityTypes.total:
        return DisplayTotalActivity(activity: activity.convert());
      case ActivityTypes.timer:
        return DisplayTimerActivity(activity: activity.convert());
      default:
        throw Error();
    }
  }
}
