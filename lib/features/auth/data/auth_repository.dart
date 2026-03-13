import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [AuthRepository] implementation.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);

/// Contract for authentication operations (social sign-in, guest access).
abstract class AuthRepository {
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithApple();
  Future<User> signInAsGuest();
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<User> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInWithFacebook() async {
    await Future.delayed(const Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInWithApple() async {
    await Future.delayed(const Duration(seconds: 2));
    return user;
  }

  @override
  Future<User> signInAsGuest() async {
    await Future.delayed(const Duration(seconds: 2));
    return User(id: 'guest', firstName: 'Guest User', isGuest: true);
  }
}
