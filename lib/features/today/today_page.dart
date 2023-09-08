import 'package:app/features/today/today_train.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/providers/today_provider.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      ref.listen(todayPageStreamProvider, (previous, next) {
        if (next.hasValue && next.value is LoadingEvent) {
          setState(() {
            isLoading = true;
          });
        }
        if (next.hasValue && next.value is ReadyEvent) {
          setState(() {
            isLoading = false;
          });
        }
      });
      final result = ref.watch(getTodayTrainsProvider);
      return isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : result.when(
              data: (data) => data.isNotEmpty
                  ? Center(
                      child: TodayTrain(
                        trains: data,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Нет тренировок на сегодня',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              error: (error, stackTrace) => Container(),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ));
    });
  }
}
