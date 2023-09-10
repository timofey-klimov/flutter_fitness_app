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

  TimeInterval copyWith({int? seconds, int? minutes, int? hours}) {
    final result = _calculate(
        seconds ?? this.seconds, minutes ?? this.minutes, hours ?? this.hours);
    return TimeInterval(
        seconds: result.$3, minutes: result.$2, hours: result.$1);
  }

  (int hours, int minutes, int seconds) _calculate(
      int seconds, int minutes, int hours) {
    var currentHours = 0;
    var currentMinutes = 0;
    var currentSeconds = 0;
    if (seconds > 0) {
      if (seconds / 60 == 1) {
        currentMinutes = ++minutes;
      } else {
        currentSeconds = seconds;
      }
    }

    if (minutes > 0) {
      if (minutes / 60 == 1) {
        currentHours = ++hours;
      } else {
        currentMinutes = minutes;
      }
    }

    if (hours > 0) {
      currentHours = hours;
    }

    return (currentHours, currentMinutes, currentSeconds);
  }

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
