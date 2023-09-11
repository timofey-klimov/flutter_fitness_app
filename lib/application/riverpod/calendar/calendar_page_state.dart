import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/application/riverpod/calendar/pick_date.dart';

import '../../../domain/models/sheduled_train_sample.dart';

abstract class CalendarPageState {
  final PickDateModel pickDateModel;
  final Map<DateTime, List<SheduledTrainSample>> trains;
  CalendarPageState({required this.pickDateModel, required this.trains});
}

class LoadedCalendarPageState extends CalendarPageState {
  LoadedCalendarPageState(
      {required super.trains, required super.pickDateModel});
}

class StartReloadCalendarPageState extends CalendarPageState {
  StartReloadCalendarPageState(
      {required super.trains, required super.pickDateModel});
}

class TrainsByDateCalendarPageState extends CalendarPageState {
  TrainsByDateCalendarPageState({required super.pickDateModel})
      : super(trains: {});
}

class FinishReloadCalendarPageState extends CalendarPageState {
  FinishReloadCalendarPageState(
      {required super.trains, required super.pickDateModel});
}

class CalendarPageStateNotifier extends StateNotifier<CalendarPageState> {
  CalendarPageStateNotifier()
      : super(TrainsByDateCalendarPageState(
            pickDateModel: PickDateModel.initial()));

  void dataLoaded(
      {required Map<DateTime, List<SheduledTrainSample>> trains,
      required PickDateModel pickDateModel}) {
    state =
        LoadedCalendarPageState(trains: trains, pickDateModel: pickDateModel);
  }

  void startReload(
      {required Map<DateTime, List<SheduledTrainSample>> prevTrains,
      required PickDateModel model}) {
    state =
        StartReloadCalendarPageState(trains: prevTrains, pickDateModel: model);
  }

  void finishReload(
      {required Map<DateTime, List<SheduledTrainSample>> trains,
      required PickDateModel model}) {
    state = FinishReloadCalendarPageState(trains: trains, pickDateModel: model);
  }

  void reloadDate({required PickDateModel model}) {
    state = TrainsByDateCalendarPageState(pickDateModel: model);
  }
}

final calendarPageStateNotifierProvider = StateNotifierProvider.autoDispose<
    CalendarPageStateNotifier,
    CalendarPageState>((ref) => CalendarPageStateNotifier());
