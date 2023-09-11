import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/application/riverpod/calendar/pick_date.dart';

import '../../../domain/models/sheduled_train_sample.dart';

abstract class CalendarPageState {
  final PickDateModel pickDateModel;
  CalendarPageState({
    required this.pickDateModel,
  });
}

class LoadedCalendarPageState extends CalendarPageState {
  final Map<DateTime, List<SheduledTrainSample>> trains;
  LoadedCalendarPageState({required this.trains, required super.pickDateModel});
}

class StartReloadCalendarPageState extends CalendarPageState {
  final Map<DateTime, List<SheduledTrainSample>> prevTrains;
  StartReloadCalendarPageState(
      {required this.prevTrains, required super.pickDateModel});
}

class TrainsByDateCalendarPageState extends CalendarPageState {
  TrainsByDateCalendarPageState({required super.pickDateModel});
}

class FinishReloadCalendarPageState extends CalendarPageState {
  final Map<DateTime, List<SheduledTrainSample>> trains;
  FinishReloadCalendarPageState(
      {required this.trains, required super.pickDateModel});
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
    state = StartReloadCalendarPageState(
        prevTrains: prevTrains, pickDateModel: model);
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

final calendarPageStateNotifierProvider =
    StateNotifierProvider<CalendarPageStateNotifier, CalendarPageState>(
        (ref) => CalendarPageStateNotifier());
