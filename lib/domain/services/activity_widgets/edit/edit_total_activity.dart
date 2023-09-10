import 'package:app/domain/activities/total_activity.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/color.dart';
import '../../train_samples_state.dart';

class EditTotalActivityWidget extends StatefulWidget {
  final TotalActivity? activity;
  final int index;
  const EditTotalActivityWidget(
      {super.key, required this.activity, required this.index});

  @override
  State<EditTotalActivityWidget> createState() => _EditTotalActivityState();
}

class _EditTotalActivityState extends State<EditTotalActivityWidget> {
  late final Debounce debounceTotal;
  @override
  void initState() {
    debounceTotal = Debounce(duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Consumer(
        builder: (ctx, ref, child) {
          final notifier = ref.read(trainSampleStateProvider.notifier);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Общее количество:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 7,
              ),
              SizedBox(
                width: 80,
                child: TextFormField(
                  cursorColor: AppColors.accent,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                  decoration: const InputDecoration(
                      hintText: 'кол-во',
                      hintStyle: TextStyle(color: Colors.grey)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  initialValue: widget.activity?.total,
                  onChanged: (value) {
                    debounceTotal.run(() {
                      notifier.updateActivity(
                          widget.index, TotalActivity(total: value));
                    });
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
