import 'package:app/domain/models/train.dart';
import 'package:flutter/material.dart';

abstract interface class ITrainRepository {
  Future createTrain(Train train, String userId);
  Future<Map<DateTime, List<Train>>> getTrains(DateTimeRange range, String userId);
}