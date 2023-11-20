import 'package:app/domain/models/train_history_result.dart';
import 'package:flutter/material.dart';

class TrainHistory {
  final DateTimeRange dateTimeRange;
  final List<TrainHistoryResult> results;

  TrainHistory({required this.dateTimeRange, required this.results});
}