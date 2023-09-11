import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/train_info.dart';

abstract class TrainSamplesPageState {
  final List<TrainInfo> trains;
  TrainSamplesPageState({
    required this.trains,
  });
}

class EmptyTrainSamplesPageState extends TrainSamplesPageState {
  EmptyTrainSamplesPageState({required super.trains});
}

class LoadedTrainSamplesPageState extends TrainSamplesPageState {
  LoadedTrainSamplesPageState({
    required super.trains,
  });
}

class ReloadTrainsSamplesPageState extends TrainSamplesPageState {
  ReloadTrainsSamplesPageState({
    required super.trains,
  });
}

class FinishReloadTrainsSamplePageState extends TrainSamplesPageState {
  FinishReloadTrainsSamplePageState({
    required super.trains,
  });
}

class TrainSamplesPageStateNotifier
    extends StateNotifier<TrainSamplesPageState> {
  TrainSamplesPageStateNotifier()
      : super(EmptyTrainSamplesPageState(trains: []));

  void loadData(List<TrainInfo> trains) {
    state = LoadedTrainSamplesPageState(trains: trains);
  }

  void reload(List<TrainInfo> prevTrains) {
    state = ReloadTrainsSamplesPageState(trains: prevTrains);
  }

  void finishReload(List<TrainInfo> trains) {
    state = FinishReloadTrainsSamplePageState(trains: trains);
  }
}

final trainSamplesPageStateNotifierProvider = StateNotifierProvider.autoDispose<
    TrainSamplesPageStateNotifier,
    TrainSamplesPageState>((ref) => TrainSamplesPageStateNotifier());
