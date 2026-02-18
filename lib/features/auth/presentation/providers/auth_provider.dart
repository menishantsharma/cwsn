import 'dart:async';

import 'package:cwsn/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = AsyncNotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  Future<void> login(Future<User> Function() loginMethod) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await loginMethod();
      return user;
    });
  }

  void logout() {
    state = AsyncData(null);
  }

  void switchRole(UserRole newRole) {
    final currentUser = state.value;
    if (currentUser == null) return;
    state = AsyncData(currentUser.copyWith(activeRole: newRole));
  }

  void updateParentProfile(ParentModel updatedProfile) {
    final currentUser = state.value;
    if (currentUser == null) return;
    state = AsyncData(currentUser.copyWith(parentProfile: updatedProfile));
  }

  void updateProfile(User updatedUser) {
    state = AsyncData(updatedUser);
  }
}
