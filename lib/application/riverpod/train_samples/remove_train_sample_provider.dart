import 'package:app/application/riverpod/train_samples/train_samples_page_state.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../use_cases_riverpod_providers.dart';

final removeTrainSampleProvider =
    Provider.autoDispose.family((ref, String id) async {
  await Future.delayed(200.ms);
  final notifier = ref.read(trainSamplesPageStateNotifierProvider.notifier);
  final state = ref.read(trainSamplesPageStateNotifierProvider);
  if (state is LoadedTrainSamplesPageState ||
      state is FinishReloadTrainsSamplePageState) {
    notifier.reload(state.trains);
    final removeTrainUseCase = ref.read(removeTrainSampleUseCaseProvider);
    await removeTrainUseCase(id);
    final useCase = ref.read(getAllTrainSamplesUseCaseProvider);
    final trains = await useCase();
    notifier.finishReload(trains);
  }
});
