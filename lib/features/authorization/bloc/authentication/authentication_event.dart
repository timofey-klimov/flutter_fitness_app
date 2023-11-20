import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationSignedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticatedSuccesfully extends AuthenticationEvent {
  final String uuid;
  AuthenticatedSuccesfully({required this.uuid});
  @override
  List<Object?> get props => [uuid];

}