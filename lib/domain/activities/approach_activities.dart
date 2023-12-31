import 'package:app/domain/activities/activity.dart';

class WeightApproach {
  final int index;
  final String weight;
  final String count;
  WeightApproach({
    required this.index,
    required this.weight,
    required this.count,
  });

  bool validate() => weight != '' && count != '';

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'weight': weight,
      'count': count,
    };
  }

  factory WeightApproach.fromMap(Map<String, dynamic> map) {
    return WeightApproach(
        index: map['index']?.toInt() ?? 0,
        weight: map['weight'],
        count: map['count']);
  }

  WeightApproach copyWith({
    int? index,
    String? weight,
    String? count,
  }) {
    return WeightApproach(
      index: index ?? this.index,
      weight: weight ?? this.weight,
      count: count ?? this.count,
    );
  }
}

class WeightApproachActivity extends Activity {
  WeightApproachActivity({required this.approaches})
      : super(type: ActivityTypes.weightApproach);
  final List<WeightApproach> approaches;

  factory WeightApproachActivity.fromMap(Map<String, dynamic> map) {
    return WeightApproachActivity(
        approaches: (map['approaches'] as List)
            .map((e) => WeightApproach.fromMap(e))
            .toList());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      Activity.typeKey: type.toString(),
      'approaches': approaches.map((e) => e.toMap()).toList()
    };
  }

  WeightApproachActivity copyWith({
    List<WeightApproach>? approaches,
  }) {
    return WeightApproachActivity(
      approaches: approaches ?? this.approaches,
    );
  }

  @override
  bool validate() {
    if (approaches.isEmpty) {
      return false;
    }
    var result = approaches
        .map((e) => e.validate())
        .reduce((value, element) => value && element);
    return result;
  }
}

class Approach {
  final int index;
  final String count;
  Approach({
    required this.index,
    required this.count,
  });

  bool validate() => count.isNotEmpty;

  Map<String, dynamic> toMap() {
    return {'index': index, 'count': count};
  }

  factory Approach.fromMap(Map<String, dynamic> map) =>
      Approach(index: map['index'], count: map['count']);

  Approach copyWith({int? index, String? count}) {
    return Approach(index: index ?? this.index, count: count ?? this.count);
  }
}

class ApproachActivity extends Activity {
  List<Approach> approaches;
  ApproachActivity({required this.approaches})
      : super(type: ActivityTypes.approach);

  factory ApproachActivity.fromMap(Map<String, dynamic> map) {
    return ApproachActivity(
        approaches: (map['approaches'] as List)
            .map((e) => Approach.fromMap(e))
            .toList());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      Activity.typeKey: type.toString(),
      'approaches': approaches.map((e) => e.toMap()).toList()
    };
  }

  @override
  bool validate() {
    if (approaches.isEmpty) {
      return false;
    }
    var result = approaches
        .map((e) => e.validate())
        .reduce((value, element) => value && element);
    return result;
  }
}
