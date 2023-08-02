import 'package:app/domain/activities/approach_activities.dart';

import '../services/create_activity_service.dart';

enum ActivityTypes { weightApproach, approach, total, timer }

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
