import 'package:app/firebase_options.dart';
import 'package:app/provider_logger.dart';
import 'package:app/routes.dart';
import 'package:app/shared/auth_provider.dart';
import 'package:app/shared/color.dart';
import 'package:app/supabase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final opts = SupaBaseOpts.supabaseOpts;
  await Supabase.initialize(url: opts.url, anonKey: opts.key);
  runApp(
    ProviderScope(
      observers: [Logger()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen(
            firebaseUserProvider,
            (prev, next) {
              if (next.hasValue && next.value != null) {
                Navigator.of(context).pushNamed('/home');
              } else if (next.hasValue && next.value == null) {
                Navigator.of(context).pushNamed('/auth');
              }
            },
          );
          return Container(
            color: AppColors.background,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
