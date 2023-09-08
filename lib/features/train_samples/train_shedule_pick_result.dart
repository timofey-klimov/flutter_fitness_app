import 'package:app/domain/models/train_info.dart';

class TrainShedulePickResult {
  final DateTime date;
  final TrainScheduleTypes type;
  TrainShedulePickResult({
    required this.date,
    required this.type,
  });
}

class TrainSheduleDropDownItem {
  final TrainScheduleTypes value;
  final String text;
  TrainSheduleDropDownItem({
    required this.value,
    required this.text,
  });
}
