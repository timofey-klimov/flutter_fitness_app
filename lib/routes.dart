import 'package:app/features/authorization/screen/auth_screen.dart';
import 'package:app/features/home/home.dart';
import 'package:flutter/material.dart';

import 'features/train_samples/create/create_train_sample_page.dart';

Map<String, Widget Function(BuildContext context)> get routes {
  return {
    Routes.AuthScreen: (ctx) => AuthScreen(),
    Routes.HomeScreen: (ctx) => HomeScreen(),
    Routes.CreateTrainsScreen: (ctx) => CreateTrainSamplePage(trainSample: null,),
  };
}

class Routes {
  static String AuthScreen = '/auth';
  static String HomeScreen = '/home';
  static String CreateTrainsScreen = '/createtrains';
}
