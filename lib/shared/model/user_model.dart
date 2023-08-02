import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Equatable {
  final String? id;
  final bool isAuthenticated;
  const UserModel({
    this.id,
    required this.isAuthenticated,
  });

  @override
  List<Object?> get props => [id, isAuthenticated];

  factory UserModel.fromFirebase(User? user) {
    return UserModel(isAuthenticated: user != null, id: user?.uid);
  }
}
