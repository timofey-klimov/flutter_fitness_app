import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/domain/repositories/sheduled_train_samples_repository.dart';
import 'package:app/shared/model/user_model.dart';
import 'package:equatable/equatable.dart';

class GetTrainsByDateRequest extends Equatable {
  final DateTime startDate;
  final DateTime? endDate;
  const GetTrainsByDateRequest({
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class GetTrainSamplesByDateUseCase extends UseCaseWithArgs<
    GetTrainsByDateRequest, Map<DateTime, List<SheduledTrainSample>>> {
  final SheduledTrainSamplesRepository repository;
  final UserModel user;
  GetTrainSamplesByDateUseCase({required this.repository, required this.user});

  @override
  Future<Map<DateTime, List<SheduledTrainSample>>> call(
      GetTrainsByDateRequest request) async {
    return await repository.getScheduledTrains(user.id!, request.startDate,
        end: request.endDate);
  }
}
