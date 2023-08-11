import 'package:app/features/calendar/widgets/trains_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/providers/calendar_provider.dart';
import '../pick_date_model.dart';

class Trains extends StatelessWidget {
  final PickDateModel pickDate;
  const Trains({super.key, required this.pickDate});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, child) {
        final result = ref.watch(getTrainSamplesByDateProvider(
            GetTrainsByDateRequest(
                startDate: pickDate.start, endDate: pickDate.end)));
        return result.when(
            data: (data) => TrainsListWidget(
                  trains: data,
                  isRange: pickDate.type == PickDateType.range,
                ),
            error: (e, s) => Container(),
            loading: () => const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ));
      },
    );
  }
}
