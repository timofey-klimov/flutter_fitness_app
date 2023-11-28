import 'package:app/features/history/model/pick_date_model.dart';
import 'package:app/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/color.dart';

class RangeHeaderWidget extends StatelessWidget {
  const RangeHeaderWidget(
      {super.key, required this.onUpdate, required this.pickedDate});
  final void Function(PickDateModel pick) onUpdate;
  final PickDateModel pickedDate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Align(
              child: TextButton(
                onPressed: () async {
                  final today = DateTime.now();
                  final result = await showDateRangePicker(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      context: context,
                      firstDate:
                          DateTime(today.year, today.month - 1, today.day),
                      lastDate: DateTime.now());
                  if (result == null) return;

                  onUpdate(pickedDate.copyWith(
                      start: result.start, end: result.end));
                },
                child: Text(
                  '${DateFormat('d MMMM', 'ru').format(pickedDate.dateTimeRange.start)} - ${DateFormat('d MMMM', 'ru').format(pickedDate.dateTimeRange.end)}',
                  style: TextStyle(fontSize: 20, color: AppColors.main),
                ),
              ),
            ),
            Positioned(
              right: 3,
              child: IconButton(
                color: AppColors.main,
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.CreateTrainsScreen);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
