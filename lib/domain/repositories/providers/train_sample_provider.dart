import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/model/user_model.dart';
import '../../models/train_sample.dart';
import '../../models/train_info.dart';
import '../../services/factory/create_exercise_service.dart';
import '../../services/train_samples_state.dart';
import '../sheduled_train_samples_repository.dart';
import '../train_samples_repository.dart';
import '../train_info_repository.dart';

class CraeteTrainSampleRequest extends Equatable {
  final UserModel user;
  final TrainSampleState state;
  const CraeteTrainSampleRequest({required this.user, required this.state});

  @override
  List<Object?> get props => [user, state];
}

final createTrainSampleProvider = FutureProvider.autoDispose
    .family((ref, CraeteTrainSampleRequest request) async {
  final trainSampleRepository = ref.read(trainSampleRepositoryProvider);
  final trainInfoRepository = ref.read(trainInfoRepositoryProvider);
  final sheduledTrainSampleRepository =
      ref.read(sheduledTrainSampleRepositoryProvider);
  final exercises = request.state.exercisesState
      .map((item) => ExerciseFactory.createExerciseFromState(item))
      .toList();
  final trainsSample =
      TrainSample(sample: exercises, name: request.state.name!);
  final sampleId =
      await trainSampleRepository.insert(trainsSample, request.user);
  if (sampleId.isEmpty == true) throw Error();
  await trainInfoRepository.insert(
      TrainInfo(
          sample_id: sampleId, shedule_type: request.state.trainScheduleType!),
      request.user);
  await sheduledTrainSampleRepository.sheduleTrain(
      sampleId, request.user.id!, request.state.trainDate!);
});
