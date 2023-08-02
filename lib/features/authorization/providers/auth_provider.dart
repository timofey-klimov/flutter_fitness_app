import 'package:app/features/authorization/providers/auth_form_state.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/shared/auth_provider.dart';

class SignInRequest extends Equatable {
  final String email;
  final String password;
  const SignInRequest({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

final signInProvider = Provider.autoDispose.family(
  (ref, SignInRequest request) async {
    final firebase = ref.read(firebaseProvider);
    final authStateNotifier = ref.read(authFormStateProvider.notifier);
    try {
      await firebase.signInWithEmailAndPassword(
          email: request.email, password: request.password);
    } on FirebaseException catch (error) {
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
      authStateNotifier.setErrorText(errorMessage);
    }
  },
);

class SignUpRequest extends Equatable {
  final String email;
  final String password;

  const SignUpRequest({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final signUpProvider = Provider.autoDispose.family(
  (ref, SignUpRequest request) async {
    final firebase = ref.read(firebaseProvider);
    final authStateNotifier = ref.read(authFormStateProvider.notifier);
    try {
      await firebase.createUserWithEmailAndPassword(
          email: request.email, password: request.password);
    } on FirebaseException catch (e) {
      var errorMessage = 'Ошибка при создании';
      switch (e.code) {
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
      authStateNotifier.setErrorText(errorMessage);
    }
  },
);
