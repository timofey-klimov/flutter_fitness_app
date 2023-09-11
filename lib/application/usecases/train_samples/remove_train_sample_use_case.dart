import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/repositories/train_info_repository.dart';

class RemoveTrainSampleUseCase extends UseCaseWithArgs<String, void> {
  final TrainInfoRepository trainInfoRepository;
  RemoveTrainSampleUseCase({
    required this.trainInfoRepository,
  });
  @override
  Future<void> call(String request) async {
    await trainInfoRepository.remove(request);
  }
}
