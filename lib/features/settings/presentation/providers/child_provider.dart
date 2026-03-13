import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/settings/data/child_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [ChildNotifier] for managing children profiles.
final childNotifierProvider = Provider<ChildNotifier>((ref) {
  return ChildNotifier(ref);
});

/// Manages CRUD operations on a parent's children list.
///
/// Reads the current user from [currentUserProvider], mutates the
/// parent profile through [ChildRepository], and writes the result
/// back via [AuthNotifier.updateUser].
class ChildNotifier {
  final Ref _ref;
  const ChildNotifier(this._ref);

  User? get _user => _ref.read(currentUserProvider).value;
  AuthNotifier get _auth => _ref.read(currentUserProvider.notifier);
  ChildRepository get _repo => _ref.read(childRepositoryProvider);

  /// Adds a new child. Returns the saved [ChildModel] with server-assigned ID.
  Future<ChildModel> addChild(ChildModel child) async {
    final user = _user;
    if (user == null) throw StateError('No authenticated user');

    final saved = await _repo.addChild(parentId: user.id, child: child);

    final currentChildren = user.parentProfile?.children ?? [];
    final updatedProfile = (user.parentProfile ?? const ParentModel()).copyWith(
      children: [...currentChildren, saved],
    );
    _auth.updateUser(user.copyWith(parentProfile: updatedProfile));
    return saved;
  }

  /// Updates an existing child. Returns the updated [ChildModel].
  Future<ChildModel> updateChild(ChildModel child) async {
    final user = _user;
    if (user == null) throw StateError('No authenticated user');

    final saved = await _repo.updateChild(parentId: user.id, child: child);

    final updatedChildren = (user.parentProfile?.children ?? [])
        .map((c) => c.id == saved.id ? saved : c)
        .toList();
    final updatedProfile = (user.parentProfile ?? const ParentModel()).copyWith(
      children: updatedChildren,
    );
    _auth.updateUser(user.copyWith(parentProfile: updatedProfile));
    return saved;
  }

  /// Deletes a child with optimistic removal and rollback on failure.
  Future<void> deleteChild(ChildModel child) async {
    final user = _user;
    if (user == null) return;
    final previousProfile = user.parentProfile!;

    // Optimistic removal
    final optimistic = previousProfile.copyWith(
      children: previousProfile.children
          .where((c) => c.id != child.id)
          .toList(),
    );
    _auth.updateUser(user.copyWith(parentProfile: optimistic));

    try {
      await _repo.deleteChild(parentId: user.id, childId: child.id);
    } catch (_) {
      // Rollback
      _auth.updateUser(user.copyWith(parentProfile: previousProfile));
      rethrow;
    }
  }
}
