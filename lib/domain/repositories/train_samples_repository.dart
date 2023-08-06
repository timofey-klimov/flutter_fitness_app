import 'package:app/shared/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;

class TrainSampleRepository {
  final table_name = 'train_samples';
  final SupabaseClient client;
  TrainSampleRepository({
    required this.client,
  });

  Future<String> insert(TrainSample sample, UserModel userModel) async {
    final result = await client
        .from(table_name)
        .insert({'uuid': userModel.id, 'sample': sample.toJson()}).select('id');
    return result[0]['id'];
  }

  Future<List<TrainSample>> getTrainsByDate(DateTime date, String uuid) async {
    final result = await client
        .from(table_name)
        .select('train_samples.*,train_calendares!inner(*)')
        .eq('uuid', uuid)
        .eq('train_calendares.train_date', date.toIso8601String());
    return [];
  }
}

final trainSampleRepositoryProvider = rv.Provider(
    (ref) => TrainSampleRepository(client: ref.read(supabaseProvider)));
