import 'package:app/features/calendar/pick_date_model.dart';
import 'package:app/features/calendar/widgets/range_header_widget.dart';
import 'package:app/features/calendar/widgets/single_day_header_widget.dart';
import 'package:app/features/calendar/widgets/trains_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/providers/calendar_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late PickDateModel pickDate;
  @override
  void initState() {
    pickDate = PickDateModel.initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(calendarNotifierProvider, (prev, next) {
          if (next is CalendarPageReload) {
            setState(() {});
          }
        });
        return Flex(
          direction: Axis.vertical,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pickDate.type == PickDateType.single
                  ? SingleDayHeaderWidget(
                      pickedDate: pickDate,
                      onUpdate: (pick) => setState(
                        () {
                          pickDate = pick;
                        },
                      ),
                    )
                  : RangeHeaderWidget(
                      pickedDate: pickDate,
                      onUpdate: (pick) => setState(
                        () {
                          pickDate = pick;
                        },
                      ),
                    ),
            ),
            Expanded(
              child: Trains(
                pickDate: pickDate,
              ),
            )
          ],
        );
      },
    );
  }
}
