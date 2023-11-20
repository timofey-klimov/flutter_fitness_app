import 'package:app/domain/models/user_model.dart';
import 'package:app/domain/repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final FirebaseAuth authService;
  AuthenticationRepository({required this.authService}); 

  @override
  Stream<UserModel> getCurrentUser() {
    return authService.authStateChanges().map((User? user) {
      if (user != null) {
        return UserModel(uid: user.uid, email: user.email);
      } else {
        return  UserModel(uid: "uid");
      }
    });
  }

  @override
  Future<UserCredential?> signUp(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email!,password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) async {
     try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }
  
  @override
  Future signOut() async {
    await authService.signOut();
  }
}