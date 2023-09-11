import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/domain/models/train_sample.dart';
import 'package:app/shared/model/user_model.dart';

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
}
