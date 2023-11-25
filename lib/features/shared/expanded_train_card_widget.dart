import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/service_locator.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import '../../application/services/create_activity_service.dart';

class ExpandedTrainCardWidget extends StatefulWidget {
  final TrainSample trainSample;
  const ExpandedTrainCardWidget({super.key, required this.trainSample});

  @override
  State<ExpandedTrainCardWidget> createState() =>
      _ExpandedTrainCardWidgetState();
}

class _ExpandedTrainCardWidgetState extends State<ExpandedTrainCardWidget> {
  final drawer = getIt<CreateActivityService>();
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
                widget.trainSample.name.capitalize(),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Column(
                children: widget.trainSample.sample
                    .map(
                      (item) => ExpandExerciseWidget(
                        exercise: item,
                        drawer: drawer,
                      ),
                    )
                    .toList(),
              ),
            )
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
