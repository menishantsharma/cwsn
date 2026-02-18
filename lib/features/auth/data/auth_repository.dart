import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);

abstract class AuthRepository {
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithApple();
  Future<User> signInAsGuest();
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInWithFacebook() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInWithApple() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInAsGuest() async {
    await Future.delayed(Duration(seconds: 2));
    return User(id: 'guest', firstName: 'Guest User', isGuest: true);
  }
}
