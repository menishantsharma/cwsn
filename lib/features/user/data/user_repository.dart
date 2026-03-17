import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => FakeUserRepository(),
);

abstract class UserRepository {
  Future<User> updateUserProfile(User updatedUser);
  Future<String> uploadProfileImage(String userId, String filePath);
}

class FakeUserRepository implements UserRepository {
  @override
  Future<User> updateUserProfile(User updatedUser) async {
    await Future.delayed(const Duration(seconds: 1));
    return updatedUser;
  }

  @override
  Future<String> uploadProfileImage(String userId, String filePath) async {
    // Simulate upload delay; real backend would return a remote URL.
    await Future.delayed(const Duration(seconds: 1));
    return filePath;
  }
}
