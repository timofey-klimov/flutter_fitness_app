import 'package:app/application/riverpod/repository_riverpod_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/auth_provider.dart';
import '../usecases/calendar/get_train_samples_by_date_use_case.dart';
import '../usecases/calendar/remove_sheduled_train_use_case.dart';
import '../usecases/calendar/reshedule_train_sample_use_case.dart';
import '../usecases/today/get_today_trains_use_case.dart';
import '../usecases/today/remove_train_use_case.dart';
import '../usecases/today/reshedule_today_train_use_case.dart';
import '../usecases/train_samples/create_train_sample_use_case.dart';
import '../usecases/train_samples/get_all_train_samples_use_case.dart';
import '../usecases/train_samples/remove_train_sample_use_case.dart';

final getTodayTrainsUseCaseProvider = Provider(
  (ref) => GetTodayTrainsUseCase(
    repository: ref.read(sheduledTrainSampleRepositoryProvider),
    user: ref.read(appUserProvider),
  ),
);

final removeTodayTrainUseCaseProvider = Provider(
  (ref) => RemoveTodayTrainUseCase(
    sheduledTrainSamplesRepository:
        ref.read(sheduledTrainSampleRepositoryProvider),
    trainResultsRepository: ref.read(trainResultsRepositoryProvider),
  ),
);

final resheduleTodayTrainUseCaseProvider = Provider(
  (ref) => ResheduleTodayTrainUseCase(
    repository: ref.read(sheduledTrainSampleRepositoryProvider),
  ),
);

final createTrainSampleUseCaseProvider = Provider(
  (ref) => CreateTrainSampleUseCase(
    trainInfoRepository: ref.read(trainInfoRepositoryProvider),
    trainSampleRepository: ref.read(trainSampleRepositoryProvider),
    sheduledTrainSamplesRepository:
        ref.read(sheduledTrainSampleRepositoryProvider),
  ),
);

final getTrainSamplesByDateUseCaseProvider = Provider(
  (ref) => GetTrainSamplesByDateUseCase(
    repository: ref.read(sheduledTrainSampleRepositoryProvider),
    user: ref.read(appUserProvider),
  ),
);

final removeSheduleTrainUseCaseProvider = Provider(
  (ref) => RemoveSheduledTrainUseCase(
    repository: ref.read(sheduledTrainSampleRepositoryProvider),
  ),
);

final resheduleTrainUseCaseProvider = Provider(
  (ref) => ResheduleTrainSampleUseCase(
    repository: ref.read(sheduledTrainSampleRepositoryProvider),
  ),
);

final getAllTrainSamplesUseCaseProvider = Provider(
  (ref) => GetAllTrainSamplesUseCase(
    repository: ref.read(trainInfoRepositoryProvider),
  ),
);

final removeTrainSampleUseCaseProvider = Provider(
  (ref) => RemoveTrainSampleUseCase(
    trainInfoRepository: ref.read(trainInfoRepositoryProvider),
  ),
);
