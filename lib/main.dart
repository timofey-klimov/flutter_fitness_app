import 'package:app/bloc_observer.dart';
import 'package:app/features/authorization/bloc/auth_form/auth_form_bloc.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_bloc.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_event.dart';
import 'package:app/features/authorization/bloc/authentication/authentication_state.dart';
import 'package:app/features/authorization/screen/auth_screen.dart';
import 'package:app/features/home/home.dart';
import 'package:app/firebase_options.dart';
import 'package:app/routes.dart';
import 'package:app/service_locator.dart';
import 'package:app/supabase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final opts = SupaBaseOpts.supabaseOpts;
  await Supabase.initialize(url: opts.url, anonKey: opts.key);
  await setup();
  Bloc.observer = AppBlocObserver();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => getIt<AuthenticationBloc>()
          ..add(AuthenticationStarted())),
    BlocProvider(
      create: (context) => getIt<AuthFormBloc>(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'),
        ],
        routes: routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationSuccess) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          },
        ));
  }
}
