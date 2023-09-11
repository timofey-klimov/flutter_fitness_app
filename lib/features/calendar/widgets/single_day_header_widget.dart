import 'package:app/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../application/riverpod/calendar/pick_date.dart';
import '../../../shared/color.dart';

class SingleDayHeaderWidget extends StatelessWidget {
  const SingleDayHeaderWidget(
      {super.key, required this.pickedDate, required this.onUpdate});
  final void Function(PickDateModel pick) onUpdate;
  final PickDateModel pickedDate;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isDisable = pickedDate.start.equals(today);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IgnorePointer(
            ignoring: isDisable,
            child: IconButton(
              onPressed: () {
                onUpdate(pickedDate.prevDay());
              },
              icon: Icon(
                Icons.arrow_back,
                color:
                    isDisable ? AppColors.main.withOpacity(.5) : AppColors.main,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final today = DateTime.now();
              final result = await showDateRangePicker(
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  context: context,
                  firstDate: today,
                  lastDate: DateTime(today.year + 1));
              if (result == null) return;

              if (result.end == result.start) {
                onUpdate(pickedDate.single(result.start));
              } else {
                onUpdate(pickedDate.range(result.start, result.end));
              }
            },
            child: Text(
              DateFormat('d MMMM', 'ru').format(pickedDate.start),
              style: TextStyle(fontSize: 20, color: AppColors.main),
            ),
          ),
          IconButton(
            onPressed: () {
              onUpdate(pickedDate.nextDay());
            },
            icon: Icon(
              Icons.arrow_forward,
              color: AppColors.main,
            ),
          )
        ],
      ),
    );
  }
}
