import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => FakeNotificationRepository(),
);

abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
  });

  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}

class FakeNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // MOCK RESPONSE
    if (isCaregiver) {
      return [
        NotificationItem(
          id: 'c1',
          title: 'New Service Request',
          subtitle: 'A parent has requested your services for their child.',
          imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: NotificationType
              .requestReceived, // Caregivers get received requests
        ),
      ];
    } else {
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
          imageUrl: 'https://randomuser.me/api/portraits/lego/1.jpg',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
          type: NotificationType.system,
        ),
      ];
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
