import 'package:app/application/usecases/use_case.dart';
import 'package:app/domain/models/train_info.dart';
import 'package:app/domain/repositories/train_info_repository.dart';

class GetAllTrainSamplesUseCase extends UseCase<List<TrainInfo>> {
  final TrainInfoRepository repository;
  GetAllTrainSamplesUseCase({
    required this.repository,
  });
  @override
  Future<List<TrainInfo>> call() async {
    return await repository.getAllWithSamples();
  }
}
