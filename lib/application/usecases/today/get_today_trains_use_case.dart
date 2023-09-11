import 'package:app/shared/model/user_model.dart';

import '../../../domain/models/sheduled_train_sample.dart';
import '../../../domain/repositories/sheduled_train_samples_repository.dart';
import '../use_case.dart';

class GetTodayTrainsUseCase extends UseCase<List<SheduledTrainSample>> {
  final SheduledTrainSamplesRepository repository;
  final UserModel user;
  GetTodayTrainsUseCase({
    required this.repository,
    required this.user,
  });
  @override
  Future<List<SheduledTrainSample>> call() async {
    final result =
        await repository.getScheduledTrains(user.id!, DateTime.now());
    return result.values.isNotEmpty
        ? result.values.first
        : <SheduledTrainSample>[];
  }
}
