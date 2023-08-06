import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/provider.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      final result = ref.read(getTrainSamplesByDateProvider(DateTime.now()));
      return result.when(
          data: (data) => Center(),
          error: ((error, stackTrace) => Container()),
          loading: () => Container());
    });
  }
}
