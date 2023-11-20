import 'package:app/features/authorization/bloc/auth_form/auth_form_bloc.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_event.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_state.dart';
import 'package:app/features/authorization/widgets/sign_in.dart';
import 'package:app/features/authorization/widgets/sign_up.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<AuthFormBloc, AuthFormState>(
            builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              color: AppColors.white,
              child: Column(
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                    image: const AssetImage('lib/assets/auth_header_png.png'),
                  ),
                  Center(
                    child: Icon(
                      Icons.account_circle_rounded,
                      size: MediaQuery.of(context).size.height * 0.15,
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      final slideAnimation = Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0))
                          .animate(animation);
                      return SlideTransition(
                        position: slideAnimation,
                        child: child,
                      );
                    },
                    duration: const Duration(milliseconds: 500),
                    child: state.status == Status.signIn
                        ? const SignInWidget(
                            key: ValueKey('SignIn'),
                          )
                        : SignUpWidget(
                            key: const ValueKey('SignUp'),
                          ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
