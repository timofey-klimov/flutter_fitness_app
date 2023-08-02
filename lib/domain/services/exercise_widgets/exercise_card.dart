import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/services/train_samples_state.dart';

import '../../../shared/color.dart';
import '../../../shared/components/colored_button.dart';
import '../../exercises/exercise.dart';
import '../create_activity_service.dart';
import '../exercise_activity_mapper.dart';
import '../slidable_card.dart';

class CardState {
  final int index;
  final ExerciseTypes exerciseType;
  ActivityTypes? activityType;
  String? name;
  CardState({
    required this.index,
    required this.exerciseType,
    this.activityType,
    this.name,
  });

  CardState copyWith({
    int? index,
    ExerciseTypes? exerciseType,
    ActivityTypes? activityType,
    String? name,
  }) {
    return CardState(
      index: index ?? this.index,
      exerciseType: exerciseType ?? this.exerciseType,
      activityType: activityType ?? this.activityType,
      name: name ?? this.name,
    );
  }
}

class CreateExerciseCard extends StatefulWidget {
  const CreateExerciseCard(
      {super.key,
      required int index,
      required ExerciseTypes exerciseType,
      required void Function(int index) onRemove})
      : _onRemove = onRemove,
        _index = index,
        _exerciseType = exerciseType;

  final Function(int index) _onRemove;
  final int _index;
  final ExerciseTypes _exerciseType;

  @override
  State<CreateExerciseCard> createState() => _CreateExerciseCardState();
}

class _CreateExerciseCardState extends State<CreateExerciseCard> {
  late CardState state;
  @override
  void initState() {
    state = CardState(exerciseType: widget._exerciseType, index: widget._index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlidableCard(
      onRemove: widget._onRemove,
      index: widget._index,
      card: EditExerciseCard(
        state: state,
        updateState: (state) {
          setState(() {
            this.state = state;
          });
        },
      ),
    );
  }
}

class EditExerciseCard extends StatelessWidget {
  final CardState state;
  final void Function(CardState state) updateState;
  const EditExerciseCard(
      {super.key, required this.state, required this.updateState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        shadowColor: AppColors.linearBgEnd,
        color: AppColors.linearBgEnd,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Flex(
            direction: Axis.vertical,
            children: [
              ExerciseHeaderWidget(
                state: state,
                updateState: updateState,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Consumer(builder: (context, ref, child) {
                  final drawer = ref.read(activityDrawerProvider);
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: state.activityType == null
                        ? Container()
                        : drawer.drawActivity(state.activityType!),
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
  final CardState state;
  void Function(CardState state) updateState;
  ExerciseHeaderWidget(
      {super.key, required this.state, required this.updateState});

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
                  initialValue: state.name,
                  onFieldSubmitted: (value) {
                    updateState(state.copyWith(name: value));
                    notifier.updateExerciseName(value, state.index);
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
                    context, exerciseActivityNamesMapper, state.exerciseType);
                if (result != null) {
                  updateState(state.copyWith(activityType: result));
                  notifier.updateActivityType(result!, state.index);
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
