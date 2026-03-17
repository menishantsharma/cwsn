import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the in-app notification list with optimistic read-state updates.
final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
      NotificationsNotifier.new,
    );

/// Fetches notifications for the current user's active role and handles
/// mark-as-read operations with rollback on failure.
class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  FutureOr<List<NotificationItem>> build() async {
    final (userId, isGuest, activeRole) = await ref.watch(
      currentUserProvider.selectAsync(
        (u) => (u?.id, u?.isGuest ?? true, u?.activeRole),
      ),
    );

    if (userId == null || isGuest) return [];

    final repo = ref.watch(notificationRepositoryProvider);

    return repo.fetchNotifications(
      userId: userId,
      isCaregiver: activeRole == UserRole.caregiver,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final previousState = state.value;
    final user = ref.read(currentUserProvider).value;

    if (previousState == null || user == null) return;

    final targetIndex = previousState.indexWhere((n) => n.id == notificationId);
    if (targetIndex == -1 || previousState[targetIndex].isRead) return;

    final bool isCaregiver = user.activeRole == UserRole.caregiver;

    state = AsyncData(
      previousState
          .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
          .toList(),
    );

    try {
      await ref
          .read(notificationRepositoryProvider)
          .markAsRead(notificationId: notificationId, isCaregiver: isCaregiver);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }

  Future<void> markAllAsRead() async {
    final previousState = state.value;
    final user = ref.read(currentUserProvider).value;

    if (previousState == null ||
        user == null ||
        previousState.every((n) => n.isRead)) {
      return;
    }

    final bool isCaregiver = user.activeRole == UserRole.caregiver;

    state = AsyncData(
      previousState.map((n) => n.copyWith(isRead: true)).toList(),
    );

    try {
      await ref
          .read(notificationRepositoryProvider)
          .markAllAsRead(userId: user.id, isCaregiver: isCaregiver);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }

  Future<void> refresh() async => ref.invalidateSelf();
}

/// Derived count of unread notifications for badge display.
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).value ?? [];
  return notifications.where((n) => !n.isRead).length;
});
