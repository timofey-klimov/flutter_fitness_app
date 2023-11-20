import 'package:equatable/equatable.dart';

enum Status { signIn, signUp }

abstract class AuthFormEvent extends Equatable{
  const AuthFormEvent();
}

class EmailChanged extends AuthFormEvent {
  final String email;
  const EmailChanged({required this.email});
  
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthFormEvent {
  final String password;
  const PasswordChanged({required this.password});
  
  @override
  List<Object?> get props => [password];
}

class ChangeForm extends AuthFormEvent {
  final Status status;
  const ChangeForm({required this.status});

  @override
  List<Object?> get props => [status];
}

class FormSubmitted extends AuthFormEvent {
  const FormSubmitted();

  @override
  List<Object> get props => [];
}