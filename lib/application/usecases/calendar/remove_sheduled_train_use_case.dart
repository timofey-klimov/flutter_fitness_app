import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/repositories/sheduled_train_samples_repository.dart';

class RemoveSheduledTrainUseCase extends UseCaseWithArgs<String, void> {
  final SheduledTrainSamplesRepository repository;
  RemoveSheduledTrainUseCase({required this.repository});
  @override
  Future<void> call(String request) async {
    await repository.remove(request);
  }
}
