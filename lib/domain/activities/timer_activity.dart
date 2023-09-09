import 'package:app/domain/activities/activity.dart';
import 'package:app/shared/extensions.dart';

class TimeInterval {
  final String? seconds;
  final String? minutes;
  final String? hours;
  TimeInterval({
    this.seconds,
    this.minutes,
    this.hours,
  });

  Map<String, dynamic> toMap() =>
      {'seconds': seconds, 'minutes': minutes, 'hours': hours};

  factory TimeInterval.fromMap(Map<String, dynamic> map) => TimeInterval(
      seconds: map['seconds'], minutes: map['minutes'], hours: map['hours']);

  bool validate() => seconds.isValid() || minutes.isValid() || hours.isValid();

  TimeInterval copyWith({String? seconds, String? minutes, String? hours}) =>
      TimeInterval(
          seconds: seconds ?? this.seconds,
          minutes: minutes ?? this.minutes,
          hours: hours ?? this.hours);
}

class TimerActivity extends Activity {
  final TimeInterval timeInterval;
  TimerActivity({required this.timeInterval})
      : super(type: ActivityTypes.timer);

  factory TimerActivity.fromMap(Map<String, dynamic> map) {
    return TimerActivity(
        timeInterval: TimeInterval.fromMap(map['timeInterval']));
  }

  @override
  Map<String, dynamic> toMap() =>
      {Activity.typeKey: type.toString(), 'timeInterval': timeInterval.toMap()};

  @override
  bool validate() => timeInterval.validate();
}
