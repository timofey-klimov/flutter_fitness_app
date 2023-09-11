import 'package:app/features/train_samples/create/return_button_widget.dart';
import 'package:flutter/material.dart';

import '../../../shared/color.dart';
import 'add_new_exercise_widget.dart';
import 'exercise_name_widget.dart';

class CreateTrainHeaderWidget extends StatelessWidget {
  const CreateTrainHeaderWidget({
    super.key,
    required VoidCallback onAdd,
  }) : _onAdd = onAdd;

  final VoidCallback _onAdd;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: AppColors.main,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReturnButtomWidget(),
          ExerciseNameWidget(),
          AddNewExerciseWidget(onAdd: _onAdd)
        ],
      ),
    );
  }
}
