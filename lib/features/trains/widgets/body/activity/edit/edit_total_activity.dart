import 'package:app/domain/activities/total_activity.dart';
import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/shared/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../shared/color.dart';

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
        child: Row(
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
                    context.read<TrainBloc>().add(UpdateActivityEvent(
                        activity: TotalActivity(total: value),
                        index: widget.index));
                  });
                },
              ),
            )
          ],
        ));
  }
}
