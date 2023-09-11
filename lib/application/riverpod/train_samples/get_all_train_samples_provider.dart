import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../use_cases_riverpod_providers.dart';

final getAllTrainSamplesProvider = FutureProvider.autoDispose((ref) async {
  final useCase = ref.read(getAllTrainSamplesUseCaseProvider);
  return await useCase();
});
