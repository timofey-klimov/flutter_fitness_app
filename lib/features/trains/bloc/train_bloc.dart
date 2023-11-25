import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/features/trains/bloc/train_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrainBloc extends Bloc<TrainEvent, TrainState> {
  TrainBloc() : super(TrainState.initial()) {
    on<AddNewExerciseEvent>(onAddNewExercise);
    on<RemoveExerciseEvent>(onRemoveExercise);
    on<UpdateActivityTypeEvent>(onUpdateActivityType);
    on<UpdateActivityEvent>(onUpdateActivity);
    on<UpdateExerciseNameEvent>(onUpdateExerciseName);
    on<ExerciseEditingEvent>(onExerciseEditing);
    on<ExerciseDisplayDeletingEvent>(onExerciseDisplayDeleting);
    on<SaveExerciseEvent>(onSaveExercise);
  }

  onAddNewExercise(AddNewExerciseEvent event, Emitter<TrainState> emit) {
    var currentExercises = state.exercisesState;
    currentExercises.add(ExerciseState(
        isSubmitting: false,
        isDeleting: false,
        exerciseType: event.type,
        index: currentExercises.length,
        isFormEditing: true));
    emit(state.copyWith(exercisesState: currentExercises));
  }

  onRemoveExercise(RemoveExerciseEvent event, Emitter<TrainState> emit) {
    var currentExercises = state.exercisesState;
    currentExercises.removeAt(event.index);
    currentExercises = currentExercises.map((item) {
      if (item.index > event.index) {
        return item.copyWith(index: item.index - 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(exercisesState: currentExercises));
  }

  onUpdateActivityType(
      UpdateActivityTypeEvent event, Emitter<TrainState> emit) {
    var exercises = state.exercisesState.map(
      (item) {
        if (item.index == event.index) {
          return item.copyWith(
            activityType: event.activityType,
          );
        }
        return item;
      },
    ).toList();
    emit(state.copyWith(exercisesState: exercises));
  }

  onUpdateActivity(UpdateActivityEvent event, Emitter<TrainState> emit) {
     var exercises = state.exercisesState.map((item) {
      if (item.index == event.index) {
        return item.copyWith(activity: event.activity);
      }
      return item;
    }).toList();
    emit(state.copyWith(exercisesState: exercises));
  }

  onUpdateExerciseName(UpdateExerciseNameEvent event, Emitter<TrainState> emit) {
    var exercises = state.exercisesState.map(
      (item) {
        if (item.index == event.index) {
          return item.copyWith(name: event.name);
        }
        return item;
      },
    ).toList();
    emit(state.copyWith(exercisesState: exercises));
  }

  onExerciseEditing(ExerciseEditingEvent event, Emitter<TrainState> emit) {
     var exercises = state.exercisesState.map((e) {
      if (e.index == event.index) {
        return e.copyWith(isFormEditing: true);
      }
      return e.copyWith(isFormEditing: false);
    }).toList();
    emit(state.copyWith(exercisesState: exercises));
  }

  onExerciseDisplayDeleting(ExerciseDisplayDeletingEvent event, Emitter<TrainState> emit) {
    var exercises = state.exercisesState.map((item) {
      if (item.index == event.index) {
        return item.copyWith(isDeleting: event.isDeleting);
      }
      return item;
    }).toList();

    emit(state.copyWith(exercisesState: exercises));
  }

  onSaveExercise(SaveExerciseEvent event, Emitter<TrainState> emit) {
     var exercises = state.exercisesState.map((item) {
      if (item.index == event.index) {
        return item.copyWith(isFormEditing: false, isSubmitting: true);
      }
      return item;
    }).toList();
    emit(state.copyWith(exercisesState: exercises));
  }

}
