import 'dart:ui';

import 'package:app/features/calendar/widgets/range_header_widget.dart';
import 'package:app/features/calendar/widgets/single_day_header_widget.dart';
import 'package:app/features/calendar/widgets/trains_list_widget.dart';
import 'package:app/features/calendar/widgets/trains_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/riverpod/calendar/calendar_page_state.dart';
import '../../application/riverpod/calendar/pick_date.dart';
import '../../domain/models/sheduled_train_sample.dart';
import '../../shared/components/spinner.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(calendarPageStateNotifierProvider);
        final notifier = ref.read(calendarPageStateNotifierProvider.notifier);
        if (state is StartReloadCalendarPageState) {
          return ReloadingWidget(
            trains: state.prevTrains,
            pickDate: state.pickDateModel,
            onUpdate: (pickModel) => notifier.reloadDate(model: pickModel),
          );
        }

        if (state is FinishReloadCalendarPageState) {
          return LoadedDataWidget(
            trains: state.trains,
            pickDate: state.pickDateModel,
            onUpdate: (pickModel) => notifier.reloadDate(model: pickModel),
          );
        }
        return GetTrainsByDateWidget(
          pickDate: state.pickDateModel,
          onUpdate: (pickModel) => notifier.reloadDate(model: pickModel),
        );
      },
    );
  }
}

class GetTrainsByDateWidget extends StatelessWidget {
  final PickDateModel pickDate;
  final Function(PickDateModel) onUpdate;
  const GetTrainsByDateWidget(
      {super.key, required this.pickDate, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pickDate.type == PickDateType.single
              ? SingleDayHeaderWidget(
                  pickedDate: pickDate,
                  onUpdate: (pickDate) => onUpdate(pickDate))
              : RangeHeaderWidget(
                  pickedDate: pickDate, onUpdate: (pick) => onUpdate(pick)),
        ),
        Expanded(
          child: Trains(
            pickDate: pickDate,
          ),
        )
      ],
    );
  }
}

class ReloadingWidget extends StatelessWidget {
  final PickDateModel pickDate;
  final Map<DateTime, List<SheduledTrainSample>> trains;
  final Function(PickDateModel) onUpdate;
  const ReloadingWidget(
      {super.key,
      required this.trains,
      required this.pickDate,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Flex(
          direction: Axis.vertical,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pickDate.type == PickDateType.single
                  ? SingleDayHeaderWidget(
                      pickedDate: pickDate,
                      onUpdate: (pickDate) => onUpdate(pickDate))
                  : RangeHeaderWidget(
                      pickedDate: pickDate, onUpdate: (pick) => onUpdate(pick)),
            ),
            Expanded(
              child: TrainsListWidget(
                trains: trains,
                isRange: pickDate.type == PickDateType.range,
              ),
            ),
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

class LoadedDataWidget extends StatelessWidget {
  final PickDateModel pickDate;
  final Map<DateTime, List<SheduledTrainSample>> trains;
  final Function(PickDateModel) onUpdate;
  const LoadedDataWidget(
      {super.key,
      required this.pickDate,
      required this.trains,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: pickDate.type == PickDateType.single
              ? SingleDayHeaderWidget(
                  pickedDate: pickDate,
                  onUpdate: (pickDate) => onUpdate(pickDate))
              : RangeHeaderWidget(
                  pickedDate: pickDate, onUpdate: (pick) => onUpdate(pick)),
        ),
        Expanded(
          child: TrainsListWidget(
            trains: trains,
            isRange: pickDate.type == PickDateType.range,
          ),
        ),
      ],
    );
  }
}
