import 'dart:math';

import 'package:app/domain/models/sheduled_train_sample.dart';
import 'package:app/features/shared/expanded_train_card_widget.dart';
import 'package:app/features/shared/item_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/shared/color.dart';

import '../../../domain/models/train_sample.dart';
import 'collapsed_train_card_widget.dart';

class TrainsItem extends StatefulWidget {
  final DateTime date;
  final List<SheduledTrainSample> sheduledTrains;
  final bool showDate;
  const TrainsItem(
      {super.key,
      required this.sheduledTrains,
      required this.date,
      required this.showDate});

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
          widget.showDate
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    DateFormat('MMMMEEEEd', 'ru').format(widget.date),
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w500),
                  ),
                )
              : const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _calculateInitialPageViewHeight(
                    widget.sheduledTrains.map((e) => e.trainSample).toList()),
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value!;
                    });
                  },
                  children: widget.sheduledTrains
                      .map(
                        (item) => CollapsedTrainCardWidget(
                          color: AppColors.lightGreen,
                          id: item.id,
                          sample: item.trainSample,
                          onExpand: (sample) async {
                            await showDialog(
                              context: context,
                              builder: (ctx) {
                                return Dialog(
                                  backgroundColor: AppColors.lightGreen,
                                  child: ExpandedTrainCardWidget(
                                      trainSample: sample),
                                );
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              widget.sheduledTrains.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.sheduledTrains
                          .map(
                            (e) => ItemIndicator(
                              isEnabled:
                                  widget.sheduledTrains.indexOf(e) == pageIndex,
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

  double _calculateInitialPageViewHeight(List<TrainSample> samples) {
    if (samples.isEmpty) return 0;
    return samples.map((e) => _calculateCollapseHeight(e)).reduce(max);
  }

  double _calculateCollapseHeight(TrainSample trainSample) {
    return 130 + trainSample.sample.length * 35;
  }
}
