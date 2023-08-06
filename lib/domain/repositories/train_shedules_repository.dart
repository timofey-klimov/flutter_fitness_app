import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import '../../shared/supabase_provider.dart';
import '../models/train_shedule.dart';

class TrainSchedulesRepository {
  final table_name = 'train_schedules';
  final SupabaseClient client;
  TrainSchedulesRepository({
    required this.client,
  });

  Future<String> insert(TrainSchedule schedule) async {
    final result =
        await client.from(table_name).insert(schedule.toMap()).select();
    return result['id'];
  }
}

final trainScheduleRepositoryProvider = rv.Provider(
    (ref) => TrainSchedulesRepository(client: ref.read(supabaseProvider)));
