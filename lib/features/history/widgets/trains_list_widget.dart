import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/features/shared/train_item_widget.dart';
import 'package:flutter/material.dart';

class TrainsListWidget extends StatelessWidget {
  final Map<DateTime, List<SheduledTrainSample>> trains;
  const TrainsListWidget({super.key, required this.trains});

  @override
  Widget build(BuildContext context) {
    return trains.isEmpty
        ? const Center(
            child: Text(
              'Тренировок нет',
              style: TextStyle(fontSize: 18),
            ),
          )
        : ListView.separated(
            itemBuilder: (ctx, index) {
              final date = trains.keys.elementAt(index);
              return TrainsItem(
                showDate: true,
                sheduledTrains: trains[date]!,
                date: date,
              );
            },
            separatorBuilder: (ctx, index) => const Divider(),
            itemCount: trains.length,
          );
  }
}
