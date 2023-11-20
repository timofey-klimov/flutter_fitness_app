import 'package:app/domain/repository/authentication_repository.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_event.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final IAuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<AuthenticationStarted>((event, emit) async {
      authenticationRepository.getCurrentUser().listen((user) {
        if (user.uid != "uid") {
          add(AuthenticatedSuccesfully(uuid: user.uid!));
        } else {
          add(AuthenticationSignedOut());
        }
      });
    });
    on<AuthenticatedSuccesfully>((event, emit) {
      emit(AuthenticationSuccess(uid: event.uuid));
    });
    on<AuthenticationSignedOut>((event, emit) async {
      await authenticationRepository.signOut();
      emit(AuthenticationFailure());
    });
  }
}
