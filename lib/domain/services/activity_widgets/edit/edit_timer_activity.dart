import 'package:app/domain/activities/timer_activity.dart';
import 'package:app/shared/color.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../train_samples_state.dart';

class EditTimerActivity extends StatefulWidget {
  final TimerActivity? activity;
  final int index;
  const EditTimerActivity(
      {super.key, required this.activity, required this.index});

  @override
  State<EditTimerActivity> createState() => _EditTimerActivityState();
}

class _EditTimerActivityState extends State<EditTimerActivity> {
  final hourDebounce = Debounce(duration: const Duration(milliseconds: 400));
  final minutesDebounce = Debounce(duration: const Duration(milliseconds: 400));
  final secondsDebounce = Debounce(duration: const Duration(milliseconds: 400));
  late TimeInterval timeInterval;
  @override
  void initState() {
    timeInterval = widget.activity == null
        ? TimeInterval.initial()
        : widget.activity!.timeInterval;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(trainSampleStateProvider.notifier);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HourPicker(
                value: timeInterval.hours,
                onChanged: (value) {
                  setState(() {
                    timeInterval = timeInterval.copyWith(hours: value);
                    hourDebounce.run(() {
                      notifier.updateActivity(widget.index,
                          TimerActivity(timeInterval: timeInterval));
                    });
                  });
                }),
            const Text(
              ':',
              style: TextStyle(fontSize: 18),
            ),
            MinutesPicker(
                value: timeInterval.minutes,
                onChanged: (value) {
                  setState(() {
                    timeInterval = timeInterval.copyWith(minutes: value);
                    minutesDebounce.run(() {
                      notifier.updateActivity(widget.index,
                          TimerActivity(timeInterval: timeInterval));
                    });
                  });
                }),
            const Text(
              ":",
              style: TextStyle(fontSize: 18),
            ),
            SecondsPicker(
              value: timeInterval.seconds,
              onChanged: (value) {
                setState(() {
                  timeInterval = timeInterval.copyWith(seconds: value);
                  hourDebounce.run(() {
                    notifier.updateActivity(widget.index,
                        TimerActivity(timeInterval: timeInterval));
                  });
                });
              },
            )
          ],
        );
      },
    );
  }
}

class HourPicker extends StatelessWidget {
  final int value;
  final Function(int value) onChanged;
  const HourPicker({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Picker(
        minValue: 0, maxValue: 23, onChanged: onChanged, value: value);
  }
}

class MinutesPicker extends StatelessWidget {
  final int value;
  final Function(int value) onChanged;
  const MinutesPicker(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Picker(
        minValue: 0, maxValue: 59, onChanged: onChanged, value: value);
  }
}

class SecondsPicker extends StatelessWidget {
  final int value;
  final Function(int value) onChanged;
  const SecondsPicker(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Picker(
        minValue: 0, maxValue: 59, onChanged: onChanged, value: value);
  }
}

class Picker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final Function(int value) onChanged;
  const Picker(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.onChanged,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: NumberPicker(
          textMapper: (numberText) {
            if (numberText.length == 1) {
              return "0$numberText";
            }
            return numberText;
          },
          selectedTextStyle: TextStyle(color: AppColors.accent, fontSize: 22),
          minValue: minValue,
          maxValue: maxValue,
          value: value,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          onChanged: onChanged),
    );
  }
}
