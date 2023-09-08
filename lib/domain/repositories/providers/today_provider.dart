import 'dart:async';

import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/domain/models/train_result.dart';
import 'package:app/domain/repositories/providers/calendar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/auth_provider.dart';
import '../sheduled_train_samples_repository.dart';
import '../train_results_repository.dart';

final getTodayTrainsProvider = FutureProvider.autoDispose(
  (ref) async {
    final provider = ref.read(sheduledTrainSampleRepositoryProvider);
    final user = ref.read(appUserProvider);
    final result = await provider.getScheduledTrains(user.id!, DateTime.now());
    return result.values.isNotEmpty
        ? result.values.first
        : <SheduledTrainSample>[];
  },
);

final removeTrainProvider = FutureProvider.autoDispose.family(
  (ref, SheduledTrainSample trainSample) async {
    ref.read(todayPageStream).sink.add(LoadingEvent());
    ref.invalidate(getTodayTrainsProvider);
    final sheduledTrainSampleRepository =
        ref.read(sheduledTrainSampleRepositoryProvider);
    await sheduledTrainSampleRepository.remove(trainSample.id);
    final trainResultsRepository = ref.read(trainResultsRepositoryProvider);
    await trainResultsRepository
        .insert(TrainResult.removed(plan: trainSample.trainSample));
    ref.read(todayPageStream).sink.add(ReadyEvent());
  },
);

final rescheduleTodayTrainProvider =
    FutureProvider.autoDispose.family((ref, ResheduleRequest request) async {
  ref.read(todayPageStream).sink.add(LoadingEvent());
  ref.invalidate(getTodayTrainsProvider);
  final provider = ref.read(sheduledTrainSampleRepositoryProvider);
  await provider.reschedule(request.id, request.date);
  await Future.delayed(Duration(milliseconds: 300));
  ref.read(todayPageStream).sink.add(ReadyEvent());
});

final todayPageStream = Provider((ref) => StreamController<TodayPageEvent>());
final todayPageStreamProvider =
    StreamProvider((ref) => ref.watch(todayPageStream).stream);

abstract class TodayPageEvent {}

class ReadyEvent extends TodayPageEvent {}

class LoadingEvent extends TodayPageEvent {}
