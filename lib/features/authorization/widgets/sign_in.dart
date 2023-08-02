import 'package:app/shared/color.dart';
import 'package:app/shared/components/colored_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_scroll_provider.dart';
import '../providers/auth_form_state.dart';
import 'auth_input.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SignWidgetState();
  }
}

class _SignWidgetState extends State<SignInWidget> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            colors: [AppColors.linearBgStart, AppColors.linearBgEnd],
            tileMode: TileMode.mirror),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthFormInput(
              validator: (value) {
                if (value == null || value == "") {
                  return 'Обязательное поле';
                }
                return null;
              },
              controller: _emailController,
              width: inputWidth,
              hintText: 'Email',
              height: height,
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, ref, child) {
                final provider = ref.read(authScrollProvider);
                return AuthFormInput(
                  validator: (value) {
                    if (value == null || value == "") {
                      return 'Обязательное поле';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  height: height,
                  width: inputWidth,
                  hintText: 'Пароль',
                  obscure: true,
                  onFieldSubmitted: (newValue) {
                    provider.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer(
              builder: (ctx, ref, child) {
                final errorMessage = ref.watch(
                    authFormStateProvider.select((value) => value.errorText));
                if (errorMessage != null) {
                  return Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  );
                }
                return Container();
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final provider = ref.read(authFormStateProvider.notifier);
                return TextButton(
                  onPressed: () {
                    provider.openSignUpForm();
                  },
                  child: Text(
                    'Нет аккаунта ?',
                    style: TextStyle(fontSize: 20, color: AppColors.main),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Consumer(
              builder: (context, ref, child) {
                return ColoredButton(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: height,
                  onpressed: () async {
                    if (formKey.currentState!.validate()) {
                      ref.watch(
                        signInProvider(
                          SignInRequest(
                              email: _emailController.text,
                              password: _passwordController.text),
                        ),
                      );
                      ref.invalidate(signInProvider);
                    }
                  },
                  text: 'Войти',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
