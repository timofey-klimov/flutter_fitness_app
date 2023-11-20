import 'package:app/features/authorization/bloc/auth_form/auth_form_bloc.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_event.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_state.dart';
import 'package:app/shared/debounce.dart';
import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/color.dart';
import '../../../shared/components/colored_button.dart';
import 'auth_input.dart';

class SignUpWidget extends StatefulWidget {
  SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailDebounce = Debounce(duration: 300.ms);
  final passwordDebounce = Debounce(duration: 300.ms);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.linearBgStart, AppColors.lightBlue],
          tileMode: TileMode.mirror,
        ),
      ),
      child: _form(context),
    );
  }

  Widget _form(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width * 0.8;
    const double height = 55;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<AuthFormBloc, AuthFormState>(builder: (context, state) {
          return AuthFormInput(
            initialValue: state.email,
            width: inputWidth,
            hintText: 'Email',
            height: height,
            onFieldSubmitted: (newValue) {
              context.read<AuthFormBloc>().add(EmailChanged(email: newValue));
            },
            onChanged: (newValue) {
              emailDebounce.run(() {
                context.read<AuthFormBloc>().add(EmailChanged(email: newValue));
              });
            },
          );
        }),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<AuthFormBloc, AuthFormState>(builder: (context, state) {
          return AuthFormInput(
            initialValue: state.password,
            onChanged: (newValue) {
              passwordDebounce.run(() {
                context.read<AuthFormBloc>().add(PasswordChanged(password: newValue));
              });
            },
            height: height,
            width: inputWidth,
            hintText: 'Пароль',
            obscure: true,
            onFieldSubmitted: (newValue) {
              context
                  .read<AuthFormBloc>()
                  .add(PasswordChanged(password: newValue));
            },
          );
        }),
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<AuthFormBloc, AuthFormState>(
          builder: (context, state) {
            final errorMessage = state.errorMessage;
            if (errorMessage != null) {
              return Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              );
            }
            return Container();
          },
          buildWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage,
        ),
        TextButton(
          onPressed: () {
            context.read<AuthFormBloc>().add(ChangeForm(status: Status.signIn));
          },
          child: Text(
            'Уже есть аккаунт',
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
            onpressed: () {
              context.read<AuthFormBloc>().add(FormSubmitted());
            },
            text: 'Создать',
          );
        }),
      ],
    );
  }
}
