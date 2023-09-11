import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/exercises/exercise.dart';
import '../../../domain/models/train_sample.dart';
import '../../../shared/color.dart';

class TrainCardWidget extends StatelessWidget {
  final TrainSample sample;
  final Function() onExpand;
  final String id;
  const TrainCardWidget({
    super.key,
    required this.sample,
    required this.id,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onExpand();
      },
      child: Card(
        color: AppColors.lightBlue,
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
                    Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.more_vert),
                        );
                      },
                    )
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
