import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

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
    state = await AsyncValue.guard(() async {
      return await authMethod();
    });
  }

  void logout() {
    state = const AsyncData(null);
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

  void updateCaregiverProfile(CaregiverProfile updatedProfile) {
    final currentUser = state.value;
    if (currentUser == null) return;
    state = AsyncData(currentUser.copyWith(caregiverProfile: updatedProfile));
  }

  void updateProfile(User updatedUser) {
    state = AsyncData(updatedUser);
  }
}
