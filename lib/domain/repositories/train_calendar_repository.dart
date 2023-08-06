import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;

class TrainCalendarRepository {
  final table_name = 'train_calendares';
  final SupabaseClient client;
  TrainCalendarRepository({
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
}

final trainCalendarRepositoryProvider = rv.Provider(
    (ref) => TrainCalendarRepository(client: ref.read(supabaseProvider)));
