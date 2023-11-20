import 'package:app/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class IAuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future signOut();
}