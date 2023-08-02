import 'package:app/domain/activities/activity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/exercises/exercise.dart';

class ExerciseState extends Equatable {
  int index;
  String? name;
  final ExerciseTypes exerciseType;
  final bool isFormEditing;
  final Activity? activity;
  final ActivityTypes? activityType;
  ExerciseState(
      {required this.index,
      required this.exerciseType,
      required this.isFormEditing,
      this.name,
      this.activity,
      this.activityType});

  @override
  List<Object?> get props => [index];

  ExerciseState copyWith(
      {int? index,
      ExerciseTypes? exerciseType,
      Exercise? exercise,
      bool? isFormEditing,
      Activity? activity,
      ActivityTypes? activityType,
      String? name}) {
    return ExerciseState(
        index: index ?? this.index,
        exerciseType: exerciseType ?? this.exerciseType,
        isFormEditing: isFormEditing ?? this.isFormEditing,
        activity: activity ?? this.activity,
        name: name ?? this.name,
        activityType: activityType ?? this.activityType);
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
    currentExercises.add(ExerciseState(
        exerciseType: type,
        index: currentExercises.length + 1,
        isFormEditing: true));
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

  void updateActivityType(ActivityTypes activityType, int index) {
    var exercises = state.exercisesState.map(
      (item) {
        if (item.index == index) {
          return item.copyWith(activityType: activityType);
        }
        return item;
      },
    ).toList();
    state = TrainSampleState(exercisesState: exercises);
  }

  void updateExerciseName(String? name, int index) {
    var exercises = state.exercisesState.map(
      (item) {
        if (item.index == index) {
          return item.copyWith(name: name);
        }
        return item;
      },
    ).toList();
    state = TrainSampleState(exercisesState: exercises);
  }
}

final trainSampleStateProvider = StateNotifierProvider.autoDispose<
    TrainSampleStateNotifier,
    TrainSampleState>((ref) => TrainSampleStateNotifier());
