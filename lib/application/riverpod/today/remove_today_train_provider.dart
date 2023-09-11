import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../usecases/today/remove_train_use_case.dart';
import 'today_page_state.dart';
import '../use_cases_riverpod_providers.dart';

final removeTodayTrainProvider = Provider.autoDispose.family(
  (ref, RemoveTodayTrainRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final notifier = ref.read(todayPageStateProvider.notifier);
    notifier.startReload(request.prevTrains);
    final removeTodayTrainUseCase = ref.read(removeTodayTrainUseCaseProvider);
    await removeTodayTrainUseCase(request);
    final getTrainsUseCase = ref.read(getTodayTrainsUseCaseProvider);
    notifier.finishReload(await getTrainsUseCase());
  },
);
