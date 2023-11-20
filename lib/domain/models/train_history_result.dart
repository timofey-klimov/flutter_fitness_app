import 'package:app/domain/models/train_sample.dart';

class TrainHistoryResult {
  final String id;
  final DateTime createDate;
  final TrainSample trainSample;
  final String uuid;
  TrainHistoryResult({required this.id, required this.trainSample, required this.createDate, required this.uuid});
}