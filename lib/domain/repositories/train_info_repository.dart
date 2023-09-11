import 'package:app/shared/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/train_info.dart';

class TrainInfoRepository {
  final table_name = 'trains_info';
  final SupabaseClient client;
  TrainInfoRepository({
    required this.client,
  });

  Future<String> insert(TrainInfo schedule, UserModel user) async {
    final result = await client.from(table_name).insert({
      'sample_id': schedule.sample_id,
      'schedule_type': schedule.shedule_type.toString(),
      'uuid': user.id
    }).select('id');
    return result[0]['id'];
  }
}
