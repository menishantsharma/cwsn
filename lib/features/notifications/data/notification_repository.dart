import 'package:cwsn/features/notifications/models/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications({
    required bool isCaregiver,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (isCaregiver) {
      return [
        NotificationItem(
          id: '1',
          title: 'Sarah Jenkins (Parent)',
          subtitle: 'Has requested a booking for tomorrow at 10:00 AM.',
          imageUrl: 'https://i.pravatar.cc/150?u=1',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          type: NotificationType.request,
        ),
        NotificationItem(
          id: '2',
          title: 'System Alert',
          subtitle: 'Your profile verification is complete.',
          imageUrl:
              'https://ui-avatars.com/api/?name=System&background=0D8ABC&color=fff',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: NotificationType.alert,
          isRead: true,
        ),
      ];
    } else {
      return [
        NotificationItem(
          id: '3',
          title: 'Dr. Emily Stones',
          subtitle: 'Accepted your request for "Physical Therapy".',
          imageUrl: 'https://i.pravatar.cc/150?u=3',
          timestamp: DateTime.now(),
          type: NotificationType.message,
        ),
        NotificationItem(
          id: '4',
          title: 'Reminder',
          subtitle: 'Appointment with Nurse Joy starts in 1 hour.',
          imageUrl:
              'https://ui-avatars.com/api/?name=System&background=FF9800&color=fff',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          type: NotificationType.system,
          isRead: true,
        ),
      ];
    }
  }
}
