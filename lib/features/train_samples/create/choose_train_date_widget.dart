import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/train_info.dart';
import '../../../shared/color.dart';
import '../../../shared/components/colored_button.dart';
import '../train_shedule_pick_result.dart';

class ChooseTrainDateWidget extends StatefulWidget {
  const ChooseTrainDateWidget({super.key});

  @override
  State<ChooseTrainDateWidget> createState() => _ChooseTrainDateWidgetState();
}

class _ChooseTrainDateWidgetState extends State<ChooseTrainDateWidget> {
  DateTime? date;
  late final List<TrainSheduleDropDownItem> list;
  TrainScheduleTypes? type;
  @override
  void initState() {
    list = [
      TrainSheduleDropDownItem(
          value: TrainScheduleTypes.one_time, text: 'Один раз'),
      TrainSheduleDropDownItem(
          value: TrainScheduleTypes.every_week, text: 'Каждую неделю')
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month),
              TextButton(
                onPressed: () async {
                  final result = await showDatePicker(
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      context: context,
                      initialDate: date ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1));
                  if (result != null) {
                    setState(() {
                      date = result;
                    });
                  }
                },
                child: Text(
                  date == null
                      ? 'Выберите дату'
                      : DateFormat('yMMMEd', 'ru').format(date!),
                  style: TextStyle(fontSize: 18, color: AppColors.main),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.list),
              const SizedBox(
                width: 10,
              ),
              DropdownButton<TrainScheduleTypes>(
                value: type,
                items: list
                    .map((e) => DropdownMenuItem<TrainScheduleTypes>(
                          value: e.value,
                          child: Text(
                            e.text,
                            style: TextStyle(fontSize: 16),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          ColoredButton(
            isDisabled: type == null || date == null,
            width: 200,
            height: 50,
            onpressed: () {
              Navigator.of(context)
                  .pop(TrainShedulePickResult(date: date!, type: type!));
            },
            text: 'Создать',
            fontSize: 16,
            buttonColor: AppColors.accent,
          )
        ],
      ),
    );
  }
}
