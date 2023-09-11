import 'package:equatable/equatable.dart';

import 'package:app/application/usecases/use_case.dart';

import '../../../domain/repositories/sheduled_train_samples_repository.dart';

class ResheduleTodayTrainRequest extends Equatable {
  final String id;
  final DateTime date;
  const ResheduleTodayTrainRequest({
    required this.id,
    required this.date,
  });

  @override
  List<Object?> get props => [id];
}

class ResheduleTodayTrainUseCase
    extends UseCaseWithArgs<ResheduleTodayTrainRequest, void> {
  final SheduledTrainSamplesRepository repository;
  ResheduleTodayTrainUseCase({
    required this.repository,
  });

  @override
  Future<void> call(ResheduleTodayTrainRequest request) async {
    await repository.reschedule(request.id, request.date);
  }
}
