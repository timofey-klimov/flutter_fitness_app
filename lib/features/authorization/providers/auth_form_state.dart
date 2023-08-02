import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FormType { SignIn, SignUp }

class AuthFormState extends Equatable {
  final FormType form;
  final String? errorText;
  const AuthFormState({
    required this.form,
    this.errorText,
  });

  @override
  List<Object?> get props => [form, errorText];
}

final authFormStateProvider =
    StateNotifierProvider<IsSignInNotifier, AuthFormState>(
        (ref) => IsSignInNotifier());

class IsSignInNotifier extends StateNotifier<AuthFormState> {
  IsSignInNotifier() : super(const AuthFormState(form: FormType.SignIn));

  openSignInForm() => state = const AuthFormState(form: FormType.SignIn);
  openSignUpForm() => state = const AuthFormState(form: FormType.SignUp);
  setErrorText(String text) =>
      state = AuthFormState(form: state.form, errorText: text);
}
