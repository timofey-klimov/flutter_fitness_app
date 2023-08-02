import 'package:app/domain/activities/approach_activities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivityTypes { weightApproach, approach, total, timer }

ActivityTypes createActivityTypesFromString(String value) {
  for (var el in ActivityTypes.values) {
    if (el.toString() == value) {
      return el;
    }
  }
  throw new Error();
}

class ActivityTypesMapper {
  Map<ActivityTypes, String> map() {
    return {
      ActivityTypes.approach: 'Подходы',
      ActivityTypes.total: 'Общее количество',
      ActivityTypes.timer: 'Таймер'
    };
  }
}

final activityTypesMapperProvider = Provider((ref) => ActivityTypesMapper());

abstract class Activity {
  static String entityKey = 'activity';
  static String typeKey = 'activity_type';
  final ActivityTypes type;
  Activity({
    required this.type,
  });

  Map<String, dynamic> toMap();
}

class ActivityFactory {
  static Activity createFromMap(Map<String, dynamic> body) {
    var type = createActivityTypesFromString(body[Activity.typeKey]);
    Activity activity;
    switch (type) {
      case ActivityTypes.weightApproach:
        activity = WeightApproachActivity.fromMap(body);
      default:
        throw new Error();
    }

    return activity;
  }
}
