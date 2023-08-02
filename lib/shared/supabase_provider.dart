import 'package:flutter_riverpod/flutter_riverpod.dart' as rv;
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = rv.Provider((ref) => Supabase.instance.client);
