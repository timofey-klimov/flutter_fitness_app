import 'package:app/shared/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;

import '../models/sheduled_train_sample.dart';
import '../models/train_sample.dart';

class SheduledTrainSamplesRepository {
  final table_name = 'sheduled_train_samples';
  final SupabaseClient client;
  SheduledTrainSamplesRepository({
    required this.client,
  });

  Future<String> sheduleTrain(
      String sampleId, String uuid, DateTime date) async {
    final result = await client.from(table_name).insert({
      'uuid': uuid,
      'sample_id': sampleId,
      'train_date': date.toIso8601String()
    }).select('id');
    return result[0]['id'];
  }

  Future<Map<DateTime, List<SheduledTrainSample>>> getScheduledTrains(
      String uuid, DateTime start,
      {DateTime? end}) async {
    List<dynamic> result;
    if (end == null) {
      result = await client
          .from(table_name)
          .select('*,train_samples!inner(*)')
          .eq('train_samples.uuid', uuid)
          .eq('train_date', start.toIso8601String());
    } else {
      result = await client
          .from(table_name)
          .select('*,train_samples!inner(*)')
          .eq('train_samples.uuid', uuid)
          .gte('train_date', start.toIso8601String())
          .lte('train_date', end!.toIso8601String())
          .order('train_date', ascending: true);
    }
    final map = <DateTime, List<SheduledTrainSample>>{};
    for (var el in result) {
      if (map.containsKey(DateTime.parse(el['train_date']))) {
        map.update(DateTime.parse(el['train_date']), (value) {
          value.add(SheduledTrainSample(
              id: el['id'],
              trainSample:
                  TrainSample.fromJson(el['train_samples']['sample'])));
          return [...value];
        });
      } else {
        map.addAll({
          DateTime.parse(el['train_date']): <SheduledTrainSample>[
            SheduledTrainSample(
                id: el['id'],
                trainSample:
                    TrainSample.fromJson(el['train_samples']['sample']))
          ]
        });
      }
    }

    return map;
  }

  Future remove(String id) async {
    await client.from(table_name).delete().eq('id', id);
  }

  Future reschedule(String id, DateTime date) async {
    await client
        .from(table_name)
        .update({'train_date': date.toIso8601String()}).eq('id', id);
  }
}

final sheduledTrainSampleRepositoryProvider = rv.Provider((ref) =>
    SheduledTrainSamplesRepository(client: ref.read(supabaseProvider)));
