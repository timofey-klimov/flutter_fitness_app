import 'package:app/features/history/model/pick_date_model.dart';
import 'package:equatable/equatable.dart';

abstract interface class HistoryEvent extends Equatable {
  HistoryEvent();
}

class LoadingHistoryEvent extends HistoryEvent {
  final PickDateModel? pickDateModel;

  LoadingHistoryEvent({this.pickDateModel});
  @override
  // TODO: implement props
  List<Object?> get props => [pickDateModel];

}

class LoadedHistoryEvent extends HistoryEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}