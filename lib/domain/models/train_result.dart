import 'dart:convert';

import 'package:app/domain/models/train_sample.dart';
import 'package:equatable/equatable.dart';


///Obsolete
enum TrainResultStatus { finished, removed }

class TrainResult extends Equatable {
  final String? id;
  final TrainResultStatus status;
  final TrainSample? plan;
  final TrainSample? fact;
  final DateTime date;
  TrainResult(
      {this.id,
      required this.status,
      this.plan,
      this.fact,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.toString(),
      'plan': plan?.toMap(),
      'fact': fact?.toMap(),
      'train_date': date.toIso8601String()
    };
  }

  factory TrainResult.finished(
      {required TrainSample plan,
      required TrainSample fact,
      required DateTime date}) {
    return TrainResult(
        status: TrainResultStatus.finished, plan: plan, fact: fact, date: date);
  }
  factory TrainResult.removed(
          {required TrainSample plan, required DateTime date}) =>
      TrainResult(status: TrainResultStatus.removed, plan: plan, date: date);

  factory TrainResult.fromMap(Map<String, dynamic> map) {
    return TrainResult(
      id: map['id'],
      status: createStatus(map['status']),
      plan: TrainSample.fromMap(map['plan']),
      fact: TrainSample.fromMap(map['fact']),
      date: DateTime.fromMillisecondsSinceEpoch(map['train_date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TrainResult.fromJson(String source) =>
      TrainResult.fromMap(json.decode(source));

  static createStatus(String status) {
    for (var el in TrainResultStatus.values) {
      if (el.toString() == status) return el;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
