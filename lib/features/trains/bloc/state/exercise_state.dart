import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';
import 'package:equatable/equatable.dart';

class ExerciseState extends Equatable {
  final int index;
  final String? name;
  final ExerciseTypes exerciseType;
  final bool isFormEditing;
  final bool isDeleting;
  final bool isSubmitting;
  final Activity activity;
  final ActivityTypes? activityType;
  const ExerciseState(
      {required this.index,
      required this.exerciseType,
      required this.isFormEditing,
      required this.isDeleting,
      required this.isSubmitting,
      required this.activity,
      this.name,
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
        (activity.type != ActivityTypes.empty && activity.validate());
    return result;
  }
}