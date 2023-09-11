import 'dart:math';

import 'package:app/features/today/today_train_card.dart';
import 'package:flutter/material.dart';

import '../../domain/models/sheduled_train_sample.dart';
import '../../domain/models/train_sample.dart';
import '../shared/item_indicator.dart';

class TodayTrain extends StatefulWidget {
  final List<SheduledTrainSample> trains;
  const TodayTrain({super.key, required this.trains});

  @override
  State<TodayTrain> createState() => _TodayTrainState();
}

class _TodayTrainState extends State<TodayTrain> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: _calculateInitialPageViewHeight(
                widget.trains.map((e) => e.trainSample).toList()),
            child: PageView(
              onPageChanged: (index) => setState(() {
                _pageIndex = index;
              }),
              children: widget.trains
                  .map(
                    (train) => TodayTrainCard(
                      train: train,
                      prevTrains: widget.trains,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          widget.trains.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.trains
                      .map(
                        (e) => ItemIndicator(
                          isEnabled: widget.trains.indexOf(e) == _pageIndex,
                        ),
                      )
                      .toList(),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  double _calculateInitialPageViewHeight(List<TrainSample> samples) {
    if (samples.isEmpty) return 0;
    return samples.map((e) => _calculateCollapseHeight(e)).reduce(max);
  }

  double _calculateCollapseHeight(TrainSample trainSample) {
    return 230 + trainSample.sample.length * 35;
  }
}
