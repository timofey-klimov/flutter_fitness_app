import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_scroll_provider.dart';
import '../providers/auth_form_state.dart';
import '../widgets/sign_in.dart';
import '../widgets/sign_up.dart';

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
        body: Consumer(builder: (context, ref, child) {
          final scrollController = ref.watch(authScrollProvider);
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              color: AppColors.white,
              child: Column(
                children: [
                  Container(
                    child: Image(
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                      image: const AssetImage('lib/assets/auth_header_png.png'),
                    ),
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
                  Consumer(
                    builder: (context, ref, child) {
                      final formType = ref.watch(
                          authFormStateProvider.select((value) => value.form));
                      return AnimatedSwitcher(
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
                        child: formType == FormType.SignIn
                            ? const SignInWidget(
                                key: ValueKey('SignIn'),
                              )
                            : SignUpWidget(
                                key: const ValueKey('SignUp'),
                              ),
                      );
                    },
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
