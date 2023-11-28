import 'package:app/features/trains/bloc/state/train_state.dart';
import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../application/services/create_exercise_service.dart';
import '../../../../domain/exercises/exercise.dart';
import '../../../../shared/color.dart';
import '../../../shared/bottom_menu_widget.dart';
import '../../../shared/models/bottom_menu_model.dart';

class AddExerciseButtonWidget extends StatefulWidget {
  const AddExerciseButtonWidget({
    super.key,
    required VoidCallback onAdd,
  }) : _onAdd = onAdd;

  final VoidCallback _onAdd;

  @override
  State<AddExerciseButtonWidget> createState() =>
      _AddExerciseButtonWidgetState();
}

class _AddExerciseButtonWidgetState extends State<AddExerciseButtonWidget> {
  final mapper = getIt<ExerciseMapper>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainBloc, TrainState>(
      builder: (ctx, state) {
        state as CreateTrainState;
        final bloc = ctx.read<TrainBloc>();
        final isDisabled =
            state.exercisesState.any((item) => item.isFormEditing);
        return IconButton(
          onPressed: isDisabled
              ? null
              : () async {
                  final result = await showModalBottomSheet<ExerciseTypes>(
                    context: ctx,
                    builder: (context) {
                      final exerciseMap = mapper.map();
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
                  if (result != null) {
                    widget._onAdd();
                    bloc.add(AddNewExerciseEvent(type: result));
                  }
                },
          icon: Icon(
            Icons.add,
            color:
                isDisabled ? AppColors.main.withOpacity(.5) : AppColors.main,
          ),
        );
      },
    );
  }
}
