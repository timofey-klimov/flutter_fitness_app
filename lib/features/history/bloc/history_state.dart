import 'package:app/features/history/model/pick_date_model.dart';
import 'package:equatable/equatable.dart';

abstract interface class HistoryState extends Equatable {
  HistoryState();
}

class InitialHistoryState extends HistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingHistoryState extends HistoryState {
  final PickDateModel? pickDateModel;
  LoadingHistoryState({this.pickDateModel});
  
  @override
  // TODO: implement props
  List<Object?> get props => [pickDateModel];
}

class LoadedHistoryState extends HistoryState {
  final PickDateModel pickDateModel;
  LoadedHistoryState({required this.pickDateModel});
  @override
  // TODO: implement props
  List<Object?> get props => [pickDateModel];

}