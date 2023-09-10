import 'package:app/features/shared/bottom_menu_widget.dart';
import 'package:app/features/shared/models/bottom_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/color.dart';
import '../../../shared/components/colored_button.dart';
import '../../../shared/debounce.dart';
import '../../activities/activity.dart';
import '../../exercises/exercise.dart';
import '../factory/create_activity_service.dart';
import '../exercise_activity_mapper.dart';
import '../train_samples_state.dart';

class EditExerciseCard extends StatelessWidget {
  final ExerciseState state;
  const EditExerciseCard({super.key, required this.state});

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
                  state: state,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Consumer(builder: (context, ref, child) {
                    final drawer = ref.read(activityDrawerProvider);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: state.activityType == null
                          ? Container()
                          : drawer.drawEditActivityForm(
                              state.activityType!, state.index, state.activity),
                    );
                  }),
                ),
                SubmitExerciseButton(
                  state: state,
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
        child: Consumer(
          builder: (context, ref, child) {
            final notifier = ref.read(trainSampleStateProvider.notifier);
            return ColoredButton(
              isDisabled: !state.validate(),
              buttonColor: AppColors.accent,
              height: 40,
              width: 200,
              onpressed: () {
                notifier.save(state.index);
              },
              text: 'Добавить',
            );
          },
        ),
      ),
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
  final Debounce debounce =
      Debounce(duration: const Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Consumer(
              builder: (context, ref, child) {
                final notifier = ref.read(trainSampleStateProvider.notifier);
                return TextFormField(
                  initialValue: widget.state.name,
                  onChanged: (value) {
                    debounce.run(() {
                      notifier.updateExerciseName(value, widget.state.index);
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
                );
              },
            ),
          ),
          Consumer(builder: (context, ref, child) {
            final exerciseActivityNamesMapper =
                ref.read(exerciseActivityNamesMapperProvider);
            final notifier = ref.read(trainSampleStateProvider.notifier);
            return IconButton(
              onPressed: () async {
                final result = await chooseActivityType(context,
                    exerciseActivityNamesMapper, widget.state.exerciseType);
                if (result != null) {
                  notifier.updateActivityType(result!, widget.state.index);
                }
              },
              icon: const Icon(Icons.add),
            );
          })
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
