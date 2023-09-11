import 'package:app/application/riverpod/today/remove_today_train_provider.dart';
import 'package:app/application/riverpod/today/reshedule_today_train_provider.dart';
import 'package:app/features/shared/models/train_card_action_model.dart';
import 'package:app/routes.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/usecases/today/reshedule_today_train_use_case.dart';
import '../../domain/exercises/exercise.dart';
import '../../domain/models/sheduled_train_sample.dart';
import '../../application/usecases/today/remove_train_use_case.dart';
import '../shared/bottom_menu_widget.dart';
import '../shared/models/bottom_menu_model.dart';

class TodayTrainCard extends StatelessWidget {
  final SheduledTrainSample train;
  final List<SheduledTrainSample> prevTrains;
  const TodayTrainCard(
      {super.key, required this.train, required this.prevTrains});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightBlue,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 15),
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
                          ref.watch(removeTodayTrainProvider(
                              RemoveTodayTrainRequest(
                                  trainSample: train, prevTrains: prevTrains)));
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
                              resheduleTodayTrainProvider(
                                ResheduleTodayTrainRequest(
                                  id: train.id,
                                  date: newDate,
                                ),
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.5, 45),
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.main),
                  child: const Text(
                    'Сделать запись',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(Routes.TrainPageScreen, arguments: train);
                  },
                  style: TextButton.styleFrom(
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 45),
                      backgroundColor: AppColors.main,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
