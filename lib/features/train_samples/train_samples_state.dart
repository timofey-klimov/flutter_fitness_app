import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/exercises/exercise.dart';

class ExerciseState extends Equatable {
  int index;
  final ExerciseTypes type;
  final Exercise? exercise;
  ExerciseState({required this.index, required this.type, this.exercise});

  @override
  // TODO: implement props
  List<Object?> get props => [index, type];

  ExerciseState copyWith({
    int? index,
    ExerciseTypes? type,
    Exercise? exercise,
  }) {
    return ExerciseState(
      index: index ?? this.index,
      type: type ?? this.type,
      exercise: exercise ?? this.exercise,
    );
  }
}

class TrainSampleState extends Equatable {
  final List<ExerciseState> exercisesState;
  TrainSampleState({required this.exercisesState});

  @override
  // TODO: implement props
  List<Object?> get props => [exercisesState];
}

class TrainSampleStateNotifier extends StateNotifier<TrainSampleState> {
  TrainSampleStateNotifier() : super(TrainSampleState(exercisesState: []));

  int addNewExercise(ExerciseTypes type) {
    var currentExercises = state.exercisesState;
    currentExercises
        .add(ExerciseState(type: type, index: currentExercises.length + 1));
    state = TrainSampleState(exercisesState: currentExercises);
    return currentExercises.length;
  }

  void removeItem(int index) {
    var currentExercises = state.exercisesState;
    currentExercises.removeAt(index - 1);
    currentExercises = currentExercises.map((item) {
      if (item.index > index) {
        return item.copyWith(index: --item.index);
      }
      return item;
    }).toList();
    state = TrainSampleState(exercisesState: currentExercises);
  }
}

final trainSampleStateProvider = StateNotifierProvider.autoDispose<
    TrainSampleStateNotifier,
    TrainSampleState>((ref) => TrainSampleStateNotifier());
