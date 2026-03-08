import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => FakeNotificationRepository(),
);

abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
    int limit = 20,
    int offset = 0,
  });

  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}

class FakeNotificationRepository implements NotificationRepository {
  List<NotificationItem>? _inMemoryDb;

  @override
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    _inMemoryDb = isCaregiver
        ? _generateCaregiverMocks()
        : _generateParentMocks();

    if (offset >= _inMemoryDb!.length) return [];

    final end = (offset + limit) > _inMemoryDb!.length
        ? _inMemoryDb!.length
        : offset + limit;

    return _inMemoryDb!.sublist(offset, end);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
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
