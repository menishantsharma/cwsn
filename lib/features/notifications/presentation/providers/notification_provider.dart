import 'package:cwsn/core/providers/user_mode_provider.dart';
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
    // --- THE FIX IS HERE ---

    // 1. Listen for Parent/Caregiver Mode Switches
    ref.listen<bool>(userModeProvider, (previous, next) {
      if (previous != next) {
        fetch(); // Re-fetch when mode changes
      }
    });

    // 2. Listen for Login/Logout events
    ref.listen(currentUserProvider, (previous, next) {
      if (previous?.id != next?.id) {
        fetch(); // Re-fetch when user changes
      }
    });

    // 3. Initial fetch when the app loads
    fetch();
  }

  Future<void> fetch() async {
    try {
      // Set to loading so the UI shows the shimmer effect when switching tabs
      state = const AsyncValue.loading();

      final user = ref.read(currentUserProvider);
      final isCaregiver = ref.read(userModeProvider);

      if (user == null || user.isGuest) {
        state = const AsyncValue.data([]);
        return;
      }

      final repo = ref.read(notificationRepositoryProvider);
      final notifications = await repo.fetchNotifications(
        userId: user.id,
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
