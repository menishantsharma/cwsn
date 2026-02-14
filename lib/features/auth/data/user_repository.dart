import 'package:cwsn/core/models/user_model.dart';

class UserRepository {
  Future<User> updateUserProfile(User updatedUser) async {
    await Future.delayed(const Duration(seconds: 1));
    return updatedUser;
  }
}
