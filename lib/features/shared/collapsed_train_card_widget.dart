import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';

class CollapsedTrainCardWidget extends StatelessWidget {
  final TrainSample sample;
  final Function(TrainSample sample) onExpand;
  final Color color;
  final String id;
  const CollapsedTrainCardWidget({
    super.key,
    required this.sample,
    required this.id,
    required this.onExpand,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onExpand(sample);
      },
      child: Card(
        color: color,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sample.name.capitalize(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 20),
                child: _collapsedExercises(sample.sample),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _collapsedExercises(List<Exercise> exercises) {
    List<Row> rows = [];
    for (var el in exercises) {
      rows.add(Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              '${rows.length + 1}. ${el.name.capitalize()}',
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ));
    }
    return Column(
      key: const ValueKey('Calendar_collapse_exercises'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
