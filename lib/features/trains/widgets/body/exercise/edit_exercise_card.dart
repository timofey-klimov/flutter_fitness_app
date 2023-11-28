import 'package:app/application/services/create_activity_service.dart';
import 'package:app/features/shared/bottom_menu_widget.dart';
import 'package:app/features/shared/models/bottom_menu_model.dart';
import 'package:app/features/trains/bloc/state/exercise_state.dart';
import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/color.dart';
import '../../../../../shared/components/colored_button.dart';
import '../../../../../shared/debounce.dart';
import '../../../../../domain/activities/activity.dart';
import '../../../../../domain/exercises/exercise.dart';
import '../../../../../application/services/exercise_activity_mapper.dart';

class EditExerciseCard extends StatefulWidget {
  final ExerciseState state;
  const EditExerciseCard({super.key, required this.state});

  @override
  State<EditExerciseCard> createState() => _EditExerciseCardState();
}

class _EditExerciseCardState extends State<EditExerciseCard> {
  final drawer = getIt<CreateActivityService>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shadowColor: AppColors.lightBlue,
          color: AppColors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Flex(
              direction: Axis.vertical,
              children: [
                ExerciseHeaderWidget(
                  state: widget.state,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: widget.state.activityType == null
                        ? Container()
                        : drawer.drawEditActivityForm(
                            widget.state.activityType!,
                            widget.state.index,
                            widget.state.activity),
                  ),
                ),
                SubmitExerciseButton(
                  state: widget.state,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitExerciseButton extends StatelessWidget {
  const SubmitExerciseButton({super.key, required this.state});
  final ExerciseState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: ColoredButton(
            isDisabled: !state.validate(),
            buttonColor: AppColors.accent,
            height: 40,
            width: 200,
            onpressed: () {
              context
                  .read<TrainBloc>()
                  .add(SaveExerciseEvent(index: state.index));
            },
            text: 'Добавить',
          )),
    );
  }
}

class ExerciseHeaderWidget extends StatefulWidget {
  final ExerciseState state;
  const ExerciseHeaderWidget({super.key, required this.state});

  @override
  State<ExerciseHeaderWidget> createState() => _ExerciseHeaderWidgetState();
}

class _ExerciseHeaderWidgetState extends State<ExerciseHeaderWidget> {
  final ExerciseActivityNamesMapper mapper =
      getIt<ExerciseActivityNamesMapper>();
  final Debounce debounce =
      Debounce(duration: const Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TrainBloc>();
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              initialValue: widget.state.name,
              onChanged: (value) {
                debounce.run(() {
                  context.read<TrainBloc>().add(UpdateExerciseNameEvent(
                      name: value, index: widget.state.index));
                });
              },
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  decorationThickness: 0),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Название упражнения',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await chooseActivityType(
                  context, mapper, widget.state.exerciseType);
              if (result != null) {
                bloc.add(UpdateActivityTypeEvent(
                    activityType: result, index: widget.state.index));
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }

  Future<ActivityTypes?> chooseActivityType(
      BuildContext context,
      ExerciseActivityNamesMapper exerciseActivityNamesMapper,
      ExerciseTypes exerciseType) {
    return showModalBottomSheet<ActivityTypes>(
      context: context,
      builder: (ctx) {
        var map =
            exerciseActivityNamesMapper.getActivitiesForExercise(exerciseType);
        final list = <BottomMenuItem<ActivityTypes>>[];
        map.forEach(
          (key, value) {
            list.add(
              BottomMenuItem<ActivityTypes>(value: key, text: value),
            );
          },
        );
        return BottomMenuWidget(model: BottomMenuModel(items: list));
      },
    );
  }
}
