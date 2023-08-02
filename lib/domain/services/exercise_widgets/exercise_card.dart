import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/services/train_samples_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/color.dart';
import '../../../shared/components/colored_button.dart';
import '../../exercises/exercise.dart';
import '../create_activity_service.dart';
import '../exercise_activity_mapper.dart';
import '../slidable_card.dart';

class CreateExerciseCard extends StatelessWidget {
  const CreateExerciseCard(
      {super.key,
      required ExerciseState state,
      required void Function(int index) onRemove})
      : _onRemove = onRemove,
        _state = state;

  final Function(int index) _onRemove;
  final ExerciseState _state;
  final String? name = null;

  @override
  Widget build(BuildContext context) {
    return SlidableCard(
      onRemove: _onRemove,
      index: _state.index,
      card: EditExerciseCard(
        state: _state,
      ),
    );
  }
}

class EditExerciseCard extends StatelessWidget {
  final ExerciseState _state;
  const EditExerciseCard({super.key, required ExerciseState state})
      : _state = state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Card(
        shadowColor: AppColors.linearBgEnd,
        color: AppColors.linearBgEnd,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Flex(
            direction: Axis.vertical,
            children: [
              ExerciseHeaderWidget(
                state: _state,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Consumer(builder: (context, ref, child) {
                  final drawer = ref.read(activityDrawerProvider);
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: _state.activityType == null
                        ? Container()
                        : drawer.drawActivity(_state.activityType!),
                  );
                }),
              ),
              SubmitExerciseButton()
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitExerciseButton extends StatelessWidget {
  const SubmitExerciseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: ColoredButton(
          buttonColor: AppColors.accent,
          height: 40,
          width: 200,
          onpressed: () {},
          text: 'Добавить',
        ),
      ),
    );
  }
}

class ExerciseHeaderWidget extends StatelessWidget {
  final ExerciseState _state;
  const ExerciseHeaderWidget({super.key, required ExerciseState state})
      : _state = state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 270,
            child: Consumer(
              builder: (context, ref, child) {
                final notifier = ref.read(trainSampleStateProvider.notifier);
                return TextFormField(
                  initialValue: _state.name,
                  onFieldSubmitted: (value) {
                    notifier.updateExerciseName(value, _state.index);
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(25)],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
                final result = await chooseActivityType(
                    context, exerciseActivityNamesMapper, _state.exerciseType);
                if (result != null) {
                  notifier.updateActivityType(result!, _state.index);
                }
              },
              icon: Icon(Icons.add),
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
        final list = <PopupMenuItem<ActivityTypes>>[];
        map.forEach(
          (key, value) {
            list.add(
              PopupMenuItem<ActivityTypes>(
                value: key,
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          },
        );
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [...list],
          ),
        );
      },
    );
  }
}
