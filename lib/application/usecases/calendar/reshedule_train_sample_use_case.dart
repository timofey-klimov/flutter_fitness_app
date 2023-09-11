import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/repositories/sheduled_train_samples_repository.dart';
import 'package:equatable/equatable.dart';

class ResheduleTrainSampleRequest extends Equatable {
  final String id;
  final DateTime date;
  const ResheduleTrainSampleRequest({
    required this.id,
    required this.date,
  });
  @override
  List<Object?> get props => [id];
}

class ResheduleTrainSampleUseCase
    extends UseCaseWithArgs<ResheduleTrainSampleRequest, void> {
  final SheduledTrainSamplesRepository repository;
  ResheduleTrainSampleUseCase({required this.repository});
  @override
  Future<void> call(ResheduleTrainSampleRequest request) async {
    await repository.reschedule(request.id, request.date);
  }
}
