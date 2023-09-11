import 'dart:ui';

import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/features/today/today_train.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/components/spinner.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/riverpod/today/get_today_trains_provider.dart';
import '../../application/riverpod/today/today_page_state.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(todayPageStateProvider);
        if (state is TodayPageStartReloadState) {
          return LoadingWidget(
            trains: state.trains,
          );
        }

        if (state is TodayPageFinishReloadState) {
          return ReloadTrainsWidget(
            trains: state.trains,
          );
        }

        return const GetTrainsWidget();
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final List<SheduledTrainSample> trains;
  const LoadingWidget({super.key, required this.trains});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  DateFormat('MMMMEEEEd', 'ru')
                      .format(DateTime.now())
                      .capitalize(),
                  style: TextStyle(color: AppColors.main, fontSize: 22),
                ),
              ),
            ),
            Expanded(
              child: trains.isNotEmpty
                  ? Center(
                      child: TodayTrain(
                        trains: trains,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Нет тренировок на сегодня',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            )
          ],
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Spinner(),
          ),
        )
      ],
    );
  }
}

class GetTrainsWidget extends StatelessWidget {
  const GetTrainsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              DateFormat('MMMMEEEEd', 'ru').format(DateTime.now()).capitalize(),
              style: TextStyle(color: AppColors.main, fontSize: 22),
            ),
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (ctx, ref, child) {
              final result = ref.watch(getTodayTrainsProvider);
              return result.when(
                  data: (data) => data.isNotEmpty
                      ? Center(
                          child: TodayTrain(
                            trains: data,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Нет тренировок на сегодня',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                  error: (error, stackTrace) => Container(),
                  loading: () => const Center(
                        child: Spinner(),
                      ));
            },
          ),
        )
      ],
    );
  }
}

class ReloadTrainsWidget extends StatelessWidget {
  final List<SheduledTrainSample> trains;
  const ReloadTrainsWidget({super.key, required this.trains});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              DateFormat('MMMMEEEEd', 'ru').format(DateTime.now()).capitalize(),
              style: TextStyle(color: AppColors.main, fontSize: 22),
            ),
          ),
        ),
        Expanded(
          child: trains.isNotEmpty
              ? Center(
                  child: TodayTrain(
                    trains: trains,
                  ),
                )
              : const Center(
                  child: Text(
                    'Нет тренировок на сегодня',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
        )
      ],
    );
  }
}
