import 'package:app/features/shared/models/train_card_action_model.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exercises/exercise.dart';
import '../../domain/models/sheduled_train_sample.dart';
import '../../domain/repositories/providers/calendar_provider.dart';
import '../../domain/repositories/providers/today_provider.dart';
import '../shared/bottom_menu_widget.dart';
import '../shared/models/bottom_menu_model.dart';

class TodayTrainCard extends StatelessWidget {
  final SheduledTrainSample train;
  const TodayTrainCard({super.key, required this.train});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightBlue,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  train.trainSample.name.capitalize(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Consumer(
                  builder: ((context, ref, child) {
                    return IconButton(
                      onPressed: () async {
                        final result =
                            await showModalBottomSheet<TrainCardAction>(
                          context: context,
                          builder: (context) {
                            return BottomMenuWidget<TrainCardAction>(
                              model: BottomMenuModel(
                                items: [
                                  BottomMenuItem(
                                      value: TrainCardAction.reschedule,
                                      text: 'Перенести'),
                                  BottomMenuItem(
                                      value: TrainCardAction.remove,
                                      text: 'Удалить',
                                      textColor: Colors.red),
                                ],
                              ),
                            );
                          },
                        );
                        if (result == TrainCardAction.remove) {
                          ref.watch(removeTrainProvider(train));
                        }
                        if (result == TrainCardAction.reschedule) {
                          final today = DateTime.now();
                          final tomorow =
                              DateTime(today.year, today.month, today.day + 1);
                          final lastDay =
                              DateTime(today.year, today.month + 1, today.day);
                          final newDate = await showDatePicker(
                              context: context,
                              initialDate: tomorow,
                              firstDate: tomorow,
                              lastDate: lastDay);
                          if (newDate != null) {
                            ref.watch(
                              rescheduleTodayTrainProvider(
                                ResheduleRequest(id: train.id, date: newDate),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.more_vert),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 20),
            child: _collapsedExercises(train.trainSample.sample),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.main),
                  child: const Text(
                    'Сделать запись',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.main,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      foregroundColor: AppColors.white),
                  child: const Text(
                    'Начать',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          )
        ],
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
              el.name.capitalize(),
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
