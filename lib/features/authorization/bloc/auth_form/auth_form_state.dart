import 'package:app/features/authorization/bloc/auth_form/auth_form_event.dart';
import 'package:equatable/equatable.dart';

class AuthFormState extends Equatable{
  final String email;
  final String password;
  final Status status;
  final bool isLoading;
  final String? errorMessage;
  const AuthFormState(
      {required this.email,
      required this.password,
      required this.status,
      required this.isLoading,
      this.errorMessage});

  @override
  List<Object?> get props =>
      [email, password, status, errorMessage, isLoading];

  AuthFormState copyWith(
      {String? email,
      String? password,
      Status? status,
      String? errorMessage,
      bool? isLoading}) {
    return AuthFormState(
        isLoading: isLoading ?? this.isLoading,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
