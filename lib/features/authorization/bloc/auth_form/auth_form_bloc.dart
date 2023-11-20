import 'dart:async';
import 'package:app/domain/models/user_model.dart';
import 'package:app/domain/repository/authentication_repository.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_event.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_state.dart';
import 'package:app/shared/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  final IAuthenticationRepository repository;
  AuthFormBloc({required this.repository})
      : super(const AuthFormState(
            email: '', password: '', status: Status.signIn, isLoading: false)) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ChangeForm>(_onFormChange);
    on<FormSubmitted>(_onFormSubmited);
  }

  FutureOr<void> _onEmailChanged(
      EmailChanged event, Emitter<AuthFormState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<AuthFormState> emit) {
    emit(state.copyWith(password: event.password));
  }

  _onFormChange(ChangeForm event, Emitter<AuthFormState> emit) {
    emit(state.copyWith(
        status: event.status, errorMessage: '', email: '', password: '', isLoading: false));
  }

  _onFormSubmited(FormSubmitted event, Emitter<AuthFormState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(1.sc);
    if (state.email.isEmpty && state.password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Заполните необходимые поля', isLoading: false));
      return;
    }

    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(state.email);
    if (!emailValid) {
      emit(state.copyWith(errorMessage: 'Не правильный формат email', isLoading: false));
      return;
    }

    if (state.status == Status.signIn) {
      try {
        await repository
            .signIn(UserModel(email: state.email, password: state.password));
      } on FirebaseAuthException catch (error) {
        var errorMessage = 'Ошибка при входе';
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Не валидный email';
            break;
          case 'user-not-found':
            errorMessage = 'Не верный логин или пароль';
            break;
          case 'wrong-password':
            errorMessage = 'Не верный логин или пароль';
        }
        emit(state.copyWith(errorMessage: errorMessage, isLoading: false));
      }
    } else {
      try {
        await repository
            .signUp(UserModel(email: state.email, password: state.password));
            
      } on FirebaseAuthException catch (error) {
        var errorMessage = 'Ошибка при создании';
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = 'Пользователь уже существует';
            break;
          case 'invalid-email':
            errorMessage = 'Не валидный email';
            break;
          case 'weak-password':
            errorMessage = 'Слабый пароль';
            break;
        }
        emit(state.copyWith(errorMessage: errorMessage, isLoading: false));
      }
    }
  }
}
