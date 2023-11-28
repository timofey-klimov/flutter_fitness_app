import 'dart:convert';

import 'package:app/domain/models/train.dart';
import 'package:app/domain/repository/train_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrainRepository implements ITrainRepository {
  final SupabaseClient client;
  TrainRepository({required this.client});
  @override
  Future createTrain(Train train, String userId) async {
    await client.from('trains').insert({
      'uuid': userId,
      'exercises': json.encode(train.exercises.map((x) => x.toMap()).toList()),
      'train_date': train.date.toIso8601String()
    });
  }

  @override
  Future<Map<DateTime, List<Train>>> getTrains(DateTimeRange range, String userId) async {
    List<dynamic> result;
      result = await client
          .from('trains')
          .select()
          .eq('uuid', userId)
          .gte('train_date', range.start.toIso8601String())
          .lte('train_date', range.end.toIso8601String())
          .order('train_date', ascending: true);
    final map = <DateTime, List<Train>>{};
    for (var el in result) {
      if (map.containsKey(DateTime.parse(el['train_date']))) {
        map.update(DateTime.parse(el['train_date']), (value) {
          value.add(Train.fromMap(el));
          return [...value];
        });
      } else {
        map.addAll({
          DateTime.parse(el['train_date']): <Train>[
           Train.fromMap(el)
          ]
        });
      }
    }

    return map;
  }
  
}