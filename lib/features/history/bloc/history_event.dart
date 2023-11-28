import 'dart:async';

import 'package:app/features/history/model/pick_date_model.dart';
import 'package:equatable/equatable.dart';

abstract interface class HistoryEvent extends Equatable {
  HistoryEvent();
}

class LoadingHistoryEvent extends HistoryEvent {
  final PickDateModel? pickDateModel;
  final String userId;
  LoadingHistoryEvent({this.pickDateModel, required this.userId});
  @override
  // TODO: implement props
  List<Object?> get props => [pickDateModel, userId];

}

class LoadedHistoryEvent extends HistoryEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RefreshHistoryEvent extends HistoryEvent {
  final Completer completer;
  final PickDateModel pickDateModel;
  final String userId;
  RefreshHistoryEvent({required this.completer, required this.pickDateModel, required this.userId});
  @override
  // TODO: implement props
  List<Object?> get props => [];

}