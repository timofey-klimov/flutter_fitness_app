import 'package:app/domain/activities/activity.dart';

class WeigthApproach {
  final int index;
  final double weight;
  final int count;
  WeigthApproach({
    required this.index,
    required this.weight,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'weight': weight,
      'count': count,
    };
  }

  factory WeigthApproach.fromMap(Map<String, dynamic> map) {
    return WeigthApproach(
      index: map['index']?.toInt() ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      count: map['count']?.toInt() ?? 0,
    );
  }
}

class WeightApproachActivity extends Activity {
  WeightApproachActivity({required this.approaches})
      : super(type: ActivityTypes.weightApproach);
  final List<WeigthApproach> approaches;

  factory WeightApproachActivity.fromMap(Map<String, dynamic> map) {
    return WeightApproachActivity(
        approaches: (map['approaches'] as List)
            .map((e) => WeigthApproach.fromMap(e))
            .toList());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      Activity.typeKey: type.toString(),
      'approaches': approaches.map((e) => e.toMap()).toList()
    };
  }
}
