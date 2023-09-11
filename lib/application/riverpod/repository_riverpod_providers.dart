import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/sheduled_train_samples_repository.dart';
import '../../domain/repositories/train_info_repository.dart';
import '../../domain/repositories/train_results_repository.dart';
import '../../domain/repositories/train_samples_repository.dart';
import '../../shared/supabase_provider.dart';

final sheduledTrainSampleRepositoryProvider = Provider(
  (ref) => SheduledTrainSamplesRepository(client: ref.read(supabaseProvider)),
);

final trainInfoRepositoryProvider = Provider(
  (ref) => TrainInfoRepository(client: ref.read(supabaseProvider)),
);

final trainResultsRepositoryProvider = Provider(
  (ref) => TrainResultsRepository(client: ref.read(supabaseProvider)),
);

final trainSampleRepositoryProvider = Provider(
  (ref) => TrainSampleRepository(client: ref.read(supabaseProvider)),
);
