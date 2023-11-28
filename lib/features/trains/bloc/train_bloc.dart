import 'package:app/application/services/create_exercise_service.dart';
import 'package:app/domain/activities/empty_activity.dart';
import 'package:app/domain/models/train.dart';
import 'package:app/domain/repository/train_repository.dart';
import 'package:app/features/trains/bloc/state/exercise_state.dart';
import 'package:app/features/trains/bloc/state/train_state.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrainBloc extends Bloc<TrainEvent, TrainState> {
  final ITrainRepository repository;
  TrainBloc({required this.repository}) : super(CreateTrainState.initial()) {
    on<AddNewExerciseEvent>(onAddNewExercise);
    on<RemoveExerciseEvent>(onRemoveExercise);
    on<UpdateActivityTypeEvent>(onUpdateActivityType);
    on<UpdateActivityEvent>(onUpdateActivity);
    on<UpdateExerciseNameEvent>(onUpdateExerciseName);
    on<ExerciseEditingEvent>(onExerciseEditing);
    on<ExerciseDisplayDeletingEvent>(onExerciseDisplayDeleting);
    on<SaveExerciseEvent>(onSaveExercise);
    on<TrainDateUpdateEvent>(onTrainDateUpdate);
    on<SubmitTrainEvent>(onSubmitTrain);
  }

  onAddNewExercise(AddNewExerciseEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var currentExercises = currentState.exercisesState;
      currentExercises.add(ExerciseState(
          activity: EmptyActivity(),
          isSubmitting: false,
          isDeleting: false,
          exerciseType: event.type,
          index: currentExercises.length,
          isFormEditing: true));
      emit(currentState.copyWith(exercisesState: currentExercises));
    }
  }

  onRemoveExercise(RemoveExerciseEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var currentExercises = currentState.exercisesState;
      currentExercises.removeAt(event.index);
      currentExercises = currentExercises.map((item) {
        if (item.index > event.index) {
          return item.copyWith(index: item.index - 1);
        }
        return item;
      }).toList();
      emit(currentState.copyWith(exercisesState: currentExercises));
    }
  }

  onUpdateActivityType(
      UpdateActivityTypeEvent event, Emitter<TrainState> emit) {
     if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map(
        (item) {
          if (item.index == event.index) {
            return item.copyWith(
              activityType: event.activityType,
              activity: EmptyActivity()
            );
          }
          return item;
        },
      ).toList();
      emit(currentState.copyWith(exercisesState: exercises));
     }
  }

  onUpdateActivity(UpdateActivityEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map((item) {
        if (item.index == event.index) {
          return item.copyWith(activity: event.activity);
        }
        return item;
      }).toList();
      emit(currentState.copyWith(exercisesState: exercises));
    }
  }

  onUpdateExerciseName(UpdateExerciseNameEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map(
        (item) {
          if (item.index == event.index) {
            return item.copyWith(name: event.name);
          }
          return item;
        },
      ).toList();
      emit(currentState.copyWith(exercisesState: exercises));
    }
  }

  onExerciseEditing(ExerciseEditingEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map((e) {
        if (e.index == event.index) {
          return e.copyWith(isFormEditing: true);
        }
        return e.copyWith(isFormEditing: false);
      }).toList();
      emit(currentState.copyWith(exercisesState: exercises));
    }
  }

  onExerciseDisplayDeleting(ExerciseDisplayDeletingEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map((item) {
        if (item.index == event.index) {
          return item.copyWith(isDeleting: event.isDeleting);
        }
        return item;
      }).toList();

      emit(currentState.copyWith(exercisesState: exercises));
    }
  }

  onSaveExercise(SaveExerciseEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      var exercises = currentState.exercisesState.map((item) {
        if (item.index == event.index) {
          return item.copyWith(isFormEditing: false, isSubmitting: true);
        }
        return item;
      }).toList();
      emit(currentState.copyWith(exercisesState: exercises));
    }
  }

  onTrainDateUpdate(TrainDateUpdateEvent event, Emitter<TrainState> emit) {
    if (state is CreateTrainState) {
      var currentState = state as CreateTrainState;
      emit(currentState.copyWith(trainDate: event.date));
    }
  }

  onSubmitTrain(SubmitTrainEvent event, Emitter<TrainState> emit) async {
    if (state is CreateTrainState) {
      try {
        var currentState = state as CreateTrainState;
        emit(SubmittingTrainState(exercises: currentState.exercisesState, trainDate: currentState.trainDate));
        var submitState = state as SubmittingTrainState;
        final exercises = submitState.exercises
          .map((item) => ExerciseFactory.createExerciseFromState(item.exerciseType, item.activity, item.index, item.name!))
          .toList();
        await repository.createTrain(Train(exercises: exercises, date: submitState.trainDate), event.userId);
        emit(SubmittingSuccesfullyState());
      }
      catch (e) {
        emit(SubmittigFailedState());
      }
    }
  }
}
