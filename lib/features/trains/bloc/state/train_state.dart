import 'package:app/features/trains/bloc/state/exercise_state.dart';
import 'package:equatable/equatable.dart';

abstract class TrainState extends Equatable {}

class CreateTrainState extends TrainState {
  List<ExerciseState> exercisesState;
  DateTime trainDate;
  CreateTrainState({
    required this.exercisesState,
    required this.trainDate,
  });

  factory CreateTrainState.initial() =>
      CreateTrainState(exercisesState: [], trainDate: DateTime.now());

  @override
  List<Object?> get props => [ exercisesState, trainDate];

  TrainState copyWith(
      {String? id,
      List<ExerciseState>? exercisesState,
      String? name,
      DateTime? trainDate}) {
    return CreateTrainState(
        exercisesState: exercisesState ?? this.exercisesState,
        trainDate: trainDate ?? this.trainDate);
  }
}

class SubmittingTrainState extends TrainState {
  final List<ExerciseState> exercises;
  final DateTime trainDate;
  SubmittingTrainState({required this.exercises, required this.trainDate});
  
  @override
  // TODO: implement props
  List<Object?> get props => [exercises, trainDate];
}

class SubmittingSuccesfullyState extends TrainState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SubmittigFailedState extends TrainState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
