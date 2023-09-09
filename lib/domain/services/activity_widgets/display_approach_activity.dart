import 'package:app/domain/activities/approach_activities.dart';
import 'package:flutter/material.dart';

class DisplayApproachActivityWidget extends StatelessWidget {
  final ApproachActivity activity;
  const DisplayApproachActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final approaches = activity.approaches;
    List<Row> rows = [];
    for (var el in approaches) {
      rows.add(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                '\u2022 ${el.count} раз',
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: rows,
    );
  }
}
