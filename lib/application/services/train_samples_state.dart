import 'package:app/domain/models/train_sample.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_info.dart';
import 'package:uuid/uuid.dart';

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
  final String flagId;
  final String? id;
  final List<ExerciseState> exercisesState;
  final TrainScheduleTypes? trainScheduleType;
  final String? name;
  final DateTime? trainDate;
  final bool isSubmitting;
  final bool? isEditing;
  TrainSampleState(
      {required this.exercisesState,
      required this.isSubmitting,
      required this.flagId,
      this.name,
      this.id,
      this.isEditing,
      this.trainScheduleType,
      this.trainDate});

  @override
  List<Object?> get props => [name, trainDate, flagId];

  TrainSampleState copyWith(
      {List<ExerciseState>? exercisesState,
      TrainScheduleTypes? trainScheduleType,
      DateTime? trainDate,
      bool? isSubmitting,
      String? name,
      bool? isEditing,
      String? id,
      String? flagId}) {
    return TrainSampleState(
        flagId: flagId ?? this.flagId,
        id: id ?? this.id,
        exercisesState: exercisesState ?? this.exercisesState,
        trainScheduleType: trainScheduleType ?? this.trainScheduleType,
        trainDate: trainDate ?? this.trainDate,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        name: name ?? this.name,
        isEditing: isEditing ?? this.isEditing);
  }
}

class TrainSampleStateNotifier extends StateNotifier<TrainSampleState> {
  TrainSampleStateNotifier()
      : super(TrainSampleState(exercisesState: [], isSubmitting: false, flagId: const Uuid().v1()));

  int addNewExercise(ExerciseTypes type) {
    var currentExercises = state.exercisesState;
    currentExercises.add(ExerciseState(
        isSubmitting: false,
        isDeleting: false,
        exerciseType: type,
        index: currentExercises.length,
        isFormEditing: true));
    state = state.copyWith(exercisesState: currentExercises);
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
    state = state.copyWith(exercisesState: currentExercises);
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
    state = state.copyWith(exercisesState: exercises);
  }

  void updateActivity(int index, Activity activity) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(activity: activity);
      }
      return item;
    }).toList();
    state = state.copyWith(exercisesState: exercises);
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
    state = state.copyWith(exercisesState: exercises);
  }

  void markExerciseEditing(int index) {
    var exercises = state.exercisesState.map((e) {
      if (e.index == index) {
        return e.copyWith(isFormEditing: true);
      }
      return e.copyWith(isFormEditing: false);
    }).toList();
    state = state.copyWith(exercisesState: exercises);
  }

  void save(int index) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(isFormEditing: false, isSubmitting: true);
      }
      return item;
    }).toList();
    state = state.copyWith(exercisesState: exercises);
  }

  void updateDeleting(int index, bool isDeleting) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == index) {
        return item.copyWith(isDeleting: isDeleting);
      }
      return item;
    }).toList();

    state = state.copyWith(exercisesState: exercises);
  }

  void submitTrain(DateTime date, TrainScheduleTypes type) {
    state = state.copyWith(
        trainDate: date, trainScheduleType: type, isSubmitting: true);
  }

  void submitEditing() {
    state = state.copyWith(isSubmitting: true);
  }

  void updateTrainName(String name) {
    state = state.copyWith(name: name);
  }

  void fromTrain(TrainSample sample) {
    state = state.copyWith(
      flagId: const Uuid().v1(),
      id: sample.id,
      isEditing: true,
      exercisesState: sample.sample
          .map(
            (e) => ExerciseState(
                activity: e.activity,
                activityType: e.activity.type,
                index: e.index,
                name: e.name,
                exerciseType: e.type,
                isFormEditing: false,
                isDeleting: false,
                isSubmitting: true),
          )
          .toList(),
      name: sample.name,
      isSubmitting: true,
      
    );
  }
}

final trainSampleStateProvider = StateNotifierProvider<
    TrainSampleStateNotifier,
    TrainSampleState>((ref) => TrainSampleStateNotifier());
