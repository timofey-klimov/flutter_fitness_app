import 'package:app/application/usecases/use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/sheduled_train_sample.dart';
import '../../../domain/models/train_result.dart';
import '../../../domain/repositories/sheduled_train_samples_repository.dart';
import '../../../domain/repositories/train_results_repository.dart';

class RemoveTodayTrainRequest extends Equatable {
  final SheduledTrainSample trainSample;
  const RemoveTodayTrainRequest({
    required this.trainSample,
  });
  @override
  List<Object?> get props => [trainSample.id];
}

class RemoveTodayTrainUseCase
    extends UseCaseWithArgs<RemoveTodayTrainRequest, void> {
  final SheduledTrainSamplesRepository sheduledTrainSamplesRepository;
  final TrainResultsRepository trainResultsRepository;
  RemoveTodayTrainUseCase(
      {required this.sheduledTrainSamplesRepository,
      required this.trainResultsRepository});
  @override
  Future<void> call(RemoveTodayTrainRequest request) async {
    await sheduledTrainSamplesRepository.remove(request.trainSample.id);
    await trainResultsRepository.insert(TrainResult.removed(
        plan: request.trainSample.trainSample, date: request.trainSample.date));
  }
}
