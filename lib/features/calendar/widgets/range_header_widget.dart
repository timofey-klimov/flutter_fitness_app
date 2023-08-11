import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/color.dart';
import '../pick_date_model.dart';

class RangeHeaderWidget extends StatelessWidget {
  const RangeHeaderWidget(
      {super.key, required this.onUpdate, required this.pickedDate});
  final void Function(PickDateModel pick) onUpdate;
  final PickDateModel pickedDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              final today = DateTime.now();
              final result = await showDateRangePicker(
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  context: context,
                  firstDate: DateTime(today.year - 1),
                  lastDate: DateTime(today.year + 1));
              if (result == null) return;

              if (result.end == result.start) {
                onUpdate(pickedDate.single(result.start));
              } else {
                onUpdate(pickedDate.range(result.start, result.end));
              }
            },
            child: Text(
              '${DateFormat('d MMMM', 'ru').format(pickedDate.start)} - ${DateFormat('d MMMM', 'ru').format(pickedDate.end!)}',
              style: TextStyle(fontSize: 20, color: AppColors.main),
            ),
          ),
        ],
      ),
    );
  }
}
