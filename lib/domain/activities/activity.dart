import 'package:app/domain/activities/approach_activities.dart';
import 'package:app/domain/activities/timer_activity.dart';
import 'package:app/domain/activities/total_activity.dart';

import '../../application/services/create_activity_service.dart';

enum ActivityTypes { empty, weightApproach, approach, total, timer }

abstract class Activity {
  static String entityKey = 'activity';
  static String typeKey = 'activity_type';
  final ActivityTypes type;
  Activity({
    required this.type,
  });

  Map<String, dynamic> toMap();
  bool validate();

  T convert<T extends Activity>() => this as T;
}

class ActivityFactory {
  static Activity createFromMap(Map<String, dynamic> body) {
    var type = createActivityTypesFromString(body[Activity.typeKey]);
    Activity activity;
    switch (type) {
      case ActivityTypes.weightApproach:
        activity = WeightApproachActivity.fromMap(body);
      case ActivityTypes.approach:
        activity = ApproachActivity.fromMap(body);
      case ActivityTypes.total:
        activity = TotalActivity.fromMap(body);
      case ActivityTypes.timer:
        activity = TimerActivity.fromMap(body);
      default:
        throw Error();
    }

    return activity;
  }
}
