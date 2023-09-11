import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/shared/extensions.dart';

import '../../usecases/calendar/get_train_samples_by_date_use_case.dart';
import '../use_cases_riverpod_providers.dart';
import 'calendar_page_state.dart';

final removeSheduledTrainSampleProvider = Provider.autoDispose.family(
  (ref, String id) async {
    await Future.delayed(300.ms);
    final state = ref.read(calendarPageStateNotifierProvider);
    final stateNotifier = ref.read(calendarPageStateNotifierProvider.notifier);
    if (state is LoadedCalendarPageState) {
      stateNotifier.startReload(
          prevTrains: state.trains, model: state.pickDateModel);
      final removeUseCase = ref.read(removeSheduleTrainUseCaseProvider);
      await removeUseCase(id);
      final getTrainsUseCase = ref.read(getTrainSamplesByDateUseCaseProvider);
      final trains = await getTrainsUseCase(GetTrainsByDateRequest(
          startDate: state.pickDateModel.start,
          endDate: state.pickDateModel.end));
      stateNotifier.finishReload(trains: trains, model: state.pickDateModel);
    }
  },
);
