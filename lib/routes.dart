import 'package:app/features/authorization/screen/auth_screen.dart';
import 'package:app/features/home/home.dart';
import 'package:flutter/material.dart';

import 'features/trains/create_train_sample_page.dart';

Map<String, Widget Function(BuildContext context)> get routes {
  return {
    Routes.AuthScreen: (ctx) => const AuthScreen(),
    Routes.HomeScreen: (ctx) => const HomeScreen(),
    Routes.CreateTrainsScreen: (ctx) => const CreateTrainSamplePage(),
  };
}

class Routes {
  static String AuthScreen = '/auth';
  static String HomeScreen = '/home';
  static String CreateTrainsScreen = '/createtrain';
}
