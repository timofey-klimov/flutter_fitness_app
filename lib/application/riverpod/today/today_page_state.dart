import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/models/sheduled_train_sample.dart';

abstract class TodayPageState {
  final List<SheduledTrainSample> trains;
  TodayPageState({
    required this.trains,
  });
}

class EmptyState extends TodayPageState {
  EmptyState() : super(trains: []);
}

class TodayPageLoadedState extends TodayPageState {
  TodayPageLoadedState({
    required super.trains,
  });
}

class TodayPageStartReloadState extends TodayPageState {
  TodayPageStartReloadState({
    required super.trains,
  });
}

class TodayPageFinishReloadState extends TodayPageState {
  TodayPageFinishReloadState({
    required super.trains,
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
