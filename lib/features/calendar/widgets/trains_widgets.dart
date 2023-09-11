import 'package:app/features/calendar/widgets/trains_list_widget.dart';
import 'package:app/shared/components/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/riverpod/calendar/get_train_sample_by_date_provider.dart';
import '../../../application/riverpod/calendar/pick_date.dart';
import '../../../application/usecases/calendar/get_train_samples_by_date_use_case.dart';

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
                  child: Spinner(),
                ));
      },
    );
  }
}
