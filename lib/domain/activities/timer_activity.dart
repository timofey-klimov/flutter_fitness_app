import 'package:app/domain/activities/activity.dart';

class TimeInterval {
  final int seconds;
  final int minutes;
  final int hours;
  TimeInterval({
    required this.seconds,
    required this.minutes,
    required this.hours,
  });

  Map<String, dynamic> toMap() =>
      {'seconds': seconds, 'minutes': minutes, 'hours': hours};

  factory TimeInterval.fromMap(Map<String, dynamic> map) => TimeInterval(
      seconds: map['seconds'], minutes: map['minutes'], hours: map['hours']);

  factory TimeInterval.initial() =>
      TimeInterval(seconds: 0, minutes: 0, hours: 0);

  bool validate() => seconds > 0 || minutes > 0 || hours > 0;

  TimeInterval copyWith({int? seconds, int? minutes, int? hours}) =>
      TimeInterval(
        seconds: seconds ?? this.seconds,
        minutes: minutes ?? this.minutes,
        hours: hours ?? this.hours,
      );

  @override
  String toString() {
    return "${_format(hours)}:${_format(minutes)}:${_format(seconds)}";
  }

  String _format(int value) {
    if (value == 0) return "00";

    var str = value.toString();
    if (str.length == 1) {
      return "0$value";
    }

    return value.toString();
  }
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
