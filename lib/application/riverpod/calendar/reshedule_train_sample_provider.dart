import 'package:app/shared/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../usecases/calendar/get_train_samples_by_date_use_case.dart';
import '../../usecases/calendar/reshedule_train_sample_use_case.dart';
import '../use_cases_riverpod_providers.dart';
import 'calendar_page_state.dart';

final resheduleTrainSampleProvider = Provider.autoDispose.family(
  (ref, ResheduleTrainSampleRequest request) async {
    await Future.delayed(300.ms);
    final state = ref.read(calendarPageStateNotifierProvider);
    final stateNotifier = ref.read(calendarPageStateNotifierProvider.notifier);
    if (state is LoadedCalendarPageState ||
        state is FinishReloadCalendarPageState) {
      stateNotifier.startReload(
          prevTrains: state.trains, model: state.pickDateModel);
      final resheduleUseCase = ref.read(resheduleTrainUseCaseProvider);
      await resheduleUseCase(request);
      final getTrainsUseCase = ref.read(getTrainSamplesByDateUseCaseProvider);
      final trains = await getTrainsUseCase(GetTrainsByDateRequest(
          startDate: state.pickDateModel.start,
          endDate: state.pickDateModel.end));
      stateNotifier.finishReload(trains: trains, model: state.pickDateModel);
    }
  },
);
