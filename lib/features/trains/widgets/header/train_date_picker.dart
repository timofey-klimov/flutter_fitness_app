import 'package:app/features/trains/bloc/state/train_state.dart';
import 'package:app/features/trains/bloc/train_bloc.dart';
import 'package:app/features/trains/bloc/train_event.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TrainDatePickerWidget extends StatelessWidget {
  const TrainDatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TrainBloc>();
    return BlocBuilder<TrainBloc, TrainState>(
      builder: (ctx, state) {
        state as CreateTrainState;
        return TextButton(
          onPressed: () async {
            final today = DateTime.now();
            final result = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                firstDate:
                    DateTime(today.year, today.month - 1, today.day),
                lastDate: DateTime.now());
            if (result == null) return;
            bloc.add(TrainDateUpdateEvent(date: result));
          },
          child: Text(
            DateFormat('MMMMEEEEd', 'ru').format(state.trainDate),
            style: TextStyle(fontSize: 20, color: AppColors.main),
          ),
        );
      },
    );
  }
}
