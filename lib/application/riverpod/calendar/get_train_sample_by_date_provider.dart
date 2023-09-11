import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../usecases/calendar/get_train_samples_by_date_use_case.dart';
import '../use_cases_riverpod_providers.dart';
import 'calendar_page_state.dart';

final getTrainSamplesByDateProvider = FutureProvider.autoDispose.family(
  (ref, GetTrainsByDateRequest request) async {
    final useCase = ref.read(getTrainSamplesByDateUseCaseProvider);
    final trains = await useCase(request);
    final notifier = ref.read(calendarPageStateNotifierProvider.notifier);
    final state = ref.read(calendarPageStateNotifierProvider);
    notifier.dataLoaded(trains: trains, pickDateModel: state.pickDateModel);
    return trains;
  },
);
