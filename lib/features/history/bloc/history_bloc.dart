import 'package:app/domain/repository/train_repository.dart';
import 'package:app/features/history/bloc/history_event.dart';
import 'package:app/features/history/bloc/history_state.dart';
import 'package:app/features/history/model/pick_date_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ITrainRepository repository;

  HistoryBloc({required this.repository}) : super(InitialHistoryState()) {
    on<LoadingHistoryEvent>(
      (event, emit) async {
        try {
          final model = event.pickDateModel ?? PickDateModel.initial();
          emit(LoadingHistoryState(pickDateModel: model));
          final trains =
              await repository.getTrains(model.dateTimeRange, event.userId);
          emit(LoadedHistoryState(pickDateModel: model, trains: trains));
        } catch (e) {
          emit(ErrorState(pickDateModel: event.pickDateModel ?? PickDateModel.initial()));
        }
      },
    );
    on<RefreshHistoryEvent>((event, emit) async {
      try {
          final model = event.pickDateModel;
          final trains =
              await repository.getTrains(model.dateTimeRange, event.userId);
          event.completer.complete();
          emit(LoadedHistoryState(pickDateModel: model, trains: trains));
        } catch (e) {
          event.completer.complete();
          emit(ErrorState(pickDateModel: event.pickDateModel));
        }
    });
  }
}
