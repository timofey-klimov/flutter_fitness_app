import 'package:app/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    logToFile('onEvent $event');
    print('onEvent $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    logToFile('onChange $change');
    print('onChange $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logToFile('onTransition $transition');
    print('onTransition $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logToFile('onError $error');
    print('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}