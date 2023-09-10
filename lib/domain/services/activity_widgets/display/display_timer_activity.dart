import 'package:app/domain/activities/timer_activity.dart';
import 'package:flutter/material.dart';

class DisplayTimerActivity extends StatelessWidget {
  final TimerActivity activity;
  const DisplayTimerActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        'Время: ${activity.timeInterval.toString()}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
