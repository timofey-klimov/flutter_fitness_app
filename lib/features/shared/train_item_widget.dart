import 'dart:math';
import 'package:app/domain/activities/activity.dart';
import 'package:app/domain/activities/approach_activities.dart';
import 'package:app/domain/activities/timer_activity.dart';
import 'package:app/domain/activities/total_activity.dart';
import 'package:app/features/shared/expanded_train_card_widget.dart';
import 'package:app/features/shared/item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/shared/color.dart';

import '../../domain/models/train.dart';

class TrainsItem extends StatefulWidget {
  final DateTime date;
  final List<Train> trains;
  const TrainsItem(
      {super.key,
      required this.trains,
      required this.date});

  @override
  State<TrainsItem> createState() => _TrainsItemState();
}

class _TrainsItemState extends State<TrainsItem> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              DateFormat('MMMMEEEEd', 'ru').format(widget.date),
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.main,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _calculateInitialPageViewHeight(widget.trains),
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value!;
                    });
                  },
                  children: widget.trains
                      .map(
                        (item) => ExpandedTrainCardWidget(train: item),
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
                              isEnabled:
                                  widget.trains.indexOf(e) == pageIndex,
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }

  double _calculateInitialPageViewHeight(List<Train> samples) {
    if (samples.isEmpty) return 0;
    return samples.map((e) => _calculateCollapseHeight(e)).reduce(max);
  }

  double _calculateCollapseHeight(Train trainSample) {
    return 130 + trainSample.exercises.map((e) => mapActivityToHeight(e.activity)).reduce((value, element) => value + element);
  }

  double mapActivityToHeight(Activity activity) {
    var basicHeight = 25.0;
    if (activity is WeightApproachActivity) {
      return basicHeight + activity.approaches.length * 20;
    }

    if (activity is ApproachActivity) {
      return basicHeight + activity.approaches.length * 20;
    }

    if (activity is TotalActivity) {
      return basicHeight + 20;
    }
    if (activity is TimerActivity) {
      return basicHeight + 20;
    } 

    return basicHeight;
  }
}
