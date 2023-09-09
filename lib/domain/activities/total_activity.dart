import 'package:app/domain/activities/activity.dart';

class TotalActivity extends Activity {
  String total;
  TotalActivity({required this.total}) : super(type: ActivityTypes.total);

  factory TotalActivity.fromMap(Map<String, dynamic> map) =>
      TotalActivity(total: map['total']);

  @override
  Map<String, dynamic> toMap() {
    return {'total': total, Activity.typeKey: type.toString()};
  }

  @override
  bool validate() => total.isNotEmpty;
}
