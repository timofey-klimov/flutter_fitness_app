import 'package:app/application/riverpod/today/today_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../use_cases_riverpod_providers.dart';

final getTodayTrainsProvider = FutureProvider.autoDispose(
  (ref) async {
    final useCase = ref.read(getTodayTrainsUseCaseProvider);
    final trains = await useCase();
    ref.read(todayPageStateProvider.notifier).dataLoading(trains);
    return trains;
  },
);
