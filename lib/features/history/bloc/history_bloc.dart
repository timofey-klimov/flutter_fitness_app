import 'package:app/features/history/bloc/history_event.dart';
import 'package:app/features/history/bloc/history_state.dart';
import 'package:app/features/history/model/pick_date_model.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(InitialHistoryState()) {
    on<LoadingHistoryEvent>((event, emit) async {
      final model = event.pickDateModel ?? PickDateModel.initial();
      emit(LoadingHistoryState(pickDateModel: model));
      await Future.delayed(5.sc);
      emit(LoadedHistoryState(pickDateModel: model));
    },);
  }
}