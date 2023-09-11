import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../usecases/train_samples/create_train_sample_use_case.dart';
import '../use_cases_riverpod_providers.dart';

final createTrainSampleProvider = FutureProvider.autoDispose
    .family((ref, CreateTrainSampleRequest request) async {
  final useCase = ref.read(createTrainSampleUseCaseProvider);
  return await useCase(request);
});
