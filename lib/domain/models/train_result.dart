import 'dart:convert';

import 'package:app/domain/models/train_sample.dart';
import 'package:equatable/equatable.dart';

enum TrainResultStatus { finished, removed }

class TrainResult extends Equatable {
  final String? id;
  final TrainResultStatus status;
  final TrainSample? plan;
  final TrainSample? fact;
  //заполняется в бд
  final DateTime? trainDate;
  TrainResult(
      {this.id, required this.status, this.plan, this.fact, this.trainDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.toString(),
      'plan': plan?.toMap(),
      'fact': fact?.toMap(),
    };
  }

  factory TrainResult.finished(
      {required TrainSample plan, required TrainSample fact}) {
    return TrainResult(
        status: TrainResultStatus.finished, plan: plan, fact: fact);
  }
  factory TrainResult.removed({required TrainSample plan}) =>
      TrainResult(status: TrainResultStatus.removed, plan: plan);

  factory TrainResult.fromMap(Map<String, dynamic> map) {
    return TrainResult(
      id: map['id'],
      status: createStatus(map['status']),
      plan: TrainSample.fromMap(map['plan']),
      fact: TrainSample.fromMap(map['fact']),
      trainDate: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
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
