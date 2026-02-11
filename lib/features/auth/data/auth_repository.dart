import 'package:cwsn/core/data/user_data.dart';
import 'package:cwsn/core/models/user_model.dart';

class AuthRepository {
  Future<User> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  Future<User> signInWithFacebook() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  Future<User> signInWithApple() async {
    await Future.delayed(Duration(seconds: 2));
    return user;
  }

  Future<User> signInAsGuest() async {
    await Future.delayed(Duration(seconds: 2));
    return User(id: 'guest', firstName: 'Guest User');
  }
}
