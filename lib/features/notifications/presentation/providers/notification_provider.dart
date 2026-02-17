import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final notificationsProvider =
    StateNotifierProvider<
      NotificationsNotifier,
      AsyncValue<List<NotificationItem>>
    >((ref) {
      return NotificationsNotifier(ref);
    });

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<NotificationItem>>> {
  final Ref ref;

  NotificationsNotifier(this.ref) : super(const AsyncValue.loading()) {
    ref.listen(currentUserProvider, (previous, next) {
      if (previous?.id != next?.id ||
          previous?.activeRole != next?.activeRole) {
        fetch(user: next); // Re-fetch when mode changes
      }
    });

    // Initial fetch when the app loads
    fetch(user: ref.read(currentUserProvider));
  }

  Future<void> fetch({User? user}) async {
    try {
      // Set to loading so the UI shows the shimmer effect when switching tabs
      state = const AsyncValue.loading();

      final currentUser = user ?? ref.read(currentUserProvider);

      if (currentUser == null || currentUser.isGuest) {
        state = const AsyncValue.data([]);
        return;
      }

      final isCaregiver = currentUser.activeRole == UserRole.caregiver;
      final repo = ref.read(notificationRepositoryProvider);
      final notifications = await repo.fetchNotifications(
        userId: currentUser.id,
        isCaregiver: isCaregiver,
      );

      if (mounted) {
        state = AsyncValue.data(notifications);
      }
    } catch (e, stack) {
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  void markAsRead(String notificationId) async {
    final currentList = state.value;
    if (currentList == null) return;

    // Check if it exists and is already read
    final targetIndex = currentList.indexWhere((n) => n.id == notificationId);
    if (targetIndex == -1 || currentList[targetIndex].isRead) return;

    // 1. OPTIMISTIC UPDATE: Update UI instantly
    state = AsyncValue.data(
      currentList.map((n) {
        return n.id == notificationId ? n.copyWith(isRead: true) : n;
      }).toList(),
    );

    // 2. UPDATE BACKEND
    try {
      await ref.read(notificationRepositoryProvider).markAsRead(notificationId);
    } catch (e) {
      // Revert local state if backend fails
      if (mounted) state = AsyncValue.data(currentList);
    }
  }

  Future<void> markAllAsRead() async {
    final currentList = state.value;
    if (currentList == null) return;

    // Instantly mark all as read in the UI
    state = AsyncValue.data(
      currentList.map((n) => n.copyWith(isRead: true)).toList(),
    );

    final user = ref.read(currentUserProvider);
    if (user != null) {
      await ref.read(notificationRepositoryProvider).markAllAsRead(user.id);
    }
  }
}
