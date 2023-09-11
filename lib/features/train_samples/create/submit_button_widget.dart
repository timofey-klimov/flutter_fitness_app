import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/services/train_samples_state.dart';
import '../train_shedule_pick_result.dart';
import 'choose_train_date_widget.dart';

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback isSubmitting;
  const SubmitButtonWidget({
    super.key,
    required this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      final state = ref.watch(trainSampleStateProvider);
      final valid = state.name?.isNotEmpty == true &&
          state.exercisesState.isNotEmpty &&
          state.exercisesState
              .map((e) => !e.isFormEditing && e.isSubmitting)
              .reduce((value, element) => value && element);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: !valid
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green,
                              blurRadius: 3.0,
                              spreadRadius: 0.0)
                        ]),
                    width: 70,
                    height: 70,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {
                            var result = await showModalBottomSheet<
                                    TrainShedulePickResult>(
                                context: context,
                                builder: (ctx) => ChooseTrainDateWidget());
                            if (result != null) {
                              isSubmitting();
                              ref
                                  .read(trainSampleStateProvider.notifier)
                                  .submitTrain(result.date, result.type);
                            }
                          },
                          icon: const Icon(Icons.check),
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
      );
    });
  }
}
