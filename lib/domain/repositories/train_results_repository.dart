import 'package:app/domain/models/train_result.dart';
import 'package:app/shared/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrainResultsRepository {
  final table_name = 'train_results';
  final SupabaseClient client;
  TrainResultsRepository({required this.client});

  Future<String> insert(TrainResult trainResult) async {
    final result = await client.from(table_name).insert({
      'status': trainResult.status.toString(),
      'plan': trainResult.plan,
      'fact': trainResult.fact,
      'train_date': trainResult.date.toIso8601String()
    }).select('id');
    return result[0]['id'];
  }
}
