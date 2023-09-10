import 'package:app/domain/activities/total_activity.dart';
import 'package:flutter/material.dart';

class DisplayTotalActivity extends StatelessWidget {
  final TotalActivity activity;
  const DisplayTotalActivity({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        'Общее количество: ${activity.total} раз',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
