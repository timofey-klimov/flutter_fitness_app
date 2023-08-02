import 'package:app/shared/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseProvider = Provider((ref) => FirebaseAuth.instance);
final firebaseUserProvider = StreamProvider((ref) {
  final auth = ref.watch(firebaseProvider);
  final appUserNotifier = ref.read(appUserProvider.notifier);
  return auth.authStateChanges().map((user) {
    appUserNotifier.authUser(UserModel.fromFirebase(user));
    return user;
  });
});

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel(isAuthenticated: false));
  authUser(UserModel model) => state = model;
}

final appUserProvider =
    StateNotifierProvider<UserNotifier, UserModel>((ref) => UserNotifier());
