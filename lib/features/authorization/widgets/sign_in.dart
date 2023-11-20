import 'package:app/features/authorization/bloc/auth_form/auth_form_bloc.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_event.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_state.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/components/colored_button.dart';
import 'package:app/shared/debounce.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_input.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final emailDebounce = Debounce(duration: 300.ms);
  final passwordDebouce = Debounce(duration: 300.ms);
  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width * 0.8;
    const double height = 55;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.linearBgStart, AppColors.lightBlue],
            tileMode: TileMode.mirror),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AuthFormInput(
            initialValue: context.watch<AuthFormBloc>().state.email,
            width: inputWidth,
            hintText: 'Email',
            height: height,
            onChanged: (newValue) {
              emailDebounce.run(() {
                context.read<AuthFormBloc>().add(EmailChanged(email: newValue));
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          AuthFormInput(
            initialValue: context.watch<AuthFormBloc>().state.password,
            height: height,
            width: inputWidth,
            hintText: 'Пароль',
            obscure: true,
            onChanged: (newValue) {
              passwordDebouce.run(() {
                context
                    .read<AuthFormBloc>()
                    .add(PasswordChanged(password: newValue));
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<AuthFormBloc, AuthFormState>(
            builder: (context, state) {
              final message = state.errorMessage;
              if (message != null) {
                return Text(
                  message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                );
              } else {
                return Container();
              }
            },
            buildWhen: (previous, current) {
              return previous.errorMessage != current.errorMessage;
            },
          ),
          TextButton(
            onPressed: () {
              context
                  .read<AuthFormBloc>()
                  .add(const ChangeForm(status: Status.signUp));
            },
            child: Text(
              'Нет аккаунта ?',
              style: TextStyle(fontSize: 20, color: AppColors.main),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<AuthFormBloc, AuthFormState>(builder: (context, state) {
            return ColoredButton(
              width: MediaQuery.of(context).size.width * 0.5,
              height: height,
              isLoading: state.isLoading,
              onpressed: () =>
                  context.read<AuthFormBloc>().add(const FormSubmitted()),
              text: 'Войти',
            );
          })
        ],
      ),
    );
  }
}
