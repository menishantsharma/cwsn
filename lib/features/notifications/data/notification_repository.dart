import 'package:cwsn/features/notifications/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider(
  (ref) => NotificationRepository(),
);

class NotificationRepository {
  // 1. FETCH NOTIFICATIONS
  Future<List<NotificationItem>> fetchNotifications({
    required String userId,
    required bool isCaregiver,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

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
          type: NotificationType.requestAccepted, // Parents get accepted alerts
          relatedId: 'caregiver_123', // ID needed to open Caregiver Profile
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

  // 2. UPDATE READ STATUS IN BACKEND
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // 3. MARK ALL AS READ
  Future<void> markAllAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
