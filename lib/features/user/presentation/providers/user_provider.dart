import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/user/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [UserProfileNotifier] for editing the user's profile.
final userProfileNotifierProvider = Provider<UserProfileNotifier>((ref) {
  return UserProfileNotifier(ref);
});

/// Handles full profile edits (name, location, phone, gender, languages).
///
/// Persists through [UserRepository] and writes the result back
/// to [currentUserProvider] via [AuthNotifier.updateUser].
class UserProfileNotifier {
  final Ref _ref;
  const UserProfileNotifier(this._ref);

  /// Saves the updated user profile to the backend.
  /// Returns the persisted [User] so the caller can pop first,
  /// then write back to [currentUserProvider] without triggering
  /// a GoRouter refresh before navigation completes.
  Future<User> saveProfile(User updatedUser) async {
    final repo = _ref.read(userRepositoryProvider);
    return repo.updateUserProfile(updatedUser);
  }
}
