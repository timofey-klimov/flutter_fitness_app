import 'package:app/domain/repositories/train_samples_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/model/user_model.dart';
import '../models/train_shedule.dart';
import 'train_shedules_repository.dart';

class CraeteTrainSampleRequest extends Equatable {
  final UserModel user;
  final TrainSample trainSample;
  final TrainScheduleTypes scheduleType;
  const CraeteTrainSampleRequest({
    required this.user,
    required this.trainSample,
    required this.scheduleType,
  });

  @override
  List<Object?> get props => [user, trainSample, scheduleType];
}

final createTrainSampleProvider = FutureProvider.autoDispose
    .family((ref, CraeteTrainSampleRequest request) async {
  final trainSampleRepository = ref.read(trainSampleRepositoryProvider);
  final trainScheduleRepository = ref.read(trainScheduleRepositoryProvider);
  final sampleId =
      await trainSampleRepository.insert(request.trainSample, request.user);
  if (sampleId.isEmpty == true) throw Error();
  await trainScheduleRepository.insert(
      TrainSchedule(sample_id: sampleId, shedule_type: request.scheduleType));
});
