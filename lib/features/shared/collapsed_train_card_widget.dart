import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/features/shared/models/bottom_menu_model.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/riverpod/calendar/remove_sheduled_train_sample_provider.dart';
import '../../application/riverpod/calendar/reshedule_train_sample_provider.dart';
import '../../application/usecases/calendar/reshedule_train_sample_use_case.dart';
import '../../shared/color.dart';
import 'bottom_menu_widget.dart';
import 'models/train_card_action_model.dart';

class CollapsedTrainCardWidget extends StatelessWidget {
  final TrainSample sample;
  final Function(TrainSample sample) onExpand;
  final String id;
  const CollapsedTrainCardWidget({
    super.key,
    required this.sample,
    required this.id,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onExpand(sample);
      },
      child: Card(
        color: AppColors.lightGreen,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sample.name.capitalize(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return IconButton(
                          onPressed: () async {
                            final result =
                                await showModalBottomSheet<TrainCardAction>(
                              context: context,
                              builder: (ctx) {
                                return BottomMenuWidget<TrainCardAction>(
                                  model: BottomMenuModel(items: [
                                    BottomMenuItem(
                                        value: TrainCardAction.reschedule,
                                        text: 'Перенести'),
                                    BottomMenuItem(
                                        value: TrainCardAction.remove,
                                        text: 'Удалить',
                                        textColor: Colors.red),
                                  ]),
                                );
                              },
                            );
                            if (result == TrainCardAction.remove) {
                              ref.watch(removeSheduledTrainSampleProvider(id));
                            }
                            if (result == TrainCardAction.reschedule) {
                              final today = DateTime.now();
                              final tomorow = DateTime(
                                  today.year, today.month, today.day + 1);
                              final lastDay = DateTime(
                                  today.year, today.month + 1, today.day);
                              final newDate = await showDatePicker(
                                  context: context,
                                  initialDate: tomorow,
                                  firstDate: tomorow,
                                  lastDate: lastDay);
                              if (newDate != null) {
                                ref.watch(
                                  resheduleTrainSampleProvider(
                                    ResheduleTrainSampleRequest(
                                        id: id, date: newDate),
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.more_vert),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 20),
                child: _collapsedExercises(sample.sample),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _collapsedExercises(List<Exercise> exercises) {
    List<Row> rows = [];
    for (var el in exercises) {
      rows.add(Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              '${rows.length + 1}. ${el.name.capitalize()}',
              style: const TextStyle(fontSize: 18),
            ),
          )
        ],
      ));
    }
    return Column(
      key: const ValueKey('Calendar_collapse_exercises'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
