import 'dart:ffi';

import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/repositories/sheduled_train_samples_repository.dart';
import 'package:app/domain/repositories/train_info_repository.dart';
import 'package:app/domain/repositories/train_samples_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/models/train_info.dart';
import '../../../domain/models/train_sample.dart';
import '../../../shared/model/user_model.dart';
import '../../services/factory/create_exercise_service.dart';
import '../../services/train_samples_state.dart';

class CreateTrainSampleRequest extends Equatable {
  final UserModel user;
  final TrainSampleState state;
  const CreateTrainSampleRequest({required this.user, required this.state});

  @override
  List<Object?> get props => [user, state];
}

class CreateTrainSampleUseCase
    extends UseCaseWithArgs<CreateTrainSampleRequest, void> {
  final TrainSampleRepository trainSampleRepository;
  final TrainInfoRepository trainInfoRepository;
  final SheduledTrainSamplesRepository sheduledTrainSamplesRepository;

  CreateTrainSampleUseCase(
      {required this.trainInfoRepository,
      required this.trainSampleRepository,
      required this.sheduledTrainSamplesRepository});
  @override
  Future<void> call(CreateTrainSampleRequest request) async {
    final trainInfoId = await trainInfoRepository.insert(
        TrainInfo(shedule_type: request.state.trainScheduleType!),
        request.user);
    final exercises = request.state.exercisesState
        .map((item) => ExerciseFactory.createExerciseFromState(item))
        .toList();
    final trainsSample = TrainSample(
        sample: exercises,
        name: request.state.name!,
        train_info_id: trainInfoId);
    final sampleId =
        await trainSampleRepository.insert(trainsSample, request.user);
    await sheduledTrainSamplesRepository.sheduleTrain(
        sampleId, request.user.id!, request.state.trainDate!);
  }
}
