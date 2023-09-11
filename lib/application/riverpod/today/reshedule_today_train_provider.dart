import 'package:app/application/usecases/today/reshedule_today_train_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'today_page_state.dart';
import '../use_cases_riverpod_providers.dart';

final resheduleTodayTrainProvider = Provider.autoDispose
    .family((ref, ResheduleTodayTrainRequest request) async {
  await Future.delayed(const Duration(milliseconds: 300));
  final notifier = ref.read(todayPageStateProvider.notifier);
  final state = ref.read(todayPageStateProvider);
  if (state is TodayPageLoadedState || state is TodayPageFinishReloadState) {
    notifier.startReload(state.trains!);
    final resheduleUseCase = ref.read(resheduleTodayTrainUseCaseProvider);
    await resheduleUseCase(request);
    final getTrainsUseCase = ref.read(getTodayTrainsUseCaseProvider);
    notifier.finishReload(await getTrainsUseCase());
  }
});
