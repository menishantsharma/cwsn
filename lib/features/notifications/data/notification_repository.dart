import 'package:cwsn/features/caregivers/models/caregiver_model.dart';
import 'package:cwsn/features/notifications/models/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      NotificationItem(
        id: '1',
        caregiver: Caregiver(
          id: 'cg_1',
          name: 'Nishant Sharma',
          imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        ),
        message: 'has accepted your request.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),

      NotificationItem(
        id: '2',
        caregiver: Caregiver(
          id: 'cg_2',
          name: 'Nisha Sharma',
          imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
        ),
        message: 'has accepted your request.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
    ];
  }
}
