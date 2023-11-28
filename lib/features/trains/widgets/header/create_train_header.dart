import 'package:app/features/trains/widgets/header/return_button.dart';
import 'package:app/features/trains/widgets/header/train_date_picker.dart';
import 'package:flutter/material.dart';
import 'add_exercise_button.dart';

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ReturnButtomWidget(),
          TrainDatePickerWidget(),
          AddExerciseButtonWidget(onAdd: _onAdd)
        ],
      ),
    );
  }
}
