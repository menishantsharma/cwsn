import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The modern AsyncNotifierProvider for Notifications
final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(() {
      return NotificationsNotifier();
    });

class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  FutureOr<List<NotificationItem>> build() async {
    // 1. REACTIVE DEPENDENCY (The Magic part ✨)
    // By using ref.watch here, Riverpod automatically tracks this provider.
    // If the user logs out, logs in, or switches roles, this build() method
    // is automatically re-run. No manual ref.listen() needed!
    final user = ref.watch(currentUserProvider).value;

    if (user == null || user.isGuest) {
      return []; // Return empty instantly for guests/logged out
    }

    final isCaregiver = user.activeRole == UserRole.caregiver;

    // 2. Fetch data (State automatically becomes AsyncLoading while this awaits)
    final repo = ref.watch(notificationRepositoryProvider);
    return await repo.fetchNotifications(
      userId: user.id,
      isCaregiver: isCaregiver,
    );
  }

  // --- ACTIONS ---

  Future<void> markAsRead(String notificationId) async {
    // state.valueOrNull safely gets current data without crashing if loading/error
    final currentList = state.value;
    if (currentList == null) return;

    final targetIndex = currentList.indexWhere((n) => n.id == notificationId);
    if (targetIndex == -1 || currentList[targetIndex].isRead) return;

    // 1. OPTIMISTIC UPDATE: Update UI instantly without waiting for backend
    state = AsyncData(
      currentList.map((n) {
        return n.id == notificationId ? n.copyWith(isRead: true) : n;
      }).toList(),
    );

    // 2. BACKGROUND SYNC
    try {
      await ref.read(notificationRepositoryProvider).markAsRead(notificationId);
    } catch (e) {
      // If the backend fails, silently revert the local UI state back to unread
      state = AsyncData(currentList);
    }
  }

  Future<void> markAllAsRead() async {
    final currentList = state.value;
    if (currentList == null || currentList.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    // 1. OPTIMISTIC UPDATE
    state = AsyncData(
      currentList.map((n) => n.copyWith(isRead: true)).toList(),
    );

    // 2. BACKGROUND SYNC
    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead(user.id);
    } catch (e) {
      // Revert on failure
      state = AsyncData(currentList);
    }
  }

  /// Optional: Easy helper for "Pull to Refresh" in your UI
  Future<void> refresh() async {
    // This forces the provider to drop its state and run build() again
    ref.invalidateSelf();
  }
}
