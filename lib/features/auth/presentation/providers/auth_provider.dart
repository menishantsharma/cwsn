import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global authentication state. Emits the current [User] or null when logged out.
final currentUserProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

/// Manages authentication lifecycle only: login, logout, role switching.
///
/// Feature-specific profile mutations (children, services, profile edits)
/// are handled by their own notifiers, which call [updateUser] to write
/// back into this shared state.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }

  Future<void> loginWithGoogle() =>
      _authenticate(ref.read(authRepositoryProvider).signInWithGoogle);
  Future<void> loginWithApple() =>
      _authenticate(ref.read(authRepositoryProvider).signInWithApple);
  Future<void> loginWithFacebook() =>
      _authenticate(ref.read(authRepositoryProvider).signInWithFacebook);
  Future<void> loginAsGuest() =>
      _authenticate(ref.read(authRepositoryProvider).signInAsGuest);

  Future<void> _authenticate(Future<User> Function() authMethod) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => authMethod());
  }

  void logout() {
    state = const AsyncData(null);
  }

  void switchRole(UserRole newRole) {
    final currentUser = state.value;
    if (currentUser == null) return;
    state = AsyncData(currentUser.copyWith(activeRole: newRole));
  }

  /// Replaces the entire user object. Used by sibling notifiers
  /// (ChildNotifier, CaregiverServiceNotifier, UserProfileNotifier)
  /// after they persist changes through their repositories.
  void updateUser(User updatedUser) {
    state = AsyncData(updatedUser);
  }
}
