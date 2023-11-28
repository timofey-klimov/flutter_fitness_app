import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train.dart';
import 'package:app/service_locator.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import '../../application/services/create_activity_service.dart';

class ExpandedTrainCardWidget extends StatefulWidget {
  final Train train;
  const ExpandedTrainCardWidget({super.key, required this.train});

  @override
  State<ExpandedTrainCardWidget> createState() =>
      _ExpandedTrainCardWidgetState();
}

class _ExpandedTrainCardWidgetState extends State<ExpandedTrainCardWidget> {
  final drawer = getIt<CreateActivityService>();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: widget.train.exercises
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
