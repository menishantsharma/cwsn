enum NotificationType { message, request, alert, system }

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.system,
  });
}
