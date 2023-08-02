import 'package:app/features/authorization/screen/auth_screen.dart';
import 'package:app/features/home/home.dart';
import 'package:flutter/material.dart';

import 'features/train_samples/create_train_sample_page.dart';

Map<String, Widget Function(BuildContext context)> get routes {
  return {
    '/auth': (ctx) => AuthScreen(),
    '/home': (ctx) => HomeScreen(),
    '/createtrains': (ctx) => CreateTrainSamplePage()
  };
}
