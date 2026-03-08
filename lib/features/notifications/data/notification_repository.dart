import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to access the notification repository throughout the app.
final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => FakeNotificationRepository(),
);

/// The blueprint for notification data operations.
abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
    int limit = 20,
    int offset = 0,
  });

  Future<void> markAsRead({
    required String notificationId,
    required bool isCaregiver,
  });
  Future<void> markAllAsRead({
    required String userId,
    required bool isCaregiver,
  });
}

/// A stateful mock repository that persists changes in memory during the app session.
class FakeNotificationRepository implements NotificationRepository {
  // Separate in-memory databases to prevent role-switch data bleeding.
  List<NotificationItem>? _parentDb;
  List<NotificationItem>? _caregiverDb;

  @override
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (isCaregiver) {
      _caregiverDb ??= _generateCaregiverMocks();
    } else {
      _parentDb ??= _generateParentMocks();
    }

    final activeDb = isCaregiver ? _caregiverDb! : _parentDb!;

    if (offset >= activeDb.length) return [];

    final end = (offset + limit) > activeDb.length
        ? activeDb.length
        : offset + limit;

    return activeDb.sublist(offset, end);
  }

  @override
  Future<void> markAsRead({
    required String notificationId,
    required bool isCaregiver,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (isCaregiver && _caregiverDb != null) {
      _updateInList(_caregiverDb!, notificationId);
    } else if (!isCaregiver && _parentDb != null) {
      _updateInList(_parentDb!, notificationId);
    }
  }

  void _updateInList(List<NotificationItem> list, String id) {
    final index = list.indexWhere((n) => n.id == id);
    if (index != -1) {
      list[index] = list[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead({
    required String userId,
    required bool isCaregiver,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (isCaregiver) {
      _caregiverDb = _caregiverDb
          ?.map((n) => n.copyWith(isRead: true))
          .toList();
    } else {
      _parentDb = _parentDb?.map((n) => n.copyWith(isRead: true)).toList();
    }
  }

  List<NotificationItem> _generateCaregiverMocks() {
    return [
      NotificationItem(
        id: 'c1',
        title: 'New Service Request',
        subtitle: 'A parent has requested your services for their child.',
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.requestReceived,
        relatedId: 'req_889',
      ),
    ];
  }

  List<NotificationItem> _generateParentMocks() {
    return [
      NotificationItem(
        id: 'p1',
        title: 'Request Accepted!',
        subtitle: 'Sarah Jenkins has accepted your caregiving request.',
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        type: NotificationType.requestAccepted,
        relatedId: 'caregiver_123',
      ),
      NotificationItem(
        id: 'p2',
        title: 'Welcome to CWSN',
        subtitle: 'Complete your profile to get the best matches.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.system,
      ),
    ];
  }
}
