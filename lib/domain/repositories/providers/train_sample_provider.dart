import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/model/user_model.dart';
import '../../models/train_sample.dart';
import '../../models/train_shedule.dart';
import '../../services/create_exercise_service.dart';
import '../../services/train_samples_state.dart';
import '../train_calendar_repository.dart';
import '../train_samples_repository.dart';
import '../train_shedules_repository.dart';

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
  final trainScheduleRepository = ref.read(trainScheduleRepositoryProvider);
  final trainsCalendarRepository = ref.read(trainCalendarRepositoryProvider);
  final exercises = request.state.exercisesState
      .map((item) => ExerciseFactory.createExerciseFromState(item))
      .toList();
  final trainsSample =
      TrainSample(sample: exercises, name: request.state.name!);
  final sampleId =
      await trainSampleRepository.insert(trainsSample, request.user);
  if (sampleId.isEmpty == true) throw Error();
  await trainScheduleRepository.insert(
      TrainSchedule(
          sample_id: sampleId, shedule_type: request.state.trainScheduleType!),
      request.user);
  await trainsCalendarRepository.sheduleTrain(
      sampleId, request.user.id!, request.state.trainDate!);
});
