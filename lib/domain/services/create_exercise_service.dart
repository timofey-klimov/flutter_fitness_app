import 'package:app/domain/activities/approach_activities.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/services/slidable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createExerciseServiceProvider =
    Provider((ref) => CreateExerciseService());

class CreateExerciseService {
  Widget drawForm(
      ExerciseTypes type, int index, void Function(int index) onRemove) {
    Widget widget;
    switch (type) {
      case ExerciseTypes.weight:
        widget = WeightExerciseCreateForm(
          index: index,
          onRemove: onRemove,
        );
      default:
        throw new Error();
    }
    return widget;
  }
}

class WeightExerciseCreateForm extends StatefulWidget {
  const WeightExerciseCreateForm(
      {super.key,
      required int index,
      required void Function(int index) onRemove})
      : _index = index,
        _onRemove = onRemove;

  final int _index;
  final Function(int index) _onRemove;
  @override
  State<WeightExerciseCreateForm> createState() =>
      _WeightExerciseCreateFormState(index: _index, onRemove: _onRemove);
}

class _WeightExerciseCreateFormState extends State<WeightExerciseCreateForm> {
  final int _index;
  final Function(int index) _onRemove;
  var approaches = <WeigthApproach>[];

  _WeightExerciseCreateFormState(
      {required int index, required void Function(int index) onRemove})
      : _index = index,
        _onRemove = onRemove;
  @override
  Widget build(BuildContext context) {
    return SlidableCard(
      onRemove: _onRemove,
      index: _index,
      card: WeightExerciseCard(),
    );
  }
}

class WeightExerciseCard extends StatelessWidget {
  const WeightExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
