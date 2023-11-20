import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/services/factory/create_exercise_service.dart';
import '../../../application/services/train_samples_state.dart';
import '../../../domain/exercises/exercise.dart';
import '../../../shared/color.dart';
import '../../shared/bottom_menu_widget.dart';
import '../../shared/models/bottom_menu_model.dart';

class AddNewExerciseWidget extends StatelessWidget {
  const AddNewExerciseWidget({
    super.key,
    required VoidCallback onAdd,
  }) : _onAdd = onAdd;

  final VoidCallback _onAdd;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, child) {
        final state = ref.watch(trainSampleStateProvider);
        final isDisabled =
            state.exercisesState.any((item) => item.isFormEditing);
        return IconButton(
          onPressed: isDisabled
              ? null
              : () async {
                  final result = await showModalBottomSheet<ExerciseTypes>(
                      context: ctx,
                      builder: (context) {
                        return Consumer(
                          builder: (ctx, ref, child) {
                            final provider = ref.read(exerciseMapperProvider);
                            final exerciseMap = provider.map();
                            final list = <BottomMenuItem<ExerciseTypes>>[];
                            exerciseMap.forEach(
                              (key, value) {
                                list.add(
                                  BottomMenuItem<ExerciseTypes>(
                                      value: key, text: value),
                                );
                              },
                            );
                            final model = BottomMenuModel(items: list);
                            return BottomMenuWidget(
                              model: model,
                            );
                          },
                        );
                      });
                  if (result != null) {
                    _onAdd();
                    ref
                        .read(trainSampleStateProvider.notifier)
                        .addNewExercise(result);
                  }
                },
          icon: Icon(
            Icons.add,
            color:
                isDisabled ? AppColors.white.withOpacity(.5) : AppColors.white,
          ),
        );
      },
    );
  }
}
