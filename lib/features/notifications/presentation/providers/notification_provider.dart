import 'dart:async';
import 'package:cwsn/core/models/user_model.dart';
import 'package:cwsn/features/auth/presentation/providers/auth_provider.dart';
import 'package:cwsn/features/notifications/data/notification_repository.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(() {
      return NotificationsNotifier();
    });

class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  FutureOr<List<NotificationItem>> build() async {
    final user = ref.watch(currentUserProvider).value;

    if (user == null || user.isGuest) {
      return [];
    }

    final isCaregiver = user.activeRole == UserRole.caregiver;

    final repo = ref.watch(notificationRepositoryProvider);
    return await repo.fetchNotifications(
      userId: user.id,
      isCaregiver: isCaregiver,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final currentList = state.value;
    if (currentList == null) return;

    final targetIndex = currentList.indexWhere((n) => n.id == notificationId);
    if (targetIndex == -1 || currentList[targetIndex].isRead) return;

    state = AsyncData(
      currentList.map((n) {
        return n.id == notificationId ? n.copyWith(isRead: true) : n;
      }).toList(),
    );

    try {
      await ref.read(notificationRepositoryProvider).markAsRead(notificationId);
    } catch (e) {
      state = AsyncData(currentList);
    }
  }

  Future<void> markAllAsRead() async {
    final currentList = state.value;
    if (currentList == null || currentList.isEmpty) return;

    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = AsyncData(
      currentList.map((n) => n.copyWith(isRead: true)).toList(),
    );

    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead(user.id);
    } catch (e) {
      state = AsyncData(currentList);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
