import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/factory/create_activity_service.dart';

class ExpandedTrainCardWidget extends StatelessWidget {
  final TrainSample trainSample;
  const ExpandedTrainCardWidget({super.key, required this.trainSample});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 20),
              child: Text(
                trainSample.name.capitalize(),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, ref, child) {
                final drawer = ref.read(activityDrawerProvider);
                return Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Column(
                    children: trainSample.sample
                        .map(
                          (item) => ExpandExerciseWidget(
                            exercise: item,
                            drawer: drawer,
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  final CreateActivityService drawer;
  const ExpandExerciseWidget(
      {super.key, required this.exercise, required this.drawer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name.capitalize(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              drawer.drawDisplayActivityForm(exercise.activity)
            ],
          )
        ],
      ),
    );
  }
}
