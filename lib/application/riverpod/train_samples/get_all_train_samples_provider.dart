import 'package:app/application/riverpod/train_samples/train_samples_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../use_cases_riverpod_providers.dart';

final getAllTrainSamplesProvider = FutureProvider.autoDispose((ref) async {
  final useCase = ref.read(getAllTrainSamplesUseCaseProvider);
  final trains = await useCase();
  final notifier = ref.read(trainSamplesPageStateNotifierProvider.notifier);
  notifier.loadData(trains);
  return trains;
});
