import 'package:app/domain/models/train_sample.dart';

///Obsolete
class SheduledTrainSample {
  final String id;
  final TrainSample trainSample;
  final DateTime date;
  SheduledTrainSample(
      {required this.id, required this.trainSample, required this.date});
}
