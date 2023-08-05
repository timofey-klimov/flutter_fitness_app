import 'package:flutter/material.dart';
import 'package:app/domain/services/train_samples_state.dart';
import 'completed_exercise_card.dart';
import 'edit_exercise_card.dart';

class CreateExerciseCard extends StatelessWidget {
  const CreateExerciseCard(
      {super.key,
      required this.state,
      required this.onRemove,
      required this.enableEditing});
  final void Function(int index, Widget widget) onRemove;
  final ExerciseState state;
  final bool enableEditing;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: child,
          );
        },
        duration: const Duration(milliseconds: 400),
        child: state.isFormEditing
            ? EditExerciseCard(state: state)
            : CompletedExerciseCard(
                onRemove: onRemove,
                state: state,
                enableEditing: enableEditing,
              ));
  }
}
