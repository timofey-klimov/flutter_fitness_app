import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/exercises/exercise.dart';

abstract interface class TrainEvent {

}

class AddNewExerciseEvent extends TrainEvent {
  final ExerciseTypes type;
  AddNewExerciseEvent({required this.type});
}

class RemoveExerciseEvent extends TrainEvent {
  final int index;
  RemoveExerciseEvent({required this.index});
}

class UpdateActivityTypeEvent extends TrainEvent {
  final ActivityTypes activityType;
  final int index;
  UpdateActivityTypeEvent({required this.activityType, required this.index});
}

class UpdateActivityEvent extends TrainEvent {
  final Activity activity;
  final int index;
  UpdateActivityEvent({required this.activity, required this.index});
}

class UpdateExerciseNameEvent extends TrainEvent {
  final String? name;
  final int index;
  UpdateExerciseNameEvent({required this.name, required this.index});
}

class ExerciseEditingEvent extends TrainEvent {
  final int index;
  ExerciseEditingEvent({required this.index});
}

class ExerciseDisplayDeletingEvent extends TrainEvent {
  final int index;
  bool isDeleting;
  ExerciseDisplayDeletingEvent({required this.index, required this.isDeleting});
}

class SaveExerciseEvent extends TrainEvent {
  final int index;
  SaveExerciseEvent({required this.index});
}

