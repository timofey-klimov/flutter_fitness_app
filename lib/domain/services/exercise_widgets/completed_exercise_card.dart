import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/color.dart';
import '../train_samples_state.dart';

class CompletedExerciseCard extends StatelessWidget {
  final ExerciseState state;
  final bool enableEditing;
  final void Function(int index, Widget widget) onRemove;
  const CompletedExerciseCard(
      {super.key,
      required this.state,
      required this.enableEditing,
      required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: state.isDeleting
            ? DeletingExerciseCard(
                onRemove: onRemove,
                state: state,
              )
            : ExerciseInfoCard(
                state: state,
                enableEditing: enableEditing,
              ));
  }
}

class ExerciseInfoCard extends StatelessWidget {
  const ExerciseInfoCard({
    super.key,
    required this.state,
    required this.enableEditing,
  });
  final ExerciseState state;
  final bool enableEditing;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(trainSampleStateProvider.notifier);
        return GestureDetector(
          onLongPress: () {
            notifier.updateDeleting(state.index, true);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Card(
              shadowColor: AppColors.lightBlue,
              color: AppColors.lightBlue,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.name!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                decorationThickness: 0),
                          ),
                          IconButton(
                              onPressed: !enableEditing
                                  ? null
                                  : () {
                                      notifier.markExerciseEditing(state.index);
                                    },
                              icon: Icon(
                                Icons.edit,
                                color: enableEditing
                                    ? Colors.black
                                    : Colors.black.withOpacity(.5),
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: AppColors.main,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DeletingExerciseCard extends StatelessWidget {
  const DeletingExerciseCard(
      {super.key, required this.state, required this.onRemove});
  final ExerciseState state;
  final void Function(int index, Widget widget) onRemove;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(trainSampleStateProvider.notifier);
        return GestureDetector(
          onTap: () {
            notifier.updateDeleting(state.index, false);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.lightRed,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.lightRed,
                        blurRadius: 10,
                        spreadRadius: 0.0)
                  ]),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.name!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                decorationThickness: 0),
                          ),
                          IconButton(
                              onPressed: () {
                                onRemove(
                                    state.index,
                                    DeletingExerciseCard(
                                      onRemove: onRemove,
                                      state: state,
                                    ));
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: AppColors.main,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
