import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/models/sheduled_train_sample.dart';

abstract class TodayPageState {}

class EmptyState extends TodayPageState {}

class TodayPageLoadedState extends TodayPageState {
  final List<SheduledTrainSample> trains;
  TodayPageLoadedState({
    required this.trains,
  });
}

class TodayPageStartReloadState extends TodayPageState {
  final List<SheduledTrainSample> trains;
  TodayPageStartReloadState({
    required this.trains,
  });
}

class TodayPageFinishReloadState extends TodayPageState {
  final List<SheduledTrainSample> trains;
  TodayPageFinishReloadState({
    required this.trains,
  });
}

class TodayPageStateNotifier extends StateNotifier<TodayPageState> {
  TodayPageStateNotifier() : super(EmptyState());

  void dataLoading(List<SheduledTrainSample> trains) {
    state = TodayPageLoadedState(trains: trains);
  }

  void startReload(List<SheduledTrainSample> prevTrains) {
    state = TodayPageStartReloadState(trains: prevTrains);
  }

  void finishReload(List<SheduledTrainSample> resheduledTrains) {
    state = TodayPageFinishReloadState(trains: resheduledTrains);
  }
}

final todayPageStateProvider =
    StateNotifierProvider.autoDispose<TodayPageStateNotifier, TodayPageState>(
        (ref) => TodayPageStateNotifier());
