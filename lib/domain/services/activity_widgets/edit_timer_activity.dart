import 'package:app/domain/activities/timer_activity.dart';
import 'package:flutter/material.dart';

class EditTimerActivity extends StatefulWidget {
  final TimerActivity? activity;
  const EditTimerActivity({super.key, required this.activity});

  @override
  State<EditTimerActivity> createState() => _EditTimerActivityState();
}

class _EditTimerActivityState extends State<EditTimerActivity> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
