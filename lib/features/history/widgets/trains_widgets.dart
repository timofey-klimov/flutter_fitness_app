import 'package:app/features/history/widgets/trains_list_widget.dart';
import 'package:app/shared/components/spinner.dart';
import 'package:flutter/material.dart';


// class Trains extends StatelessWidget {
//   final DateTimeRange dateTimeRange;
//   const Trains({super.key, required this.dateTimeRange});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (ctx, ref, child) {
//         final result = ref.watch(getTrainSamplesByDateProvider(
//             GetTrainsByDateRequest(
//                 startDate: pickDate.dateTimeRange.start, endDate: pickDate.dateTimeRange.end)));
//         return result.when(
//             data: (data) => TrainsListWidget(
//                   trains: data,
//                 ),
//             error: (e, s) => Container(),
//             loading: () => const Align(
//                   alignment: Alignment.center,
//                   child: Spinner(),
//                 ));
//       },
//     );
//   }
// }
