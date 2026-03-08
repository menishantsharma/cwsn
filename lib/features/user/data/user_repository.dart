import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => FakeUserRepository(),
);

abstract class UserRepository {
  Future<User> updateUserProfile(User updatedUser);
}

class FakeUserRepository implements UserRepository {
  @override
  Future<User> updateUserProfile(User updatedUser) async {
    await Future.delayed(const Duration(seconds: 1));
    return updatedUser;
  }
}
