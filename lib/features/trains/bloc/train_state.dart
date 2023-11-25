import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:app/domain/models/train_info.dart';
import 'package:equatable/equatable.dart';

class ExerciseState extends Equatable {
  final int index;
  final String? name;
  final ExerciseTypes exerciseType;
  final bool isFormEditing;
  final bool isDeleting;
  final bool isSubmitting;
  final Activity? activity;
  final ActivityTypes? activityType;
  const ExerciseState(
      {required this.index,
      required this.exerciseType,
      required this.isFormEditing,
      required this.isDeleting,
      required this.isSubmitting,
      this.name,
      this.activity,
      this.activityType});

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

  @override
  List<Object?> get props => [index, name, exerciseType, isFormEditing, isDeleting, isSubmitting, activity, activityType];

  bool validate() {
    var result = (name?.isNotEmpty == true) &&
        (activity != null && activity!.validate());
    return result;
  }
}

class TrainState extends Equatable {
  String? id;
  List<ExerciseState> exercisesState;
  TrainScheduleTypes? trainScheduleType;
  String? name;
  DateTime? trainDate;
  TrainState(
      {required this.exercisesState,
      this.name,
      this.id,
      this.trainScheduleType,
      this.trainDate});

  factory TrainState.initial() => TrainState(exercisesState: []);

  @override
  List<Object?> get props =>
      [id, exercisesState, trainScheduleType, name, trainDate];

  TrainState copyWith(
      {String? id,
      List<ExerciseState>? exercisesState,
      TrainScheduleTypes? trainScheduleType,
      String? name,
      DateTime? trainDate}) {
    return TrainState(
        id: id ?? this.id,
        exercisesState: exercisesState ?? this.exercisesState,
        trainScheduleType: trainScheduleType ?? this.trainScheduleType,
        name: name ?? this.name,
        trainDate: trainDate ?? this.trainDate);
  }
}
