import 'package:app/domain/activities/activity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/exercises/exercise.dart';

class ExerciseState extends Equatable {
  int index;
  final String? name;
  final ExerciseTypes exerciseType;
  final bool isFormEditing;
  final bool isDeleting;
  final bool isSubmitting;
  final Activity? activity;
  final ActivityTypes? activityType;
  ExerciseState(
      {required this.index,
      required this.exerciseType,
      required this.isFormEditing,
      required this.isDeleting,
      required this.isSubmitting,
      this.name,
      this.activity,
      this.activityType});

  @override
  List<Object?> get props => [index];

  bool validate() {
    var result = (name?.isNotEmpty == true) &&
        (activity != null && activity!.validate());
    return result;
  }

  ExerciseState copyWith(
      {int? index,
      ExerciseTypes? exerciseType,
      Exercise? exercise,
      bool? isFormEditing,
      bool? isDeleting,
      bool? isSubmitting,
      Activity? activity,
      ActivityTypes? activityType,
      String? name}) {
    return ExerciseState(
        index: index ?? this.index,
        exerciseType: exerciseType ?? this.exerciseType,
        isDeleting: isDeleting ?? this.isDeleting,
        isSubmitting: isSubmitting ?? this.isSubmitting,
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
  List<Object?> get props => [exercisesState];
}

class TrainSampleStateNotifier extends StateNotifier<TrainSampleState> {
  TrainSampleStateNotifier() : super(TrainSampleState(exercisesState: []));

  int addNewExercise(ExerciseTypes type) {
    var currentExercises = state.exercisesState;
    currentExercises.add(ExerciseState(
        isSubmitting: false,
        isDeleting: false,
        exerciseType: type,
        index: currentExercises.length,
        isFormEditing: true));
    state = TrainSampleState(exercisesState: currentExercises);
    return currentExercises.length;
  }

  void removeItem(int index) {
    var currentExercises = state.exercisesState;
    currentExercises.removeAt(index);
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
          return item.copyWith(
            activityType: activityType,
          );
        }
        return item;
      },
    ).toList();
    state = TrainSampleState(exercisesState: exercises);
  }

  void updateActivity(int index, Activity activity) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(activity: activity);
      }
      return item;
    }).toList();
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

  void markExerciseEditing(int index) {
    var exercises = state.exercisesState.map((e) {
      if (e.index == index) {
        return e.copyWith(isFormEditing: true);
      }
      return e.copyWith(isFormEditing: false);
    }).toList();
    state = TrainSampleState(exercisesState: exercises);
  }

  void save(int index) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(isFormEditing: false, isSubmitting: true);
      }
      return item;
    }).toList();
    state = TrainSampleState(exercisesState: exercises);
  }

  void updateDeleting(int index, bool isDeleting) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(isDeleting: isDeleting);
      }
      return item;
    }).toList();

    state = TrainSampleState(exercisesState: exercises);
  }
}

final trainSampleStateProvider = StateNotifierProvider.autoDispose<
    TrainSampleStateNotifier,
    TrainSampleState>((ref) => TrainSampleStateNotifier());
