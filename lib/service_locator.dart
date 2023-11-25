import 'package:app/application/repository/authentication_repository.dart';
import 'package:app/application/services/create_activity_service.dart';
import 'package:app/application/services/create_exercise_service.dart';
import 'package:app/application/services/exercise_activity_mapper.dart';
import 'package:app/domain/repository/authentication_repository.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_bloc.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_bloc.dart';
import 'package:app/features/history/bloc/history_bloc.dart';
import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(FirebaseAuth.instance);
  getIt.registerFactory<IAuthenticationRepository>(() => AuthenticationRepository(authService: getIt()));
  getIt.registerFactory<AuthFormBloc>(() => AuthFormBloc(repository: getIt()));
  getIt.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(authenticationRepository: getIt()));
  getIt.registerFactory<HistoryBloc>(() => HistoryBloc());
  getIt.registerFactory<TrainBloc>(() => TrainBloc());
  getIt.registerSingleton(ActivityTypesMapper());
  getIt.registerSingleton(ExerciseActivityMapper());
  getIt.registerSingleton(ExerciseMapper());
  getIt.registerSingleton(CreateActivityService());
  getIt.registerFactory<ExerciseActivityNamesMapper>(() => ExerciseActivityNamesMapper(activityTypesMapper: getIt(), exerciseActivityMapper: getIt()));
}