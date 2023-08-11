import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:flutter/material.dart';

import '../../shared/train_item_widget.dart';

class TrainsListWidget extends StatelessWidget {
  final Map<DateTime, List<SheduledTrainSample>> trains;
  final bool isRange;
  const TrainsListWidget(
      {super.key, required this.trains, required this.isRange});

  @override
  Widget build(BuildContext context) {
    return trains.isEmpty
        ? const Center(
            child: Text(
              'Тренировок нет',
              style: TextStyle(fontSize: 18),
            ),
          )
        : isRange
            ? ListView.separated(
                itemBuilder: (ctx, index) {
                  final date = trains.keys.elementAt(index);
                  return TrainsItem(
                    showDate: isRange,
                    sheduledTrains: trains[date]!,
                    date: date,
                  );
                },
                separatorBuilder: (ctx, index) => const Divider(),
                itemCount: trains.length,
              )
            : TrainsItem(
                sheduledTrains: trains.values.first,
                date: trains.keys.first,
                showDate: isRange,
              );
  }
}
