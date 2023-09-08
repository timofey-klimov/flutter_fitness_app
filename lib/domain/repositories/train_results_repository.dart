import 'package:app/domain/models/train_result.dart';
import 'package:app/shared/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;

class TrainResultsRepository {
  final table_name = 'train_results';
  final SupabaseClient client;
  TrainResultsRepository({required this.client});

  Future<String> insert(TrainResult trainResult) async {
    final result = await client.from(table_name).insert({
      'status': trainResult.status.toString(),
      'plan': trainResult.plan,
      'fact': trainResult.fact
    }).select('id');
    return result[0]['id'];
  }
}

final trainResultsRepositoryProvider = rv.Provider(
  (ref) => TrainResultsRepository(client: ref.read(supabaseProvider)),
);
